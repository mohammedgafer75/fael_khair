import 'package:fael_khair/Screens/sign_in.dart';
import 'package:fael_khair/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import '../localization_methods.dart';
import '../main.dart';
import '../model.dart';
import 'home_page.dart';
import 'package:country_code_picker/country_code_picker.dart';

class Settings extends StatefulWidget {
  final String myData;
  Settings(this.myData, {Key key}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void initState() {
    super.initState();
    det();
  }

  TextEditingController user_name = new TextEditingController();
  TextEditingController phone_number = new TextEditingController();
  TextEditingController password = new TextEditingController();

  bool _notifications = false;
  SharedPreferences sharedpreference;
  Future<void> update(BuildContext context) async {
    showLoadingDialog(context);
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    if (password.text.isEmpty) {
      password.text = password2;
    }
    if (_file != null) {
      upload(_file, userId);
    }
    int check;
    var result = await http_post('api/users/update/$userId', {
      "name": user_name.text,
      "phone_number": phone_number.text,
      "password": password.text,
    });
    if (result.ok) {
      setState(() {
        check = result.data['check'];
        if (check == 0) {
          String res = result.data['massage'];
          Navigator.of(context).pop();
          showBar(context, res);
        }
        if (check == 1) {
          String res = result.data['massage'];
          Navigator.of(context).pop();
          showBar(context, res);
        }
      });
    }
  }

  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  var password2;
  Future<void> det() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var result = await user("api/users/$userId");
    //https://faelkhair.herokuapp.com
    if (result.ok) {
      setState(() {
        print(result.data);
        user_name.text = result.data['name'];
        phone_number.text = result.data['phone_number'].toString();
        password2 = result.data['password'];
        print(phone_number);
      });
    }
  }

  File _file;
  Future getimage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(image.path);
    });
  }

  upload(File imageFile, String id) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://faelkhair.herokuapp.com/api/image");
    // http://10.0.2.2:7000/api/image
    // https://faelkhair.herokuapp.com/api/image
    // create multipart request
    var request = new http.MultipartRequest("PATCH", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.fields['user_id'] = id;
    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

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
            SizedBox(),
            Text('Adding...')
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    void _changelang(lang la) async {
      Locale temp = await setLocal(la.lanCode);
      FaelKhair.setLocale(context, temp);
    }

    return WillPopScope(
      onWillPop: () {
        return Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }));
      },
      child: Scaffold(
          body: Form(
        key: _formKey,
        child: Builder(
          builder: (context) => CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                centerTitle: true,
                expandedHeight: data.size.height / 7,
                backgroundColor: Color(0xFF6F35A5),
                flexibleSpace: FlexibleSpaceBar(),
                title: Text(
                  "Settings",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              height: 150.0,
                              width: 150.0,
                              child: GestureDetector(
                                child: CircleAvatar(
                                  backgroundImage: _file == null
                                      ? widget.myData == null
                                          ? AssetImage("images/Logo.png")
                                          : NetworkImage("${widget.myData}")
                                      : FileImage(_file),
                                  backgroundColor: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    getimage();
                                  });
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 25),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              cursorColor: Color(0xFF6F35A5),
                              controller: user_name,
                              decoration: InputDecoration(
                                labelText: "Update User Name: ",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  user_name.text = value;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              cursorColor: Color(0xFF6F35A5),
                              controller: phone_number,
                              decoration: InputDecoration(
                                labelText: "Update Phone Number: ",
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isNotEmpty) {
                                  phone_number.text = value;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
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
                                labelText: "Update Password",
                                border: InputBorder.none,
                              ),
                             // validator: (value) {
                              //  if (value.isNotEmpty) {
                              //    password.text = value;
                              //  }
                             // },
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: data.size.width * 0.9,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1E6FF),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: CountryCodePicker(
                                onChanged: print,
                                countryFilter: [
                                  'مصر ',
                                  'السودان',
                                  'البحرين ',
                                  'قطر',
                                  'العربية السعودية'
                                ],
                                initialSelection: '+249',
                                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                // flag can be styled with BoxDecoration's `borderRadius` and `shape` fields
                                flagDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: SwitchListTile(
                              title: Text('Notifications'),
                              value: _notifications,
                              onChanged: (bool value) {
                                setState(() {
                                  _notifications = value;
                                });
                              },
                              secondary: const Icon(Icons.notifications_active),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text("Change Language")),
                                DropdownButton(
                                  icon: Icon(
                                    Icons.language,
                                    color: Colors.blueGrey,
                                    size: 25,
                                  ),
                                  items: lang
                                      .langList()
                                      .map<DropdownMenuItem<lang>>((e) =>
                                          DropdownMenuItem(
                                            value: e,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  e.flag,
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                Text(e.name)
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                  onChanged: (lang lan) {
                                    _changelang(lan);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              width: data.size.width * 0.6,
                              decoration: BoxDecoration(
                                color: Color(0xFFF1E6FF),
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      update(context);
                                    });
                                  }
                                },
                                child: Text(
                                  "Confirm Updates",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
