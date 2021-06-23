import 'package:fael_khair/localization_methods.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Gifts_page extends StatefulWidget {
  @override
  _Gifts_pageState createState() => _Gifts_pageState();
}

// ignore: camel_case_types
class _Gifts_pageState extends State<Gifts_page> {
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
            getTranslate(context, 'Gifts'),
            style: TextStyle(fontSize: 25),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              var n = 5;
              if (index > n) return null;
              return listitem();
            },
            childCount: 5,
          ),
        )
      ],
    ));
  }

  Widget listitem() => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/2.png"), fit: BoxFit.fill),
        ),
        width: 250,
        height: 400,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 25.0,
            ),
            Expanded(
              child: Image(
                image: AssetImage("images/image4.png"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFF1E6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  getTranslate(context, 'tGifts'),
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Divider(
              thickness: 5.0,
              color: Colors.black,
              indent: 20.0,
              endIndent: 20.0,
            ),
            SizedBox(
              height: 45.0,
            ),
          ],
        ),
      );
}
