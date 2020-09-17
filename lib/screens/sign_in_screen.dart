import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helper/local_db.dart';
import '../screens/all_chats_screen.dart';
import '../services/auth_services.dart';
import '../services/database.dart';
import '../widgets/app_bar.dart';
import '../widgets/button_container.dart';
import '../widgets/text_field_decoration.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isLoading = false;
  QuerySnapshot _querySnapshot;
  AuthServices _authServices = new AuthServices();
  DatabaseServices _databaseServices = new DatabaseServices();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      //save info to localeDB
      _databaseServices
          .getUserByUserEmail(_emailController.text.trim())
          .then((value) {
        _querySnapshot = value;
        LocaleDB.saveUsernameDB(_querySnapshot.docs[0].get('username'));
      });

      LocaleDB.saveUserEmailDB(_emailController.text.trim());

      await _authServices
          .signInWithEmailAndPassword(
              _emailController.text.trim(), _passController.text.trim())
          .then((value) {
        //print('$value');

        LocaleDB.saveUserAuthStatusDB(true);
        _isLoading = false;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AllChatsScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 80,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Email';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please enter valid email.';
                          } else {
                            return null;
                          }
                        },
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration:
                            buildTextDecoration(context, 'Email', Icons.email),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Password';
                          } else if (value.length < 6) {
                            return 'Password is Short.';
                          } else {
                            return null;
                          }
                        },
                        controller: _passController,
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: buildTextDecoration(
                            context, 'Password', Icons.lock_outline),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 14)),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      InkWell(
                        onTap: () {
                          signIn();
                        },
                        child: buttonContainer(
                          context: context,
                          color: Theme.of(context).accentColor,
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {},
                        child: buttonContainer(
                          context: context,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                height: 22,
                                width: 22,
                              ),
                              Text(
                                'Sign In with Google',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?  ',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Text('Sign Up',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Theme.of(context).accentColor)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 42,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
