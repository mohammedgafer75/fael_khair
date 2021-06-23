import 'package:fael_khair/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fael_khair/http.dart';
import 'package:condition/condition.dart';
import 'package:fael_khair/Screens/page1.dart';

class Missions_page extends StatefulWidget {
  @override
  _Missions_pageState createState() => _Missions_pageState();
}

class _Missions_pageState extends State<Missions_page> {
  void initState() {
    super.initState();
    checkLoginState();
    getUserMission();
    getUImages();
    getMImages();
    getliker();
    getfollower();
    getsave();
    // isLike();
  }

  checkLoginState() async {
    sharedpreference = await SharedPreferences.getInstance();
    if (sharedpreference.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  SharedPreferences sharedpreference;

  List missionData = [];
  var Liker;
  var Follower;
  var MImages;
  var Save;
  bool _hasBeenPressed = false;
  bool _hasBeenPressed2 = false;
  bool _hasBeenPressed3 = false;

  String image_url;
  getImage(var userId) {
    for (var i in UImages) {
      if (i['user_id'] == userId) {
        var image = i['image'];
        return image_url = Url + image;
      }
    }
  }

  var UImages;
  Future<void> getUImages() async {
    var res = await getimage('api/images');
    if (res.ok) {
      return UImages = res.data;
    }
  }

  List join = [];
  List confirm;
  List reject;
  List liker = [];
  List save = [];
  List waiting = [];
  var mission;
  Future<void> getMImages() async {
    var res = await getimage('api/images2');
    if (res.ok) {
      setState(() {
        Url = res.url;
      });
      return MImages = res.data;
    }
  }

  int un;
  Future<void> getUserMission() async {
    sharedpreference = await SharedPreferences.getInstance();
    var user_id = sharedpreference.getString("user_id");
    var token = sharedpreference.getString("token");
    print(user_id);
    var mission_res =
        await get_user_mission(token, "api/mission/user/$user_id");
    var confirm_res =
        await get_user_mission(token, "api/mission/status/active/$user_id");
    var reject_res =
        await get_user_mission(token, "api/mission/status/not/$user_id");
    var waiting_res =
        await get_user_mission(token, "api/mission/status/wait/$user_id");
    var like_res = await getlike("api/liker/$user_id");
    var save_res = await getlike("api/save/$user_id");
    var join_res = await getlike("api/join/$user_id");
    if (confirm_res.ok) {
      setState(() {
        mission = mission_res.data['Mission'];
        print('m:$mission');
        confirm = confirm_res.data['Mission'];
        print('c:$confirm');
        reject = reject_res.data['Mission'];
        print('r:$reject');
        waiting = waiting_res.data['Mission'];
        print('w:$waiting');
        if (like_res.data['check'] == 0 && mission != null) {
          liker = null;
        } else {
          var Liker = like_res.data['Liker'];

          for (var i in Liker) {
            for (var a in mission) {
              if (i['mission_liked_id'] == a['_id']) {
                if (like == null) {
                  setState(() {
                    liker = a;
                  });
                } else {
                  setState(() {
                    liker.add(a);
                  });
                }
              }
            }
          }
          print('like:$like');
        }
        if (save_res.data['check'] == 0 && mission != null) {
          save = null;
        } else {
          var Save = save_res.data['Save'];
          print('save:$Save');
          for (var i in Save) {
            for (var a in mission) {
              if (i['mission_id'] == a['_id']) {
                if (save == null) {
                  setState(() {
                    save = a;
                  });
                } else {
                  setState(() {
                    save.add(a);
                  });
                }
              }
            }
          }
          print('save:$save');
        }
        if (join_res.data['check'] == 0 && mission != null) {
          join = null;
        } else {
          var Join = join_res.data['Join'];
          for (var i in Join) {
            for (var a in mission) {
              if (i['mission_id'] == a['_id']) {
                if (join == null) {
                  setState(() {
                    join = a;
                  });
                } else {
                  setState(() {
                    join.add(a);
                  });
                }
              }
            }
          }
          print('join:$join');
        }
      });
      missionData = join;
      un = 1;
    }
  }

  var _missionFilters = [
    "Joined Missions",
    "Confirmed Missions",
    "Rejected Missions",
    "Liked Missions",
    "Saved Missions",
    "Waiting Missions"
  ];
  var _currentFilterSelected = "Joined Missions";

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    print('mission:$missionData');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Missions",
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 25, horizontal: 45),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: data.size.width * 0.9,
              decoration: BoxDecoration(
                color: Color(0xFFF1E6FF),
                borderRadius: BorderRadius.circular(29),
              ),
              child: DropdownButton(
                items: _missionFilters.map((String dropDownStringItem) {
                  return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Text(dropDownStringItem),
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                  setState(() {
                    if (newValueSelected == "Joined Missions") {
                      this._currentFilterSelected = newValueSelected;
                      return missionData = join;
                    }
                    if (newValueSelected == "Confirmed Missions") {
                      this._currentFilterSelected = newValueSelected;
                      return missionData = confirm;
                    }
                    if (newValueSelected == "Rejected Missions") {
                      this._currentFilterSelected = newValueSelected;
                      return missionData = reject;
                    }
                    if (newValueSelected == "Liked Missions") {
                      this._currentFilterSelected = newValueSelected;
                      return missionData = liker;
                    }
                    if (newValueSelected == "Saved Missions") {
                      this._currentFilterSelected = newValueSelected;
                      return missionData = save;
                    }
                    if (newValueSelected == "Waiting Missions") {
                      this._currentFilterSelected = newValueSelected;

                      return missionData = waiting;
                    }
                  });
                },
                value: _currentFilterSelected,
              ),
            ),
            Divider(
              indent: 25.0,
              endIndent: 25.0,
              color: Colors.indigo,
            ),
            Container(
                height: data.size.height * 2 / 3,
                child: un == null
                    ? Center(child: CircularProgressIndicator())
                    : missionData == null
                        ? Center(child: Text('No Mission'))
                        : ListView.builder(
                            itemCount:
                                missionData == null ? 0 : missionData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Conditioned.boolean(
                                  int.tryParse(missionData[index]['image']) ==
                                      1,
                                  trueBuilder: () => Container(
                                        width: 250,
                                        height: 450,
                                        color: Colors.white,
                                        child: Card(
                                          margin: EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundImage: getImage(
                                                                missionData[
                                                                        index][
                                                                    'user_id']) ==
                                                            null
                                                        ? AssetImage(
                                                            "images/2.png")
                                                        : NetworkImage(
                                                            "${getImage(missionData[index]['user_id'])}"),
                                                    maxRadius: 40,
                                                    backgroundColor:
                                                        Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  Text(missionData[index]
                                                      ['title']),
                                                ],
                                              ),
                                              Container(
                                                height: 80,
                                                child: Image(
                                                  image: NetworkImage(
                                                      '${getMissionImage(missionData[index]['_id'])}'),
                                                ),
                                              ),
                                              Container(
                                                height: 150,
                                                child: Text(missionData[index]
                                                    ['description']),
                                              ),
                                              ButtonBar(
                                                alignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.thumb_up,
                                                        color: ch_like(
                                                            missionData[index]
                                                                ['_id'],
                                                            index),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          like_op(
                                                              missionData[index]
                                                                  ['_id'],
                                                              missionData[index]
                                                                  ['user_id'],
                                                              missionData[index]
                                                                  ['title']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.add_to_photos,
                                                        color: ch_follower(
                                                            missionData[index]
                                                                ['user_id']),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          follower_op(
                                                              missionData[index]
                                                                  ['user_id']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.turned_in,
                                                        color: ch_save(
                                                            missionData[index]
                                                                ['user_id']),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          save_op(
                                                              missionData[index]
                                                                  ['_id'],
                                                              missionData[index]
                                                                  ['user_id'],
                                                              missionData[index]
                                                                  ['title']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.share,
                                                        color: _hasBeenPressed3
                                                            ? Colors.blue
                                                            : Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _hasBeenPressed3 =
                                                              !_hasBeenPressed3;
                                                        });
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                  falseBuilder: () => Container(
                                        width: 250,
                                        height: 350,
                                        color: Colors.white,
                                        child: Card(
                                          margin: EdgeInsets.all(10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                //crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundImage: getImage(
                                                                missionData[
                                                                        index][
                                                                    'user_id']) ==
                                                            null
                                                        ? AssetImage(
                                                            "images/2.png")
                                                        : NetworkImage(
                                                            "${getImage(missionData[index]['user_id'])}"),
                                                    backgroundColor:
                                                        Colors.white,
                                                    maxRadius: 40,
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                  ),
                                                  Text(missionData[index]
                                                      ['title']),
                                                ],
                                              ),
                                              Container(
                                                height: 150,
                                                child: Text(missionData[index]
                                                    ['description']),
                                              ),
                                              ButtonBar(
                                                alignment: MainAxisAlignment
                                                    .spaceEvenly,
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.thumb_up,
                                                        color: ch_like(
                                                            missionData[index]
                                                                ['_id'],
                                                            index),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          like_op(
                                                              missionData[index]
                                                                  ['_id'],
                                                              missionData[index]
                                                                  ['user_id'],
                                                              missionData[index]
                                                                  ['title']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.add_to_photos,
                                                        color: ch_follower(
                                                            missionData[index]
                                                                ['user_id']),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          follower_op(
                                                              missionData[index]
                                                                  ['user_id']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.turned_in,
                                                        color: ch_save(
                                                            missionData[index]
                                                                ['user_id']),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          save_op(
                                                              missionData[index]
                                                                  ['_id'],
                                                              missionData[index]
                                                                  ['user_id'],
                                                              missionData[index]
                                                                  ['title']);
                                                        });
                                                      }),
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.share,
                                                        color: _hasBeenPressed3
                                                            ? Colors.blue
                                                            : Colors.black,
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _hasBeenPressed3 =
                                                              !_hasBeenPressed3;
                                                        });
                                                      }),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                            }))
          ],
        ));
  }

  String mission_image_url;
  var Url;
  getMissionImage(var mission_id) {
    print(mission_id);
    for (var i in MImages) {
      if (i['mission_id'] == mission_id) {
        var image = i['image'];

        return mission_image_url = Url + image;
      }
    }
  }

  int ch_1;
  Future<void> getliker() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var res = await getlike("api/liker/$userId");

    if (res.data['check'] == 0) {
      setState(() {
        return ch_1 = 0;
      });
    }
    if (res.data['check'] == 1) {
      setState(() {
        ch_1 = 1;
        return Liker = res.data['Liker'];
      });
    }
  }

  int ch_2;
  Future<void> getfollower() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var res = await getlike("api/join/$userId");

    if (res.data['check'] == 0) {
      setState(() {
        return ch_2 = 0;
      });
    }
    if (res.data['check'] == 1) {
      setState(() {
        ch_2 = 1;
        return Follower = res.data['Join'];
      });
    }
  }

  int ch_3;
  Future<void> getsave() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var res = await getlike("api/save/$userId");

    if (res.data['check'] == 0) {
      setState(() {
        return ch_3 = 0;
      });
    }
    if (res.data['check'] == 1) {
      setState(() {
        ch_3 = 1;
        return Save = res.data['Save'];
      });
    }
  }

  Color color;
  int ch;
  ch_like(var mission, int index) {
    if (ch_1 == 0) {
      return color = Colors.black;
    }
    if (ch_1 == 1) {
      for (var i in Liker) {
        if (i['mission_liked_id'] == mission) {
          return color = Colors.blue;
        }
      }
      return color = Colors.black;
    }
  }

  ch_follower(var mission) {
    if (ch_2 == 0) {
      return color = Colors.black;
    }
    if (ch_2 == 1) {
      for (var i in Follower) {
        if (i['mission_id'] == mission) {
          return color = Colors.blue;
        }
      }
      return color = Colors.black;
    }
  }

  ch_save(var mission) {
    if (ch_3 == 0) {
      return color = Colors.black;
    }
    if (ch_3 == 1) {
      for (var i in Save) {
        if (i['mission_id'] == mission) {
          return color = Colors.blue;
        }
      }
      return color = Colors.black;
    }
  }

  like_op(var mission_id, var user_mission_id, var mission_title) async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var user_name = sharedpreference.getString("user_name");
    var not = "$user_name Has just liked your Mission";
    if (ch_1 == 0) {
      var res = await like(
          "api/liker", {"user_id": userId, "mission_liked_id": mission_id});
      if (res.ok) {
        print(res.data);
        var res2 = await http_post("api/notification", {
          "notification_": not,
          "title": mission_title,
          "user_id": userId,
          "mission_liked_id": mission_id,
          "user_mission_id": user_mission_id,
          "status": 1
        });
        setState(() {
          getliker();
        });
      }
    }
    if (ch_1 == 1) {
      int ch;
      for (var i in Liker) {
        if (i['mission_liked_id'] == mission_id) {
          var res = await deletelike("api/liker/$mission_id");
          if (res.ok) {
            setState(() {
              getliker();
              return ch = 1;
            });
          }
        }
      }
      if (ch != 1) {
        var res = await like(
            "api/liker", {"user_id": userId, "mission_liked_id": mission_id});
        if (res.ok) {
          var res2 = await http_post("api/notification", {
            "notification_": not,
            "title": mission_title,
            "user_id": userId,
            "mission_liked_id": mission_id,
            "user_mission_id": user_mission_id,
            "status": 1
          });
          print(res.data);
          setState(() {
            getliker();
          });
        }
      }
    }
  }

  follower_op(var mission_id) async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");

    print(mission_id);
    if (ch_2 == 0) {
      print('add1');
      var res =
          await like("api/join", {"user_id": userId, "mission_id": mission_id});
      print(res.data);
      if (res.ok) {
        setState(() {
          getfollower();
        });
      }
    }
    if (ch_2 == 1) {
      int ch;
      for (var i in Follower) {
        if (i['mission_id'] == mission_id) {
          var res = await deletelike("api/join/$mission_id");
          if (res.ok) {
            print(res.data);
            setState(() {
              getfollower();
              return ch = 1;
            });
          }
        }
      }
      if (ch != 1) {
        var res = await like(
            "api/join", {"user_id": userId, "mission_id": mission_id});
        if (res.ok) {
          setState(() {
            getfollower();
          });
        }
      }
    }
  }

  save_op(var mission_id, var user_mission_id, var mission_title) async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var user_name = sharedpreference.getString("user_name");
    var not = "$user_name Has just join your Mission";
    if (ch_3 == 0) {
      var res =
          await like("api/save", {"user_id": userId, "mission_id": mission_id});
      print(res.data);
      if (res.ok) {
        var res2 = await http_post("api/notification", {
          "notification_": not,
          "title": mission_title,
          "user_id": userId,
          "mission_liked_id": mission_id,
          "user_mission_id": user_mission_id,
          "status": 1
        });
        setState(() {
          getsave();
        });
      }
    }
    if (ch_3 == 1) {
      int ch;
      for (var i in Save) {
        if (i['mission_id'] == mission_id) {
          var res = await deletelike("api/save/$mission_id");
          if (res.ok) {
            setState(() {
              getsave;
              return ch = 1;
            });
          }
        }
      }
      if (ch != 1) {
        var res = await like(
            "api/save", {"user_id": userId, "mission_id": mission_id});
        if (res.ok) {
          var res2 = await http_post("api/notification", {
            "notification_": not,
            "title": mission_title,
            "user_id": userId,
            "mission_liked_id": mission_id,
            "user_mission_id": user_mission_id,
            "status": 1
          });
          setState(() {
            getsave();
          });
        }
      }
    }
  }
}
