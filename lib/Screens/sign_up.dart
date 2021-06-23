import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fael_khair/localization_methods.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:fael_khair/http.dart';
import 'package:image_picker/image_picker.dart';

// ignore: camel_case_types
class SignUp_page extends StatefulWidget {
  @override
  _SignUp_pageState createState() => _SignUp_pageState();
}

// ignore: camel_case_types
class _SignUp_pageState extends State<SignUp_page> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController name = new TextEditingController();
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
            SizedBox(),
            Text('loading...')
          ],
        ),
      ),
    );
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  File file = File('images/mazin.JPG');
  File _file;
  int check;

  // ignore: non_constant_identifier_names
  Future CreateUser(BuildContext context) async {
   
    showLoadingDialog(context);
    
    // if (_file == null) {
    //   Navigator.of(context).pop();
    //   final snackBar = SnackBar(
    //     content: Text('Please Select Image'),
    //   );
    //   return Scaffold.of(context).showSnackBar(snackBar);
    // }
    var result = await http_post("api/users/register", {
      "name": name.text,
      "phone_number": phone_number.text,
      "password": password.text,
    });
    if (result.ok) {
      check = result.data['check'];
      if (check == 1) {
        var id = result.data['id'];
        // upload(_file, id);
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SignIn_page();
        }));
      }
      if (check == 4) {
        String res = result.data['massage'];
        setState(() {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text('$res'),
          );
          name.clear();
          Scaffold.of(context).showSnackBar(snackBar);
        });
      }
      if (check == 2) {
        String res = result.data['massage'];
        setState(() {
          Navigator.of(context).pop();
          final snackBar = SnackBar(
            content: Text('$res'),
          );
          phone_number.clear();
          Scaffold.of(context).showSnackBar(snackBar);
        });
      }
    }
  }

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
    // https://faelkhair.herokuapp.com/api/image
    // http://10.0.2.2:7000/api/image
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

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
   print(phone_number);
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    final data = MediaQuery.of(context);

    return Scaffold(
        body: Builder(
            builder: (context) => Form(
                  key: _formKey,
                  child: CustomScrollView(
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
                          getTranslate(context, "SignUp"),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/Logo.png"),
                                    fit: BoxFit.contain),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // InkWell(
                                  //   child: Center(
                                  //     child: Stack(
                                  //       children: [
                                  //         CircleAvatar(
                                  //           maxRadius: 70,
                                  //           backgroundImage: _file == null
                                  //               ? AssetImage('images/user.png')
                                  //               : FileImage(_file),
                                  //           child: Icon(Icons.add_a_photo,
                                  //               color: Colors.black),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   onTap: () {
                                  //     setState(() {
                                  //       getimage();
                                  //     });
                                  //   },
                                  // ),
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
                                      controller: name,
                                      decoration: InputDecoration(
                                        labelText:
                                            getTranslate(context, "Name"),
                                        border: InputBorder.none,
                                      ),

                                      // ignore: missing_return
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return getTranslate(context, "pName");
                                        return null;
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
                                    keyboardType: TextInputType.phone,
                                      cursorColor: Color(0xFF6F35A5),
                                      controller: phone_number,
                                      decoration: InputDecoration(
                                        labelText:
                                            getTranslate(context, "Email"),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return getTranslate(
                                              context, "pEmail");
                                        //if (!regex.hasMatch(value))
                                         // return getTranslate(
                                             // context, "eEmail");
                                        return null;
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
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText:
                                            getTranslate(context, "cEmail"),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return getTranslate(
                                              context, "pEmail");
                                        if (value != phone_number.text)
                                          return getTranslate(
                                              context, "nMatch");
                                        return null;
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
                                        labelText:
                                            getTranslate(context, "Password"),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return getTranslate(
                                              context, "pPassword");
                                        }
                                        return null;
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
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText:
                                            getTranslate(context, "cPassword"),
                                        border: InputBorder.none,
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return getTranslate(
                                              context, "pPassword");
                                        if (value != password.text)
                                          return getTranslate(
                                              context, "nMatch");
                                        return null;
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      width: data.size.width * 0.6,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF1E6FF),
                                        borderRadius: BorderRadius.circular(29),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              CreateUser(context);
                                            });
                                          }
                                        },
                                        child: Text(
                                          getTranslate(context, "Register"),
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
                )));
  }
}
