import 'package:fael_khair/Screens/home_page.dart';
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fael_khair/http.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences sharedpreference;
  TextEditingController user_name = TextEditingController();

  void initState() {
    super.initState();
    checkLoginState();
    det();
    getfollower();
  }

  checkLoginState() async {
    sharedpreference = await SharedPreferences.getInstance();
    if (sharedpreference.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  List missionData;
  List follow;
  List followers;
  int intfollowers;
  int length;
  int intfollow;
  Future<void> det() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("id");
    var follower_id = userId;
    var token = sharedpreference.getString("token");
    var result = await user("api/users/$userId");
    var result2 = await get_user_mission(token, "api/mission/user/$userId");
    var result3 = await getfolower("api/follower/$userId");
    var result4 = await getfolower("api/follower/follower/$follower_id");
    if (result.ok) {
      setState(() {
        user_name.text = result.data['name'];
      });
    }
    if (result2.ok) {
      setState(() {
        missionData = result2.data['Mission'];
        print('h:${result2.data['check']}');
        if (result2.data['check'] == 0) {
          length = 0;
        } else {
          length = missionData.length;
        }
      });
    }
    if (result3.ok) {
      setState(() {
        follow = result3.data['Follower'];
        print('h2:${result3.data['check']}');
        if (result3.data['check'] == 0) {
          intfollow = 0;
        } else {
          intfollow = follow.length;
        }
      });
    }
    if (result4.ok) {
      setState(() {
        followers = result4.data['Follower'];
        print('h3:${result4.data['check']}');
        if (result4.data['check'] == 0) {
          intfollowers = 0;
        } else {
          intfollowers = followers.length;
        }
      });
    }
  }

  var followStatus = true;
  var followStatustxt = 'Follow';
  var whiteColor = Colors.white;
  var indigoColor = Colors.indigo;
  var followbuttonColor;
  var followTextColor;

  void followFunction() {
    setState(() {
      follower_op();
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: nu == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.only(
                  top: data.padding.top,
                  bottom: data.padding.bottom,
                  right: data.padding.right,
                  left: data.padding.left),
              children: <Widget>[
                Container(
                    width: data.size.width,
                    height: data.size.height * 3 / 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.deepPurpleAccent, Colors.deepPurple]),
                    ),
                    child: Container(
                      width: data.size.width,
                      height: data.size.height,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 50,
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage('images/mazin.JPG'),
                              radius: 70.0,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              user_name.text,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: data.size.width * 0.6,
                                decoration: BoxDecoration(
                                  color: followbuttonColor,
                                  borderRadius: BorderRadius.circular(29),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    followFunction();
                                  },
                                  child: Text(
                                    followStatustxt,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: followTextColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              clipBehavior: Clip.antiAlias,
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 22.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Posts",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$length",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Followers",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$intfollowers",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            "$intfollow",
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.pinkAccent,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
    );
  }

  int ch_2;
  var Follower;
  int nu;
  Future<void> getfollower() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var follower_id = sharedpreference.getString("id");
    var res = await getlike("api/follower/$userId");

    if (res.data['check'] == 0) {
      setState(() {
        followStatustxt = 'Follow +';
        followbuttonColor = whiteColor;
        followTextColor = indigoColor;
        followStatus = false;
        nu = 0;
        return ch_2 = 0;
      });
    }
    if (res.data['check'] == 1) {
      setState(() {
        ch_2 = 1;
        Follower = res.data['Follower'];
        for (var i in Follower) {
          if (i['follower_id'] == follower_id) {
            setState(() {
              followStatustxt = 'Following';
              followbuttonColor = indigoColor;
              followTextColor = whiteColor;
              followStatus = true;
            });
          }
        }
        nu = 1;
      });
    }
  }

  ch_follower() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("id");
    if (ch_2 == 0) {
      Follower = 0;
      setState(() {
        followStatustxt = 'Follow +';
        followbuttonColor = whiteColor;
        followTextColor = indigoColor;
        followStatus = false;
      });
    }
    if (ch_2 == 1) {
      Follower = 0;
      for (var i in Follower) {
        if (i['follower_id'] == userId) {
          setState(() {
            followStatustxt = 'Following';
            followbuttonColor = indigoColor;
            followTextColor = whiteColor;
            followStatus = true;
          });
        }
      }
      followStatustxt = 'Follow +';
      followbuttonColor = whiteColor;
      followTextColor = indigoColor;
      return followStatus = false;
    }
  }

  follower_op() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var follower_id = sharedpreference.getString("id");
    if (ch_2 == 0) {
      print('add1');
      var res = await like(
          "api/follower", {"user_id": userId, "follower_id": follower_id});
      print(res.data);
      if (res.ok) {
        setState(() {
          getfollower();
          det();
        });
      }
    }
    if (ch_2 == 1) {
      int ch;
      for (var i in Follower) {
        if (i['follower_id'] == follower_id) {
          var res = await deletelike("api/follower/followers/$follower_id");
          if (res.ok) {
            print(res.data);
            setState(() {
              getfollower();
              det();
              return ch = 1;
            });
          }
        }
      }
      if (ch != 1) {
        var res = await like(
            "api/follower", {"user_id": userId, "follower_id": follower_id});
        if (res.ok) {
          setState(() {
            getfollower();
            det();
          });
        }
      }
    }
  }
}
