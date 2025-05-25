import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_for_rent/Models/user_data_model.dart';
import 'package:home_for_rent/api/auth_repo.dart';
import 'package:home_for_rent/components/contact_input.dart';
import 'package:home_for_rent/components/location_input/custom_dropdown.dart';
import 'package:home_for_rent/components/location_input/date_input.dart';
import 'package:home_for_rent/components/location_input/location_input.dart';
import 'package:home_for_rent/components/location_input/radio_button.dart';
import 'package:home_for_rent/components/pin_input.dart';
import 'package:home_for_rent/components/primary_button.dart';
import 'package:home_for_rent/components/text_input_field.dart';
import 'package:home_for_rent/controller/custom_dropdown_contoller.dart';
import 'package:home_for_rent/controller/date_input_controller.dart';
import 'package:home_for_rent/controller/location_input_controller.dart';
import 'package:home_for_rent/controller/redio_button_controller.dart';
import 'package:home_for_rent/loader/loader.dart';
import 'package:home_for_rent/routes/routes.dart';

class AccountCreation extends StatefulWidget {
  const AccountCreation({super.key});

  @override
  State<AccountCreation> createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  List<String> types = ['Student', 'Worker', 'Emplyoee', 'Govt-Job', 'Other'];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final MembershipTypeRadioController genderController =
      Get.put(MembershipTypeRadioController());
  final ExpandedDropdownController dropdownController =
      Get.put(ExpandedDropdownController());
  final DateInputController datecontroller = Get.put(DateInputController());
  final LocationInputController locationInputController =
      Get.put(LocationInputController());

