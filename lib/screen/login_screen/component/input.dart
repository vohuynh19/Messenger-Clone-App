import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone_app/screen/home_screen/home_screen.dart';
import '../helper/inputfield.dart';

class InputElement extends StatefulWidget {
  @override
  _InputElementState createState() => _InputElementState();
}

class _InputElementState extends State<InputElement> {
  final _formKey = GlobalKey<FormState>();
  var _passwordFocus = FocusNode();
  var _urlFocus = FocusNode();
  var _verifyPasswordFocus = FocusNode();
  bool isLogin = true;
  String username;
  String password;
  String verifyPassword;
  String imageURL;
  bool isWaiting = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    void signInSubmit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          isWaiting = true;
        });

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: username,
            password: password,
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email'),
                duration: Duration(seconds: 1),
              ),
            );
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Wrong password'),
                duration: Duration(seconds: 1),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
        setState(() {
          isWaiting = false;
        });
      }
    }

    void registerSubmit() async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        setState(() {
          isWaiting = true;
        });
        if (password != verifyPassword) {
          setState(() {
            isWaiting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verifying unsuccessfully!'),
              duration: Duration(seconds: 1),
            ),
          );
          return;
        } else {
          try {
            UserCredential user = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: username, password: password);
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.user.uid)
                .set({
              'email': username,
              'password': password,
              'avatarUrl': imageURL,
            });
            setState(() {
              isWaiting = false;
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.code),
                duration: Duration(seconds: 1),
              ),
            );
            setState(() {
              isWaiting = false;
            });
          }
        }
      }
    }

    void changeMode() {
      setState(() {
        isLogin = !isLogin;
      });
    }

    return Form(
      key: _formKey,
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InputField(
              size: size,
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                ),
                validator: (val) {
                  if (!val.contains('@')) {
                    return 'Invalid email';
                  }
                  if (val.length == 0) {
                    return 'Please enter the username';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  _passwordFocus.requestFocus();
                },
                onSaved: (val) {
                  username = val;
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InputField(
              size: size,
              child: TextFormField(
                focusNode: _passwordFocus,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
                validator: (val) {
                  if (val.length < 6) {
                    return 'Password must contain 6 digits at least';
                  }
                  if (val.length == 0) {
                    return 'Please enter the password';
                  }
                  return null;
                },
                onSaved: (val) {
                  password = val;
                },
                onFieldSubmitted: (_) {
                  if (!isLogin) {
                    _verifyPasswordFocus.requestFocus();
                  } else {
                    signInSubmit();
                  }
                },
              ),
            ),
            if (!isLogin)
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InputField(
                    size: size,
                    child: TextFormField(
                      focusNode: _verifyPasswordFocus,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Verify Password',
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return 'Please enter the password';
                        }
                        return null;
                      },
                      onSaved: (val) {
                        verifyPassword = val;
                      },
                      onFieldSubmitted: (_) {
                        _urlFocus.requestFocus();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputField(
                    size: size,
                    child: TextFormField(
                      focusNode: _urlFocus,
                      onSaved: (val) {
                        imageURL = val;
                      },
                      validator: (val) {
                        if (val.length == 0) {
                          return 'Please enter the url';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Avatar URL",
                      ),
                      onFieldSubmitted: (_) => registerSubmit(),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                !isWaiting
                    ? InkWell(
                        onTap: isLogin ? signInSubmit : registerSubmit,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: size.width * 0.3,
                          height: 35,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[600],
                          ),
                          child: Center(
                            child: Text(
                              isLogin ? 'Sign in' : 'Sign up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    : CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: changeMode,
                    child: Container(
                      child: Text(
                        isLogin
                            ? 'Register now!'
                            : 'If you have already an account, Sign in now!',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
