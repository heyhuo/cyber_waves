import 'dart:io';

import 'package:cyber_waves/pages/HomeMainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // /*保存xml到本机*/
  final prefs = await SharedPreferences.getInstance();
  // var andIp="192.168.123.206";
  var andIp="10.2.12.199";

  prefs.setBool("ifIOS", Platform.isIOS);
  prefs.setBool("ifPrd", false);
  prefs.setBool("ifReal_d", false);

  prefs.setString("urlPath_real_d", "10.2.12.154");
  prefs.setString("scheme_real_d", "http");
  prefs.setInt("ports_real_d", 8088);

  prefs.setString("urlPath_ios_d", "127.0.0.1");
  prefs.setString("scheme_ios_d", "http");
  prefs.setInt("ports_ios_d", 5000);

  prefs.setString("urlPath_and_d", andIp); //10.0.2.2
  prefs.setString("scheme_and_d", "http");
  prefs.setInt("ports_and_d", 8088);

  prefs.setString("urlPath_p", "118.26.177.76");
  prefs.setString("scheme_p", "http");
  prefs.setInt("ports_p", 80);

  prefs.setString("picsServer", "www.heyhuo.com");

  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        shadowColor: Color(0xff566C73),  //綪御纳户
        primaryColorDark: Color(0xff3d6263), //綪御纳户566C73
        primaryColorLight: Color(0xff78C2C4),
        primaryColor: Color(0xff78C2C4),
      ),
      home: HomeMainPage(),
    );
  }
}

