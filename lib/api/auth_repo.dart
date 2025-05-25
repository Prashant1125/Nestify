import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      await Get.offAllNamed(AppRoutes.home);
    } else {
      print('❌ Google login failed');
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
      Get.snackbar("Error", "User not logged in",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
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

  /// 🔹 Sign Out
  static Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    print("✅ User signed out successfully!");
  }
}