  bool isPphoneError = false;

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 100,
        title: Column(
          children: [
            Text(
              " Let's Begin ",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[900],
                fontSize: 30,
                fontFamily: '🏠 Cursive 🏠',
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Create your account to start your journey',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cursive',
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 30,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // UploadFileSmallSingle(),
                    TextInputField(
                        validator: (value) {
                          return null;
                        },
                        title: 'Name',
                        enabled: true,
                        textEditingController: nameController,
                        hintText: 'Enter Your Name',
                        uniqueTextInputFieldId: 'Name'),
                    SizedBox(
                      height: 14,
                    ),
                    TextInputField(
                        validator: (value) {
                          return null;
                        },
                        title: 'Email Id',
                        enabled: true,
                        textEditingController: emailController,
                        hintText: 'Enter Your Email',
                        uniqueTextInputFieldId: 'Email'),
                    SizedBox(
                      height: 14,
                    ),
                    ContactInputField(
                      textEditingController: phoneController,
                      hintText: 'XXXXX-XXXXX',
                      uniqueTextInputFieldId: "Manager_Contact",
                      isEmpty: isPphoneError,
                      width: Get.width * 0.975,
                      enabled: true,
                    ),
                    const SizedBox(height: 14.0),
                    DateInputField(
                        validator: (value) {
                          return null;
                        },
                        uniqueTextInputFieldId: 'Date',
                        hintText: 'Select or Enter DOB',
                        isEmpty: false.obs,
                        enabled: true,
                        width: Get.height * 0.975),
                    const SizedBox(height: 14.0),
                    SizedBox(
                      height: 14,
                    ),
                    RadioButtonTab(
                      buttonCount: 3,
                      buttonTexts: const ["Male", "Female", "Other"],
                      buttonWidth: Get.width * (102 / 360),
                      controller: genderController,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    CustomExpandedDropdown(
                      validator: (value) {
                        return null;
                      },
                      title: 'What is your role?',
                      controller: dropdownController,
                      buttonWidth: 20,
                      buttonHeight: 45,
                      listOfItems: types,
                      listOfItemsUniqueId: types,
                    ),
                    const SizedBox(height: 14.0),
                    LocationInputField(
                      validator: (value) {
                        return null;
                      },
                      hintText: "Enter or select your colony of locality",
                    ),
                    const SizedBox(height: 14.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextInputField(
                          title: 'City',
                          validator: (value) {
                            return null;
                          },
                          enabled: true,
                          textEditingController: cityController,
                          hintText: "Enter City",
                          uniqueTextInputFieldId: 'City',
                          width: Get.width * .40,
                        ),
                        TextInputField(
                          title: 'State',
                          validator: (value) {
                            return null;
                          },
                          enabled: true,
                          textEditingController: stateController,
                          hintText: " Enter State",
                          uniqueTextInputFieldId: 'State',
                          width: Get.width * .40,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextInputField(
                          title: 'Country',
                          validator: (value) {
                            return null;
                          },
                          enabled: true,
                          textEditingController: countryController,
                          hintText: " Enter Country",
                          uniqueTextInputFieldId: 'Country',
                          width: Get.width * .40,
                        ),
                        PinInputField(
                          validator: (value) {
                            return null;
                          },
                          textEditingController: pinController,
                          hintText: " Enter Pin",
                          uniqueTextInputFieldId: 'Pin',
                          width: Get.width * .40,
                          enabled: true,
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(
                      height: 30,
                    ),
                    PrimaryButton(
                        width: Get.width * .9,
                        height: 50,
                        title: 'Submit',
                        onPressed: () async {
                          if (emailController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              phoneController.text.isNotEmpty &&
                              datecontroller
                                  .textEditingController.text.isNotEmpty &&
                              dropdownController.roleSelected.isNotEmpty &&
                              locationInputController
                                  .textEditingController.text.isNotEmpty &&
                              cityController.text.isNotEmpty &&
                              stateController.text.isNotEmpty &&
                              countryController.text.isNotEmpty &&
                              pinController.text.isNotEmpty) {
                            if (contactNumberValidator(phoneController.text)) {
                              //for showing a indicator
                              LoadingDialog.show(context);

                              // for model

                              UserDataModel userDataModel = UserDataModel(
                                  uid: AuthRepo.user!.uid,
                                  profilePicture: AuthRepo.user!.photoURL,
                                  name: nameController.text,
                                  email: emailController.text,
                                  phoneNumber: phoneController.text,
                                  dob:
                                      datecontroller.textEditingController.text,
                                  gender: genderController.selectedItem.value,
                                  city: cityController.text,
                                  state: stateController.text,
                                  country: countryController.text,
                                  pinCode: pinController.text,
                                  types: dropdownController.roleSelected.value,
                                  location: locationInputController
                                      .textEditingController.text);
                              LoadingDialog.hide(context);

                              await AuthRepo.saveUserData(userDataModel);
                              // for navigate to Home Screen
                              Get.offAllNamed(AppRoutes.bottomNav);
                              // For showing a snakbar to successfull login
                              Get.snackbar(
                                "Success",
                                "User data saved successfully!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.teal,
                                colorText: Colors.white,
                                borderRadius: 12,
                                margin: EdgeInsets.all(16),
                                icon: Icon(Icons.check_circle_outline,
                                    color: Colors.white),
                                duration: Duration(seconds: 3),
                                animationDuration: Duration(milliseconds: 300),
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'Incorrect phone number',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.teal,
                                colorText: Colors.white,
                                borderRadius: 12,
                                margin: EdgeInsets.all(16),
                                icon: Icon(Icons.check_circle_outline,
                                    color: Colors.white),
                                duration: Duration(seconds: 3),
                                animationDuration: Duration(milliseconds: 300),
                                forwardAnimationCurve: Curves.easeOutBack,
                              );
                            }
                          } else {
                            Get.snackbar(
                              'Error',
                              'Please fill all the fields',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.teal,
                              colorText: Colors.white,
                              borderRadius: 12,
                              margin: EdgeInsets.all(16),
                              icon: Icon(Icons.check_circle_outline,
                                  color: Colors.white),
                              duration: Duration(seconds: 3),
                              animationDuration: Duration(milliseconds: 300),
                              forwardAnimationCurve: Curves.easeOutBack,
                            );
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// for picked a autofilled values by login
  void setData() async {
    final uid = AuthRepo.user!.uid;
    var userData = await AuthRepo.getUserData(uid); // Firebase से डेटा लाना

    if (userData != null) {
      phoneController.text = userData["phoneNumber"] ?? "";
      emailController.text = userData["email"] ?? "";
      nameController.text = userData["name"] ?? "";
      datecontroller.textEditingController.text = userData["dob"] ?? "";
      locationInputController.textEditingController.text =
          userData["location"] ?? "";
      genderController.selectedItem.value = userData["gender"] ?? "";
      cityController.text = userData["city"] ?? "";
      stateController.text = userData["state"] ?? "";
      countryController.text = userData["country"] ?? "";
      pinController.text = userData["pinCode"] ?? "";
      dropdownController.roleSelected.value = userData["bloodGroup"] ?? "";
    }
  }
}
