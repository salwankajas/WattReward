import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ev/home.dart';
import 'package:ev/choose.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'package:ev/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Raster
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // final User? _auth = FirebaseAuth.instance!.currentUser;
  // print(_auth);
  runApp(MyApp());
}
// Color.fromARGB(255, 95, 190, 98)

class MyApp extends StatelessWidget {
  final User? user = FirebaseAuth.instance!.currentUser;
  late Widget firstWidget;
  @override
  Widget build(BuildContext context) {
    if(user != null){
      firstWidget = Home();
    }else{
      firstWidget = Choose();
    }
    return MaterialApp(
      title: 'Flutter Map Example',
      home: firstWidget,
      debugShowCheckedModeBanner: false,
    );
    
  }
}
