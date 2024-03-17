import 'dart:convert';
import 'package:ev/pages/shopData.dart';
import 'package:ev/pages/shopNav.dart';
import 'package:flutter/material.dart';
import 'package:ev/home.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ev/util/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ev/util/database.dart';
import 'package:ev/util/enum.dart';
import 'package:ev/pages/shopData.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key, required Entity this.entity});
  final Entity entity;
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Align(
          alignment: FractionalOffset.topCenter,
          child: Container(
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height / 100) * 8),
            height: 240,
            width: 260,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/signUp.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        // SizedBox(height: (MediaQuery.of(context).size.height/100)*2.5),
        Text("Let's You In",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 2.5),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(300, 50),
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              side: BorderSide(color: Color.fromARGB(255, 99, 225, 103)),
            ),
            child: const Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/icon/google.png"),
                  width: 30,
                  height: 30,
                ),
                Text("Continue With Google",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            onPressed: () async {
              UserCredential user = await signInWithGoogle();
              print(user);
              await storage.write(key: "name", value: user.user!.displayName);
              await storage.write(key: "email", value: user.user!.email);
              await storage.write(
                  key: "id", value: user.additionalUserInfo!.profile!["id"]);
              print(await storage.read(key: "name"));
              if (user != null) {
                if (user.additionalUserInfo!.isNewUser) {
                  await addUser(user.additionalUserInfo!.profile!["id"], entity,
                      user.user!.displayName!, user.user!.email!);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopData()));
                }
                // await addUser(user.additionalUserInfo!.profile!["id"], entity,
                //     user.user!.displayName!, user.user!.email!);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => ShopData()));
                if (entity.value == "shop") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopNav()));
                } else {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                }
              }
            }),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 1.5),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(300, 50),
              textStyle: TextStyle(fontSize: 14, color: Colors.black),
              side: BorderSide(color: Color.fromARGB(255, 99, 225, 103)),
            ),
            child: const Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/images/icon/phone.png"),
                  width: 20,
                  height: 20,
                ),
                Text("  With Phone Number",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            onPressed: () async => {
                  await signOutFromGoogle()
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (context) => Home()))
                }),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // First Circle
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
            ),
            // Second Circle
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
            ),
          ],
        )
      ]),
    );
  }
}
