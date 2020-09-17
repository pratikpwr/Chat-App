import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/local_db.dart';
import '../screens/all_chats_screen.dart';
import '../services/auth_services.dart';
import '../services/database.dart';
import '../widgets/app_bar.dart';
import '../widgets/button_container.dart';
import '../widgets/text_field_decoration.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthServices _authServices = new AuthServices();
  DatabaseServices _databaseServices = new DatabaseServices();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  signUp() async {
    if (_formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'username': _userNameController.text.trim(),
        'email': _emailController.text.trim()
      };

      setState(() {
        _isLoading = true;
      });
      //signUp user
      await _authServices
          .signUpWithEmailAndPassWord(
              _emailController.text.trim(), _passController.text.trim())
          .then((value) {
        //print('$value');

        //save user info to firebase
        _databaseServices.uploadUserInfo(userInfoMap);
        //save user info to locale DB
        LocaleDB.saveUserAuthStatusDB(true);
        LocaleDB.saveUsernameDB(userInfoMap['username']);
        LocaleDB.saveUserEmailDB(userInfoMap['email']);

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Username';
                                } else if (value.length < 5) {
                                  return 'Username is Short.';
                                } else {
                                  return null;
                                }
                              },
                              controller: _userNameController,
                              style: GoogleFonts.poppins(color: Colors.white),
                              decoration: buildTextDecoration(
                                  context, 'UserName', Icons.account_circle),
                            ),
                            SizedBox(
                              height: 18,
                            ),
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
                              decoration: buildTextDecoration(
                                  context, 'Email', Icons.email),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _passController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Password';
                                } else if (value.length < 6) {
                                  return 'Password is Short.';
                                } else {
                                  return null;
                                }
                              },
                              style: GoogleFonts.poppins(color: Colors.white),
                              decoration: buildTextDecoration(
                                  context, 'Password', Icons.lock_outline),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 18,
                    ),
                    InkWell(
                      onTap: () {
                        signUp();
                      },
                      child: buttonContainer(
                        context: context,
                        color: Theme.of(context).accentColor,
                        child: Text(
                          'Sign Up',
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
                              'Sign Up with Google',
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
                          'Already have an account ?  ',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggle();
                          },
                          child: Text('Sign In',
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
    );
  }
}
