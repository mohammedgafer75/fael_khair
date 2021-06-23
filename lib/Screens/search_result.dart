import 'package:condition/condition.dart';
import 'package:fael_khair/Screens/add_mission.dart';
import 'package:fael_khair/Screens/home_page.dart';
import 'package:fael_khair/Screens/page1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:fael_khair/http.dart';
import 'profile.dart';
import '../localization_methods.dart';

class search_result extends StatefulWidget {
  search_result({Key key}) : super(key: key);

  @override
  _search_resultState createState() => _search_resultState();
}

class _search_resultState extends State<search_result> {
  void initState() {
    super.initState();
    get_result();
    getliker();
    getfollower();
    getUImages();
    getMImages();
    getsave();
  }

  var Data;
  int check;
  var Liker;
  var Follower;
  var MImages;
  var UImages;
  var Save;
  var image;
  Future<void> get_result() async {
    sharedpreference = await SharedPreferences.getInstance();
    var result = sharedpreference.getString("result");
    print(result);
    String token = sharedpreference.getString("token");
    var res = await get_mission(token, 'api/mission/search/$result');
    if (res.ok) {
      var mission = res.data['Mission'];
      print(mission);
      var user = res.data['User'];
      print('User:$user');
      if (mission == null) {
        setState(() {
          check = 1;
          Data = user;
        });
      } else {
        setState(() {
          check = 2;
          Data = mission;
          image = Data['image'];
        });
      }
    }
  }

  Future<void> go(BuildContext context, var id) async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    sharedpreference.setString("id", id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Profile();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search_Result'),
      ),
      body: Data == null
          ? Center(child: CircularProgressIndicator())
          : Conditioned.boolean(
              check == 1,
              trueBuilder: () => Container(
                child: Center(
                    child: ListView(children: <Widget>[
                  Text(Data['name']),
                  TextButton(
                    child: Text(
                      "go to profile",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      setState(() {
                        go(context, Data['_id']);
                      });
                    },
                  ),
                ])),
              ),
              falseBuilder: () => Conditioned.boolean(image == 1,
                  trueBuilder: () => Container(
                        //  width: 250,
                        // height: 450,
                        color: Colors.white,
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  CircleAvatar(
                                    backgroundImage:
                                        getImage(Data['user_id']) == null
                                            ? AssetImage("images/Logo.png")
                                            : NetworkImage(
                                                "${getImage(Data['user_id'])}"),
                                    maxRadius: 40,
                                    backgroundColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(Data['title']),
                                ],
                              ),
                              Container(
                                height: 80,
                                child: Image(
                                  image: NetworkImage(
                                      '${getMissionImage(Data['_id'])}'),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: Text(Data['description']),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: ch_like(
                                          Data['_id'],
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          like_op(Data['_id'], Data['user_id'],
                                              Data['title']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add_to_photos,
                                        color: ch_follower(Data['_id']),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          follower_op(Data['_id']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.turned_in,
                                        color: ch_save(Data['_id']),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          save_op(Data['_id'], Data['user_id'],
                                              Data['title']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {});
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                  falseBuilder: () => Container(
                        //  width: 250,
                        //  height: 350,
                        color: Colors.white,
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  CircleAvatar(
                                    backgroundImage:
                                        getImage(Data['user_id']) == null
                                            ? AssetImage("images/Logo.png")
                                            : NetworkImage(
                                                "${getImage(Data['user_id'])}"),
                                    backgroundColor: Colors.white,
                                    maxRadius: 40,
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  Text(Data['title']),
                                ],
                              ),
                              Container(
                                height: 150,
                                child: Text(Data['description']),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: ch_like(
                                          Data['_id'],
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          like_op(Data['_id'], Data['user_id'],
                                              Data['title']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.add_to_photos,
                                        color: ch_follower(Data['_id']),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          follower_op(Data['_id']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.turned_in,
                                        color: ch_save(Data['_id']),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          save_op(Data['_id'], Data['user_id'],
                                              Data['title']);
                                        });
                                      }),
                                  IconButton(
                                      icon: Icon(
                                        Icons.share,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {});
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
            ),
    );
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
  ch_like(var mission) {
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

  String image_url;
  getImage(var userId) {
    for (var i in UImages) {
      if (i['user_id'] == userId) {
        var image = i['image'];
        print(image);
        return image_url = Url + image;
      }
    }
  }

  String mission_image_url;
  getMissionImage(var mission_id) {
    print(mission_id);
    for (var i in MImages) {
      if (i['mission_id'] == mission_id) {
        var image = i['image'];

        return mission_image_url = Url + image;
      }
    }
  }

  var Url;
  Future<void> getMImages() async {
    var res = await getimage('api/images2');
    if (res.ok) {
      setState(() {
        Url = res.url;
      });
      print(res.data);
      return MImages = res.data;
    }
  }

  Future<void> getUImages() async {
    var res = await getimage('api/images');
    if (res.ok) {
      print(res.data);
      return UImages = res.data;
    }
  }
}
