import 'package:adhicine_app/Sign_in.dart';
import 'package:adhicine_app/app_validator.dart';
import 'package:adhicine_app/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sign_Up_Page extends StatefulWidget {
  Sign_Up_Page({Key? key}) : super(key: key);

  @override
  State<Sign_Up_Page> createState() => _SignupState();
}

class _SignupState extends State<Sign_Up_Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoader = false;
  bool isChecked = false;

  final AuthService authService = AuthService();
  final AppValidator appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(child: Text("Sign Up")),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 80.0),
                TextFormField(
                  controller: _userNameController,
                  decoration: _buildInputDecoration('Name'),
                  validator: appValidator.validateUsername,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('Email'),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: _buildInputDecoration('Password'),
                  validator: appValidator.validatedPassword,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "By Signing up, you agree to the ",
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                          TextSpan(
                            text: "Term ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 18, 144, 248),
                              fontSize: 17,
                            ),
                          ),
                          TextSpan(
                            text: "of Service and Privacy Policy",
                            style: TextStyle(
                              color: Color.fromARGB(255, 18, 144, 248),
                              fontSize: 17,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final message = await AuthService().Signup(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      if (message!.contains('Success')) {
                        await submitForm();
                      }
                    },
                    child: _isLoader
                        ? CircularProgressIndicator()
                        : Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 18, 144, 248),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Sign_In_page()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        TextSpan(
                          text: "Sign_In",
                          style: TextStyle(
                            color: Color.fromARGB(255, 18, 144, 248),
                            fontSize: 17,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      suffixIcon: label == 'Password'
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.black,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.black,
        fontSize: 17,
      ),
    );
  }

  submitForm() async {
    print("hdbcbvdhs");
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoader = true;
      });

      try {
        User? user = await FirebaseAuth.instance.currentUser;

        if (user != null) {
          CollectionReference users1 =
              await FirebaseFirestore.instance.collection('users1');

          await users1.doc(user.uid).set({
            'username': _userNameController.text,
            'email': _emailController.text,
          });

          setState(() {
            _isLoader = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sign Up Successful")),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Sign_In_page()),
          );
        }
      } catch (e) {
        setState(() {
          _isLoader = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign Up Failed: $e")),
        );
      }
    }
  }
}
