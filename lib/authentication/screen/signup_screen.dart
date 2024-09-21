import 'package:comments_app/authentication/controller/authentication_controller.dart';
import 'package:comments_app/authentication/firebase/auth.dart';
import 'package:comments_app/constants/app_const.dart';
import 'package:comments_app/db/firebase_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Comments",
                  style: Theme.of(context).textTheme.titleLarge!.merge(
                        GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor),
                      ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: fullName,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'Name',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .merge(GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'Email',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .merge(GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide an email';
                        }
                        if (!isValidEmail(value)) {
                          return 'Please provide a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      controller: password,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'Password',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .merge(GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<AuthController>(builder: (context, auth, child) {
                      return auth.isRegistering == true
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final User? user =
                                      await Authentication.instance.createUser(
                                          email: emailAddress.text,
                                          password: password.text,
                                          authController: auth,
                                          context: context);

                                  if (user != null) {
                                    final String? docId = await FirebaseDb
                                        .instance
                                        .addUserToDb(body: {
                                      "fullName": fullName.text,
                                      "email": emailAddress.text,
                                    });

                                    if (mounted) {
                                      auth.updateIsRegistering(
                                          isRegistering: false);
                                      Navigator.pop(context);
                                      debugPrint(docId);
                                    }
                                  } else {
                                    if (mounted) {
                                      auth.updateIsRegistering(
                                          isRegistering: false);
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(231.w, 50.h),
                              ),
                              child: Text(
                                "Signup",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white),
                              ),
                            );
                    }),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account? ",
                          style: Theme.of(context).textTheme.titleMedium!.merge(
                              GoogleFonts.poppins(fontWeight: FontWeight.w400)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/login");
                          },
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .merge(GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
