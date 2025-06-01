import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_for_rent/Models/room_model.dart';
import 'package:home_for_rent/Models/user_data_model.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class AuthRepo {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseDatabase fdb = FirebaseDatabase.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  static User? get user => auth.currentUser;

  /// 🔹 Sign Up with Email & Password
  static Future<UserCredential> signup(
      String email, String pwd, String name) async {
    try {
      final userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      final user = userCred.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await fdb.ref("Users").child(user.uid).set({
          "name": name,
          "email": user.email,
          "phoneNumber": user.phoneNumber,
          "photoURL": user.photoURL,
          "uid": user.uid,
        });
      }
      return userCred;
    } catch (e) {
      rethrow;
    }
  }

  /// 🔹 Log In with Email & Password
  static Future<UserCredential> login(String email, String password) async {
    try {
      return await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print("❌ Error during login: $e");
      rethrow;
    }
  }

  /// 🔹 Google Sign-In
  static Future<User?> signInWithGoogle(BuildContext ctx) async {
    try {
      LoadingDialog.show(ctx);

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await fdb.ref("Users").child(user.uid).set({
          "name": user.displayName ?? '',
          "email": user.email ?? '',
          "phoneNumber": user.phoneNumber ?? '',
          "photoURL": user.photoURL ?? '',
          "uid": user.uid,
        });
      }

      return user;
    } catch (e) {
      print("❌ Error during Google Sign-In: $e");
      return null;
    }
  }

  /// 🔹 Google Sign-In Button Handler
  static Future<void> googleSignInButton(BuildContext ctx) async {
    final user = await signInWithGoogle(ctx);
    if (user != null) {
      await checkUserAndNavigate();
    } else {
      print('❌ Google login failed');
      LoadingDialog.hide(ctx);
    }
  }

  /// 🔹 Save user info in Realtime Database
  static Future<void> saveUserData(UserDataModel user) async {
    await fdb.ref("userInfo").child(user.uid).set(user.toMap());
  }

  /// 🔹 Check if user data exists, then navigate accordingly
  static Future<void> checkUserAndNavigate() async {
    final uid = auth.currentUser?.uid;

    if (uid == null) {
      Get.snackbar(
        "Error",
        "User not logged in",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.teal,
        colorText: Colors.white,
        borderRadius: 12,
        margin: EdgeInsets.all(16),
        icon: Icon(Icons.check_circle_outline, color: Colors.white),
        duration: Duration(seconds: 3),
        animationDuration: Duration(milliseconds: 300),
        forwardAnimationCurve: Curves.easeOutBack,
      );
      return;
    }

    final snapshot = await fdb.ref("userInfo").child(uid).get();

    if (snapshot.exists) {
      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      Get.offAllNamed(AppRoutes.accountCreation);
    }
  }

  /// 🔹 Get user data by UID
  static Future<Map<String, dynamic>?> getUserData(String uid) async {
    final snapshot = await fdb.ref("userInfo").child(uid).get();

    if (snapshot.exists && snapshot.value is Map) {
      return Map<String, dynamic>.from(snapshot.value as Map);
    }
    return null;
  }

  /// 🔹 Update user data
  static Future<void> updateUserData(UserDataModel user) async {
    await fdb.ref("userInfo").child(user.uid).update(user.toMap());
  }

  /// 🔹 Upload room details (only for admins)
  static Future<void> uploadRoom(RoomModel room) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw Exception("User not logged in");

    final isAdmin = await isCurrentUserAdmin();
    if (!isAdmin) {
      throw Exception("Only admins can upload rooms");
    }

    try {
      final DatabaseReference ref =
          fdb.ref("rooms").child(room.uid).child(room.roomId);
      await ref.set(room.toMap());
      print("✅ Room uploaded successfully!");
    } catch (e) {
      print("❌ Failed to upload room: $e");
      rethrow;
    }
  }

  /// 🔹 Delete room
  static Future<void> deleteRoom(RoomModel room) async {
    try {
      final DatabaseReference ref =
          fdb.ref("rooms").child(room.uid).child(room.roomId);
      await ref.remove();
      print("✅ Room deleted successfully!");
    } catch (e) {
      print("❌ Failed to delete room: $e");
      rethrow;
    }
  }

  /// 🔹 Check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return false;

    final snapshot =
        await fdb.ref("userInfo").child(uid).child("isAdmin").get();
    return snapshot.value == true;
  }

  /// 🔹 Make another user admin (only if current user is admin)
  static Future<void> makeUserAdmin(String userUid) async {
    final currentUid = auth.currentUser?.uid;
    if (currentUid == null) throw Exception("User not logged in");

    final isAdmin = await isCurrentUserAdmin();
    if (!isAdmin) throw Exception("Only admins can assign admin role");

    await fdb.ref("userInfo").child(userUid).update({
      "isAdmin": true,
    });
  }

// fetch interested users list
  static Future<List<Map<String, dynamic>>> fetchInterestedUsers(
      String roomId) async {
    final db = FirebaseDatabase.instance.ref();

    // Step 1: Get list of interested uids
    final interestSnap = await db.child("rooms/$roomId/interestedUsers").get();
    if (!interestSnap.exists) return [];

    final Map uidsMap = interestSnap.value as Map;
    final List<String> uids = uidsMap.keys.cast<String>().toList();

    // Step 2: Fetch user details for each uid
    List<Map<String, dynamic>> users = [];
    for (final uid in uids) {
      final userSnap = await db.child("users/$uid").get();
      if (userSnap.exists) {
        users.add({...userSnap.value as Map, "uid": uid});
      }
    }
    return users;
  }

  /// 🔹 Sign Out
  static Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    print("✅ User signed out successfully!");
  }
}
