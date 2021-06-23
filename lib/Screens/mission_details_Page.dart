import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http.dart';

class MissionDetails extends StatefulWidget {
  @override
  _MissionDetailsState createState() => _MissionDetailsState();
}

class _MissionDetailsState extends State<MissionDetails> {
  @override
  void initState() {
    super.initState();
    get_result();
  }

  var Data;
  Future<void> get_result() async {
    SharedPreferences sharedpreference = await SharedPreferences.getInstance();
    var result = sharedpreference.getString("result2");
    print(result);
    String token = sharedpreference.getString("token");
    var res = await get_mission(token, 'api/mission/search/$result');
    if (res.ok) {
      var mission = res.data['Mission'];
      setState(() {
          Data = mission;
          print('Data: $Data');
          print(Data['title']);
        });
      
    //  setState(() {
     // print(Data);
     //    Data = mission;
         
     // });
     
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Mission Details"),
      ),
      body: Data == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                children: [
                  Container(
                    width: 250,
                    height: 850,
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
                                backgroundImage: AssetImage("images/Logo.png"),
                                maxRadius: 40,
                                backgroundColor: Colors.white,
                              ),
                              SizedBox(
                                width: 100,
                              ),
                              Text("${Data['title']}"),
                            ],
                          ),
                          Container(
                            height: 80,
                            child: Image(
                              image: AssetImage("images/Logo.png"),
                            ),
                          ),
                          Container(
                            height: 20,
                            child: Text("${Data['description']}"),
                          ),
                          Container(
                            height: 20,
                            child: Text("${Data['Time']}"),
                          ),
                          Container(
                            height: 20,
                            child: Text("${Data['location_id']}"),
                          ),
                          Container(
                            height: 20,
                            child: Text("${Data['Mumbers']}"),
                          ),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.add_to_photos,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.turned_in,
                                  ),
                                  onPressed: () {
                                    setState(() {});
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
                ],
              ),
            ),
    );
  }
}
