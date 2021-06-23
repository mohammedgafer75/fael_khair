//import 'dart:html';
import 'package:fael_khair/Screens/home_page.dart';
import 'package:fael_khair/Screens/mission_details_Page.dart';
import 'package:fael_khair/Screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:fael_khair/http.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization_methods.dart';

// ignore: camel_case_types
class SignIn_page extends StatefulWidget {
  @override
  _SignIn_pageState createState() => _SignIn_pageState();
}

// ignore: camel_case_types
class _SignIn_pageState extends State<SignIn_page> {
  void initState() {
    super.initState();
  }

  TextEditingController phone_number = new TextEditingController();
  TextEditingController password = new TextEditingController();
  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            ),
            Text('loading...')
          ],
        ),
      ),
    );
  }

  // ignore: override_on_non_overriding_member
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  int check;

  // ignore: non_constant_identifier_names
  Future<void> login(BuildContext context) async {
    showLoadingDialog(context);
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    var result = await get_login('api/users/login', {
      "phone_number": phone_number.text,
      "password": password.text,
    });

    if (result.ok) {
      setState(() {
        check = result.data['check'];
        if (check == 1) {
          sharedpreference.setString("token", result.data['token']);
          sharedpreference.setString("user_id", result.data['id']);
          sharedpreference.setString("login", 'ok');
          Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => MyHomePage()),
              (Route<dynamic> route) => false);
        }
        if (check == 2) {
          String res = result.data['error'];
          Navigator.of(context).pop();
          showBar(context, res);
        }
        if (check == 3) {
          Navigator.of(context).pop();
          String res = result.data['error'];
          showBar(context, res);
        }
      });
    }
  }

  // ignore: override_on_non_overriding_member
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);

    return Scaffold(
        body: Builder(
      builder: (context) => Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              height: 150.0,
              width: 150.0,
              margin: EdgeInsets.only(
                left: data.padding.left + 20,
                right: data.padding.right + 20,
                top: data.padding.top + 20,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/Logo.png"), fit: BoxFit.contain),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 25),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: data.size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E6FF),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  cursorColor: Colors.indigo,
                  controller: phone_number,
                  decoration: InputDecoration(
                    labelText: getTranslate(context, 'Email'),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,

                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return getTranslate(context, 'pemail');
                    }
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: data.size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E6FF),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  controller: password,
                  cursorColor: Color(0xFF6F35A5),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: getTranslate(context, 'Password'),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.text,

                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return getTranslate(context, 'pPassword');
                    }
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: data.size.width * 0.6,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E6FF),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        login(context);
                      });
                    }
                  },
                  child: Text(
                    "${getTranslate(context, 'SignIn')}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                "${getTranslate(context, 'NewUser')}",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 35),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: data.size.width * 0.6,
                decoration: BoxDecoration(
                  color: Color(0xFFF1E6FF),
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SignUp_page();
                      }),
                    );
                  },
                  child: Text(
                    "${getTranslate(context, 'SignUp')}",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
