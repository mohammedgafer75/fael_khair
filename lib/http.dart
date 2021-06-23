import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestResult {
  bool ok;
  dynamic data;
  String url;
  RequestResult(this.ok, this.data, this.url);
}

const PROTOCOL = "https";
// https
// http
const DOMAIN = "faelkhair.herokuapp.com";
// faelkhair.herokuapp.com
// 10.0.2.2:7000
const fullUrl = "$PROTOCOL://$DOMAIN/";

Future<RequestResult> get_login(String route, [dynamic data]) async {
  var datastr = jsonEncode(data);
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http
      .post(url, body: datastr, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

// ignore: non_constant_identifier_names
Future<RequestResult> http_post(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var datastr = jsonEncode(data);
  var result = await http
      .post(url, body: datastr, headers: {"Content-Type": "application/json"});
  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

// ignore: non_constant_identifier_names
Future<RequestResult> add_mission(String token, String route,
    [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var datastr = jsonEncode(data);
  var result = await http.post(url,
      body: datastr,
      headers: {"Content-Type": "application/json", "Authorization": "$token"});
  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> user(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

// ignore: non_constant_identifier_names
Future<RequestResult> get_user_mission(String token, String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url,
      headers: {"Content-Type": "application/json", "Authorization": "$token"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> get_mission(String token, String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url,
      headers: {"Content-Type": "application/json", "Authorization": "$token"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> getcat(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> like(String route, [dynamic data]) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var datastr = jsonEncode(data);
  var result = await http
      .post(url, body: datastr, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> getlike(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> deletelike(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.delete(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> getimage(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}

Future<RequestResult> getfolower(String route) async {
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result =
      await http.get(url, headers: {"Content-Type": "application/json"});

  return RequestResult(true, jsonDecode(result.body), fullUrl);
}
