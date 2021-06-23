import 'package:fael_khair/localization_methods.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fael_khair/Screens/page1.dart';
import 'package:fael_khair/Screens/page2.dart';
import 'package:fael_khair/Screens/page3.dart';
import 'package:fael_khair/Screens/page4.dart';
import 'package:fael_khair/Screens/page5.dart';
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fael_khair/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddMission extends StatefulWidget {
  @override
  _AddMissionState createState() => _AddMissionState();
}

class _AddMissionState extends State<AddMission> {
  void initState() {
    super.initState();
    checkLoginState();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController mission_title = TextEditingController();
  TextEditingController mission_details = TextEditingController();
  TextEditingController mission_location = TextEditingController();
  TextEditingController number = TextEditingController();
  int catId2 = 1;
  SharedPreferences sharedpreference;
  int back;
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  checkLoginState() async {
    sharedpreference = await SharedPreferences.getInstance();
    String catId = sharedpreference.getString("cat_id");
    if (int.tryParse(catId) == 1) {
      return back = 1;
    }
    if (int.tryParse(catId) == 2) {
      return back = 2;
    }
    if (int.tryParse(catId) == 3) {
      return back = 3;
    }
    if (int.tryParse(catId) == 4) {
      return back = 4;
    }
    if (int.tryParse(catId) == 5) {
      return back = 5;
    }
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

  // ignore: non_constant_identifier_names
  Future<void> Add_mission(BuildContext context) async {
    showLoadingDialog(context);
    int check;
    sharedpreference = await SharedPreferences.getInstance();
    if (sharedpreference.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    } else {
      String token = sharedpreference.getString("token");
      String catId = sharedpreference.getString("cat_id");
      print(token);
      if (mumber == 0) {
        var result = await add_mission(token, 'api/mission', {
          "title": mission_title.text,
          "description": mission_details.text,
          "location_id": mission_location.text,
          "CategoryId": catId2,
          "image": imageCh.toString(),
          "status": 1,
          "Mumbers": number.text,
        });
        if (result.ok) {
          if (imageCh == 1) {
            upload(_file, result.data['id']);
          }
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
              mission_title.clear();
              mission_details.clear();
              mission_location.clear();
              number.clear();
              showBar(context, res);
            }
          });
        }
      } else {
        var result = await add_mission(token, 'api/mission', {
          "title": mission_title.text,
          "description": mission_details.text,
          "location_id": mission_location.text,
          "CategoryId": catId2,
          "image": imageCh.toString(),
          "status": 1,
          "Mumbers": "any",
        });
        if (result.ok) {
          if (imageCh == 1) {
            upload(_file, result.data['id']);
          }
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
              mission_title.clear();
              mission_details.clear();
              mission_location.clear();
              number.clear();
              showBar(context, res);
            }
          });
        }
      }
    }
  }

  File _file;
  int imageCh = 0;
  Future getimage() async {
    // ignore: deprecated_member_use
    final image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = File(image.path);
      imageCh = 1;
    });
  }

  upload(File imageFile, String id) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://faelkhair.herokuapp.com/api/image2");
    // https://faelkhair.herokuapp.com/api/image2
    // http://10.0.2.2:7000/api/image2

    // create multipart request
    var request = new http.MultipartRequest("PATCH", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));
    request.fields['mission_id'] = id;
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

  var _category = ["Health", "Education", "Construction", "Feeding", "Other"];
  var _currentcategorySelected = "Health";
  var _openParticipant = false;
  int mumber = 0;
  @override
  Widget build(BuildContext context) {
    print(_openParticipant);
    final data = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () {
          // ignore: missing_return
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            if (back == 1) {
              return Page1();
            }
            if (back == 2) {
              return Page2();
            }
            if (back == 3) {
              return Page3();
            }
            if (back == 4) {
              return Page4();
            }
            if (back == 5) {
              return Page5();
            }
          }));
        },
        child: Scaffold(
            body: Form(
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
                  "${getTranslate(context, 'AddMission')}",
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      //padding: EdgeInsets.only(top: 50,left: 50,right: 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 25),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text("Mission Category")),
                                Expanded(
                                  child: DropdownButton(
                                    items: _category
                                        .map((String dropDownStringItem) {
                                      return DropdownMenuItem<String>(
                                        value: dropDownStringItem,
                                        child: Text(dropDownStringItem),
                                      );
                                    }).toList(),
                                    onChanged: (String newValueSelected) {
                                      setState(() {
                                        if (newValueSelected == "Health") {
                                          this._currentcategorySelected =
                                              newValueSelected;
                                          return catId2 = 1;
                                        }
                                        if (newValueSelected == "Education") {
                                          this._currentcategorySelected =
                                              newValueSelected;
                                          return catId2 = 2;
                                        }
                                        if (newValueSelected ==
                                            "Construction") {
                                          this._currentcategorySelected =
                                              newValueSelected;
                                          return catId2 = 3;
                                        }
                                        if (newValueSelected == "Feeding") {
                                          this._currentcategorySelected =
                                              newValueSelected;
                                          return catId2 = 4;
                                        }
                                        if (newValueSelected == "Other") {
                                          this._currentcategorySelected =
                                              newValueSelected;
                                          return catId2 = 5;
                                        }
                                      });
                                    },
                                    value: _currentcategorySelected,
                                  ),
                                ),
                              ],
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
                              controller: mission_title,
                              decoration: InputDecoration(
                                labelText:
                                    getTranslate(context, 'MissionTitle'),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return getTranslate(context, 'pMissionTitle');
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            height: data.size.height * 1 / 4,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: TextFormField(
                              maxLines: 20,
                              //obscureText: true,
                              //onChanged: onChanged,
                              controller: mission_details,
                              cursorColor: Color(0xFF6F35A5),
                              decoration: InputDecoration(
                                labelText:
                                    getTranslate(context, 'MissionDetails'),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return getTranslate(
                                      context, 'pMissionDetails');
                                return null;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            height: data.size.height * 0.20,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: InkWell(
                              child: Row(
                                children: [
                                  Text("Add a photo"),
                                  Expanded(
                                    child: Image(
                                        image: _file == null
                                            ? AssetImage('images/Logo.png')
                                            : FileImage(_file)),
                                  ),
                                  Icon(Icons.add_a_photo)
                                ],
                              ),
                              onTap: () {
                                getimage();
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
                              controller: mission_location,
                              cursorColor: Color(0xFF6F35A5),
                              decoration: InputDecoration(
                                labelText:
                                    getTranslate(context, "MissionLocation"),
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value.isEmpty)
                                  return getTranslate(
                                      context, "pMissionLocation");
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
                            child: DateTimePicker(
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event),
                              dateLabelText: 'Date',
                              timeLabelText: "Hour",
                              // selectableDayPredicate: (date) {
                              //   // Disable weekend days to select from the calendar
                              //   if (date.weekday == 6 || date.weekday == 7) {
                              //     return false;
                              //   }
                              //
                              //   return true;
                              // },
                              onChanged: (val) => print(val),
                              validator: (val) {
                                print(val);
                                return null;
                              },
                              onSaved: (val) => print(val),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: data.size.width * 0.9,
                            height: data.size.height * 0.15,
                            decoration: BoxDecoration(
                              color: Color(0xFFF1E6FF),
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Number of Participant :"),
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: number,
                                    enabled: !_openParticipant,
                                    cursorColor: Color(0xFF6F35A5),
                                    decoration: InputDecoration(
                                      labelText:
                                          getTranslate(context, "Participants"),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Checkbox(
                                        value: _openParticipant,
                                        onChanged: (var check) {
                                          setState(() {
                                            mumber = 1;
                                            _openParticipant =
                                                !_openParticipant;
                                          });
                                        })),
                                Expanded(
                                    child: Text(getTranslate(
                                        context, "aParticipants"))),
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
                              child: FlatButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      Add_mission(context);
                                    });
                                  }
                                },
                                child: Text(
                                  getTranslate(context, "SaveMission"),
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
