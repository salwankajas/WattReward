import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:ev/home.dart';
import 'package:ev/choose.dart';
//Raster
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map Example',
      home: Choose(),
      debugShowCheckedModeBanner: false,
    );
  }
}
