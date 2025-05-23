import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ukll/pages/Login.dart';
import 'package:ukll/pages/Welcome.dart';
import 'package:ukll/pages/playlist.dart';
import 'package:ukll/pages/songlist.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Apply SSL bypass globally
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => LoginPage(),
      '/Welcome': (context) =>  WelcomePage(),
      '/Playlist': (context) => PlaylistPage(),
    },
  ));
}
