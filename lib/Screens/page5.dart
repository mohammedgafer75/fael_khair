import 'package:fael_khair/Screens/add_mission.dart';
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:condition/condition.dart';
import '../http.dart';
import '../localization_methods.dart';
import 'home_page.dart';
import 'mission_details_Page.dart';

class Page5 extends StatefulWidget {
  @override
  _Page5State createState() => _Page5State();
}

class _Page5State extends State<Page5> {
  void initState() {
    super.initState();
    checkLoginState();
    getmission();
    getliker();
    getfollower();
    getUImages();
    getMImages();
    getsave();
  }

  Future<void> missionDetails(var a) async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    sharedpreference.setString("result2", a);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return MissionDetails();
      }),
    );
  }

  SharedPreferences sharedpreference;

  List Data;
  var Liker;
  var Follower;
  var MImages;
  var UImages;
  var Save;
  checkLoginState() async {
    sharedpreference = await SharedPreferences.getInstance();
    sharedpreference.setString("cat_id", '5');
    if (sharedpreference.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  int un;
  Future<void> getmission() async {
    sharedpreference = await SharedPreferences.getInstance();
    var catid = sharedpreference.getString("cat_id");
    var res = await getcat("api/category/$catid");

    if (res.ok) {
      setState(() {
        Data = res.data['Cat'];
        un = 1;
      });
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

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return WillPopScope(
        onWillPop: () {
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MyHomePage();
          }));
        },
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add_circle,
                size: 45,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return AddMission();
                  }),
                );
              }),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                centerTitle: true,
                expandedHeight: data.size.height / 4,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                    "images/image2.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(
                  getTranslate(context, 'Other'),
                  style: TextStyle(fontSize: 25),
                ),
              ),
              SliverList(
                delegate: un == null
                    ? SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        childCount: 1,
                      )
                    : Data == null
                        ? SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Center(
                                child: Text('no Mission Founded'),
                              );
                            },
                            childCount: 1,
                          )
                        : SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Conditioned.boolean(
                                  int.tryParse(Data[index]['image']) == 1,
                                  trueBuilder: () => InkWell(
                                        onTap: () {
                                          missionDetails(Data[index]['title']);
                                        },
                                        child: Container(
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          "${getImage(Data[index]['user_id'])}"),
                                                      maxRadius: 40,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                    ),
                                                    Text(Data[index]['title']),
                                                  ],
                                                ),
                                                Container(
                                                  height: 80,
                                                  child: Image(
                                                    image: NetworkImage(
                                                        '${getMissionImage(Data[index]['_id'])}'),
                                                  ),
                                                ),
                                                Container(
                                                  height: 150,
                                                  child: Text(Data[index]
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
                                                              Data[index]
                                                                  ['_id'],
                                                              index),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            like_op(
                                                                Data[index]
                                                                    ['_id'],
                                                                Data[index]
                                                                    ['user_id'],
                                                                Data[index]
                                                                    ['title']);
                                                          });
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.turned_in,
                                                          color: ch_follower(
                                                              Data[index]
                                                                  ['user_id']),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            follower_op(Data[
                                                                    index]
                                                                ['user_id']);
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
                                      ),
                                  falseBuilder: () => InkWell(
                                        onTap: () {
                                          missionDetails(Data[index]['title']);
                                        },
                                        child: Container(
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          "${getImage(Data[index]['user_id'])}"),
                                                      maxRadius: 40,
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                    ),
                                                    Text(Data[index]['title']),
                                                  ],
                                                ),
                                                Container(
                                                  height: 150,
                                                  child: Text(Data[index]
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
                                                              Data[index]
                                                                  ['_id'],
                                                              index),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            like_op(
                                                                Data[index]
                                                                    ['_id'],
                                                                Data[index]
                                                                    ['user_id'],
                                                                Data[index]
                                                                    ['title']);
                                                          });
                                                        }),
                                                    IconButton(
                                                        icon: Icon(
                                                          Icons.turned_in,
                                                          color: ch_follower(
                                                              Data[index]
                                                                  ['user_id']),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            follower_op(Data[
                                                                    index]
                                                                ['user_id']);
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
                                      ));
                            },
                            childCount: Data == null ? 0 : Data.length,
                          ),
              )
            ],
          ),
        ));
  }
}

Widget listitem(String title, String desc) => Container(
      width: 250,
      height: 350,
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
                  backgroundImage: AssetImage("images/mazin.JPG"),
                  maxRadius: 40,
                ),
                SizedBox(
                  width: 100,
                ),
                Text(title),
              ],
            ),
            Container(
              height: 150,
              child: Text(desc),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Icon(Icons.thumb_up),
                Icon(Icons.turned_in_not),
                Icon(Icons.add_circle_outline)
              ],
            )
          ],
        ),
      ),
    );
