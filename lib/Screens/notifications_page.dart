import 'package:fael_khair/Screens/home_page.dart';
import 'package:fael_khair/Screens/missions_page.dart';
import 'package:fael_khair/Screens/search_result.dart';
import 'package:fael_khair/localization_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fael_khair/http.dart';

// ignore: camel_case_types
class Notifications_Page extends StatefulWidget {
  @override
  _Notifications_PageState createState() => _Notifications_PageState();
}

// ignore: camel_case_types
class _Notifications_PageState extends State<Notifications_Page> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    not();
  }

  var tra;
  List notifications;
  SharedPreferences sharedpreference;
  Future<void> not() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var result = await user("api/notification/$userId");
    if (result.ok) {
      if (result.data['check'] == 0) {
        setState(() {
          tra = 0;
        });
      } else {
        setState(() {
          tra = 1;
          notifications = result.data['Notification'];
        });
      }
    } else {}
  }

  Future<void> up(var mission_id, var name) async {
    var result = await http_post("api/notification/$mission_id", {"status": 0});
    if (result.ok) {
      if (result.data['check'] == 1) {
        setState(() {
          not();
        });
        print(name);
        go(name);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return Scaffold(
            body: CustomScrollView(
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
                getTranslate(context, 'Notifications'),
                style: TextStyle(fontSize: 25),
              ),
            ),
            SliverList(
              delegate: tra == null
                  ? SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                      return Container(
                            child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    childCount:1,
                    )
                  : tra == 0
                      ? SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                          return Container(
                            child: Center(child: Text('no Notifications Founded')),
                          );
                        },
                        childCount:1,
                        )
                      : SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              height: 100,
                              margin: EdgeInsets.all(20.0),
                              child: Card(
                                child: ListTile(
                                  tileColor: notifications[index]['status'] == 0
                                      ? null
                                      : Color(0xFF6F35A5),
                                  contentPadding: EdgeInsets.all(10.0),
                                  leading: CircleAvatar(
                                    maxRadius: 30,
                                    backgroundImage:
                                        AssetImage("images/mazin.JPG"),
                                  ),
                                  title: Text(
                                    "${notifications[index]['notification_']}",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  onTap: () {
                                    up(notifications[index]['mission_id'],
                                        notifications[index]['title']);
                                  },
                                ),
                              ),
                            );
                          },
                          childCount:
                              notifications == null ? 0 : notifications.length,
                        ),
            )
          ],
        ));
  }

  Future<void> go(var a) async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    sharedpreference.setString("result", a);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return search_result();
      }),
    );
  }
}
