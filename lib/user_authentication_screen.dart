import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zartek_test/controller/app_controller.dart';
import 'package:zartek_test/user_home_screen.dart';
import 'package:zartek_test/widgets/custom_button.dart';

class UserAuthenticationScreen extends StatefulWidget {
  const UserAuthenticationScreen({super.key});

  @override
  State<UserAuthenticationScreen> createState() =>
      _UserAuthenticationScreenState();
}

class _UserAuthenticationScreenState extends State<UserAuthenticationScreen> {
  AppController appCt = Get.find();
  RxBool buttonLoad = false.obs;
  TextEditingController phoneCt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(
                "assets/firebase_logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Obx(
              () => CustomButton(
                isLoading: buttonLoad.value,
                onTap: () async {
                  buttonLoad.value = true;
                  await appCt.googleLogin();
                  // await appCt.getItems();
                  Get.offAll(() => UserHomeScreen());
                  buttonLoad.value = false;
                },
                icon: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/google_logo.webp"),
                ),
                label: "Google",
                backGroundColor: Colors.blue.shade800,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Authentication"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: phoneCt,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white),
                              onPressed: () async {
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: phoneCt.text,
                                    verificationCompleted:
                                        (phoneAuthCredential) {},
                                    verificationFailed: (error) {
                                      log(error.toString());
                                    },
                                    codeSent:
                                        (verificationId, forceResendingId) {},
                                    codeAutoRetrievalTimeout:
                                        (verificationId) {});
                              },
                              child: Text("Submit"))
                        ],
                      );
                    });
              },
              icon: Image.asset(
                "assets/phone_icon.png",
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
              label: "Phone",
              backGroundColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
