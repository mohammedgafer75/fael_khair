import 'page1.dart';
import 'page2.dart';
import 'page3.dart';
import '../Screens/page4.dart';
import 'page5.dart';
import 'package:flutter/material.dart';

class PageViewer extends StatefulWidget {
  int initialPage;
  PageViewer({this.initialPage});
  @override
  _PageViewerState createState() => _PageViewerState();
}

class _PageViewerState extends State<PageViewer> {
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: widget.initialPage,
    );
  }

  List<Widget> pages = [Page1(), Page2(), Page3(), Page4(), Page5()];
  var controller;
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      children: pages,
    );
  }
}
