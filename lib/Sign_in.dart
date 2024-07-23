import 'dart:ffi';

import 'package:adhicine_app/app_validator.dart';
import 'package:adhicine_app/auth_service.dart';
import 'package:adhicine_app/home_page.dart';
import 'package:adhicine_app/sign-up.dart';
import 'package:flutter/material.dart';

class Sign_In_page extends StatefulWidget {
  Sign_In_page({Key? key}) : super(key: key);

  @override
  State<Sign_In_page> createState() => _LogInState();
}

class _LogInState extends State<Sign_In_page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var isLoader = false;
  var authService = AuthService();
  var appValidator = AppValidator();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: Center(child: Text("Sign In")),
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    child: Center(
                      child: Image.asset("images/medicine2.png"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Adhicine",
                  style: TextStyle(
                      fontSize: 25,
                      color: const Color.fromARGB(255, 18, 144, 248)),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // SizedBox(
                    //   height: 80.0,
                    // ),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration('Email', Icons.email,
                          prefixIcon: Icons.email),
                      validator: appValidator.validateEmail,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: _buildInputDecoration('Password', Icons.lock,
                          prefixIcon: Icons.lock),
                      validator: appValidator.validatedPassword,
                      // Hides the password text
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 200),
                      child: Text(
                        "Forgot Password?",
                        style:
                            TextStyle(color: Color.fromARGB(255, 18, 144, 248)),
                      ),
                    ),

                    SizedBox(height: 50),
                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoader ? null : _submitForm,
                        child: isLoader
                            ? Center(child: CircularProgressIndicator())
                            : Text("Sign In",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 18, 144, 248),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "OR",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 15,
                    ),

                    Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {},
                        icon: Image.asset(
                          "images/google-icon.png",
                          height: 30,
                          width: 30,
                        ),
                        label: Text(
                          "Sign Up With Google",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Sign_Up_Page()));
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: "New to Adhicine?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            TextSpan(
                              text: "Sign_Up",
                              style: TextStyle(
                                color: Color.fromARGB(255, 18, 144, 248),
                                fontSize: 17,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ]),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon,
      {IconData? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      suffixIcon: label == "Password"
          ? IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
          : null,
    );
  }

  Future<Void?> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      var loggedIn = await AuthService().login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      setState(() {
        isLoader = false;
      });

      if (loggedIn == "Success") {
        await AuthService().saveUserLoggedIn(loginState: true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home_page()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SignIn failed. Please try again.")),
      );
    }
  }
}
