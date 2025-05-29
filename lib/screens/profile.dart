import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:home_for_rent/Models/user_data_model.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/containers/button_container.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class MyProfile extends StatefulWidget {
  final String uid;
  const MyProfile({
    super.key,
    required this.uid,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserDataModel? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    Map<String, dynamic>? userDataMap = await AuthRepo.getUserData(widget.uid);

    // Convert the Map<String, dynamic>? to UserDataModel?
    UserDataModel? user =
        userDataMap != null ? UserDataModel.fromMap(userDataMap) : null;

    setState(() {
      userData = user; // Now 'userData' is of type 'UserDataModel?'
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(9.0),
                decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient: LinearGradient(
                          colors: [
                            Colors.red,
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      border: GradientBoxBorder(
                        gradient: LinearGradient(
                            colors: [
                              Colors.red.shade100,
                              Colors.red.shade300,
                              Colors.red.shade500,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(100)),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200)),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(500),
                      child: CachedNetworkImage(
                        width: Get.width * .25,
                        height: Get.width * .25,
                        fit: BoxFit.contain,
                        imageUrl: userData?.profilePicture ??
                            AuthRepo.auth.currentUser?.photoURL ??
                            "",
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          backgroundColor: Colors.black12,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                userData?.name ?? AuthRepo.auth.currentUser?.displayName ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Barlow Semi Condensed',
                  height: 0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    trimText(
                        userData?.email ??
                            AuthRepo.auth.currentUser?.email ??
                            '',
                        20),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    AuthRepo.auth.currentUser?.emailVerified ?? false
                        ? "Verified"
                        : "Not verified",
                    style: TextStyle(
                        color: AuthRepo.auth.currentUser?.emailVerified ?? false
                            ? Colors.green
                            : Colors.red,
                        fontSize: 10),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Divider(
                  thickness: 3,
                  color: Colors.teal.withAlpha((0.5 * 255).round()),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  alignment: Alignment.center,
                  width: 400,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.teal.shade100,
                          Color(0xFFe3f0ff),
                          Colors.teal.shade100,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.teal,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trimText(
                            "  Name     :  ${userData?.name ?? AuthRepo.auth.currentUser?.displayName ?? ''}",
                            35),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'TimesNewRoman'),
                      ),
                      Text(
                        trimText(
                            "  Phone    :  ${userData?.phoneNumber ?? AuthRepo.auth.currentUser?.phoneNumber ?? ''}",
                            35),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'TimesNewRoman'),
                      ),
                      Text(
                        trimText(
                            "  City        :  ${userData?.city ?? ''}", 35),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'TimesNewRoman'),
                      ),
                      Text(
                        trimText(
                            "  Pin         :  ${userData?.pinCode ?? AuthRepo.auth.currentUser?.phoneNumber ?? ''}",
                            35),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[900],
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: 'TimesNewRoman'),
                      )
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              ButtonContainer(
                onTap: () {
                  Get.toNamed(AppRoutes.updateProfile);
                },
                title: 'Edit Profile',
                icon: Icons.edit,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonContainer(
                onTap: () {
                  LoadingDialog.show(context);
                  AuthRepo.auth.currentUser
                      ?.sendEmailVerification()
                      .onError(
                        (error, stackTrace) => LoadingDialog.hide(context),
                      )
                      .then((value) {
                    LoadingDialog.hide(context);

                    AuthRepo.auth.currentUser?.reload();

                    return Get.snackbar(
                      "Verification link sent successfully!",
                      'Cheak your email & verify',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.teal,
                      colorText: Colors.white,
                      borderRadius: 12,
                      margin: EdgeInsets.all(16),
                      icon:
                          Icon(Icons.check_circle_outline, color: Colors.white),
                      duration: Duration(seconds: 3),
                      animationDuration: Duration(milliseconds: 300),
                      forwardAnimationCurve: Curves.easeOutBack,
                    );
                  });
                },
                title: 'Verify Email',
                icon: Icons.verified_outlined,
              ),
              SizedBox(
                height: 10,
              ),
              ButtonContainer(
                onTap: () {
                  AuthRepo.signOut();
                  Get.offAllNamed(AppRoutes.login);
                  Get.snackbar('Success', 'Logout Successfully',
                      backgroundColor: Colors.red.withAlpha((.5 * 255).round()),
                      colorText: Colors.green);
                },
                title: 'Logout',
                icon: Icons.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String trimText(String text, int length) {
    return text.length > length ? "${text.substring(0, length)}..." : text;
  }
}
