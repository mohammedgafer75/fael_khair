import 'package:fael_khair/Screens/MyProfile.dart';
import 'package:fael_khair/Screens/Settings.dart';
import 'package:fael_khair/Screens/about_page.dart';
import 'package:fael_khair/Screens/donate_page.dart';
import 'package:condition/condition.dart';
import 'package:fael_khair/Screens/gifts_page.dart';
import 'package:fael_khair/Screens/notifications_page.dart';
import 'package:fael_khair/Screens/page1.dart';
import 'package:fael_khair/Screens/search_result.dart';
import 'package:fael_khair/Screens/sign_in.dart';
import 'package:fael_khair/Screens/sponsors_page.dart';
import 'package:fael_khair/http.dart';
import 'package:fael_khair/localization_methods.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'page_Viewer.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'missions_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> list;

  void initState() {
    super.initState();
    checkLoginState();
    det();
    getImage();
    getmission1();
    not();
  }

  final double barHeight = 66.0;
  SharedPreferences sharedpreference;

  checkLoginState() async {
    sharedpreference = await SharedPreferences.getInstance();
    if (sharedpreference.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  // ignore: non_constant_identifier_names
  TextEditingController user_name = TextEditingController();
  TextEditingController email = TextEditingController();

  // ignore: non_constant_identifier_names
  Future<void> det() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var result = await user("api/users/$userId");
    sharedpreference.setString("user_name", result.data['name']);
    if (result.ok) {
      setState(() {
        user_name.text = result.data['name'];
        email.text = result.data['email'];
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  var tra;
  var notifications;
  int count = 0;
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
          for (var item in notifications) {
            if (item['status'] == 1) {
              count++;
            }
          }
        });
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SignIn_page()),
          (Route<dynamic> route) => false);
    }
  }

  String image_url;

  Future<void> getImage() async {
    sharedpreference = await SharedPreferences.getInstance();
    var userId = sharedpreference.getString("user_id");
    var res = await getimage('api/images/$userId');
    if (res.ok) {
      print('h:${res.data}');
      var url = res.url;
      var image = res.data[0]['image'];
      if (image == null) {
        return image_url = null;
      } else {
        return image_url = url + image;
      }
    }
  }

  List Data;
  List Data2;
  List finalData;
  Future<void> getmission1() async {
    sharedpreference = await SharedPreferences.getInstance();
    String token = sharedpreference.getString("token");

    var res = await get_mission(token, "api/mission");
    var res2 = await user("api/users");

    if (res.ok && res2.ok) {
      setState(() {
        if (res.data.isNotEmpty) {
          Data = List.generate(
              res.data.length, (index) => "${res.data[index]['title']}");
        }
        if (res2.data.isNotEmpty) {
          Data2 = List.generate(
              res2.data.length, (index) => "${res2.data[index]['name']}");
        }
        finalData = Data + Data2;
        print(finalData);
      });
      if (finalData.isNotEmpty) {
        setState(() {
          list =
              List.generate(finalData.length, (index) => "${finalData[index]}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    // ignore: non_constant_identifier_names
    final DrawerHeader = UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      margin: EdgeInsets.all(10),
      onDetailsPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return MyProfile();
          }),
        );
      },
      accountName: Text(
        user_name.text,
        style: TextStyle(fontSize: 22),
      ),
      accountEmail: Text(
        email.text,
        style: TextStyle(fontSize: 20),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 50.0,
        child: Image(
          image: image_url == null
              ? AssetImage("images/Logo.png")
              : NetworkImage(image_url),
        ),
      ),
    );
    final drawerItems = Container(
      padding: EdgeInsets.only(
        top: data.padding.top,
        bottom: data.padding.bottom,
      ),
      color: Colors.indigo,
      child: ListView(
        children: <Widget>[
          DrawerHeader,
          ListTile(
            leading: Icon(
              Icons.post_add,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Missions'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Missions_page();
                }),
              );
            },
          ),
          ListTile(
            trailing: count == 0
                ? SizedBox()
                : CircleAvatar(
                    child: Text('$count'),
                  ),
            leading: Icon(
              Icons.notifications_active,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Notifications'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Notifications_Page();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.clean_hands,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Donate'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Donate_page();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.card_giftcard,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Gifts'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Gifts_page();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.supervisor_account_sharp,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Sponsors'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Sponsors_page();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.details,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'About'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return About_page();
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Settings'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Settings(image_url);
                }),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'logout'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return SignIn_page();
              }), (route) => false);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 25,
              color: Colors.white,
            ),
            title: Text(
              getTranslate(context, 'Exit'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );

    //var data = MediaQuery.of(context);

    return tra == null
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.indigo,
            //Color(0xFF7b1fa2),// Color(0xFFE1BEE7),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: Search(list));
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            extendBodyBehindAppBar: true,
            drawer: Drawer(
              child: drawerItems,
            ),
            body: Container(
                width: data.size.width,
                height: data.size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("images/Logo.png")),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: data.padding.top + 10,
                    bottom: data.padding.bottom + 10,
                    left: data.padding.left + 75,
                  ),
                  child: ListView(
                    children: <Widget>[
                      view(getTranslate(context, 'Healthy'),
                          "images/image4.png", context, 0),
                      view(getTranslate(context, 'Education'),
                          "images/image3.jpg", context, 1),
                      view(getTranslate(context, 'Longevity'),
                          "images/image1.jpg", context, 2),
                      view(getTranslate(context, 'food'), "images/image5.jpg",
                          context, 3),
                      view(getTranslate(context, 'Other'), "images/image2.jpg",
                          context, 4),
                    ],
                  ),
                )),
          );
  }
}

Widget view(textv, imagev, BuildContext context, nav) {
  var data = MediaQuery.of(context);
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageViewer(
                    initialPage: nav,
                  )));
    },
    child: Container(
      width: data.size.width * 3 / 4,
      height: data.size.height * 1 / 4.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.yellow]),
        image: DecorationImage(
          image: AssetImage(imagev),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.srgbToLinearGamma(),
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        textv,
        style: TextStyle(
            fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    //elevation: 10.0,
    // color: Colors.deepPurpleAccent,
  );
}

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;

  Search(this.listExample);

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<void> go(var a) async {
      SharedPreferences sharedpreference =
          await SharedPreferences.getInstance();
      sharedpreference.setString("result", a);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return search_result();
        }),
      );
    }

    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
            // In the false case
            (element) => element.contains(query),
          ));
    print(suggestionList.length);

    return ListView.builder(
      itemCount: suggestionList.length == 0
          ? suggestionList.length + 1
          : suggestionList.length,
      itemBuilder: (context, index) {
        return Conditioned.boolean(
          suggestionList.isEmpty,
          trueBuilder: () {
            return ListTile(
              title: Text("No Mission Founded"),
              leading: SizedBox(),
            );
          },
          falseBuilder: () {
            return ListTile(
              title: Text(
                suggestionList[index],
              ),
              leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
              onTap: () {
                selectedResult = suggestionList[index];
                print(selectedResult);
                go(selectedResult);
              },
            );
          },
        );
      },
    );
  }
}
