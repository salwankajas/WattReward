import 'package:flutter/material.dart';
import 'package:ev/home.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ev/util/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';



class SignIn extends StatelessWidget {
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
                image: AssetImage('images/signUp.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        // SizedBox(height: (MediaQuery.of(context).size.height/100)*2.5),
        Text("Sign Up",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 2.5),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(300, 50),
              textStyle: TextStyle(fontSize: 14),
              primary: Colors.black,
              side: BorderSide(color: Color.fromARGB(255, 99, 225, 103)),
            ),
            child: const Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/icon/google.png"),
                  width: 30,
                  height: 30,
                ),
                Text("Continue With Google",
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            onPressed: ()async{
                  UserCredential user = await signInWithGoogle();
                  await storage.write(key: "name", value: user.user!.displayName);
                  await storage.write(key: "email", value: user.user!.email);
                  print(await storage.read(key:"name"));   
                  if(user != null){
                    Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                  }
                }),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 1.5),
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(300, 50),
              textStyle: TextStyle(fontSize: 14),
              primary: Colors.black,
              side: BorderSide(color: Color.fromARGB(255, 99, 225, 103)),
            ),
            child: const Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/icon/phone.png"),
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
                color: Colors.grey,
              ),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 4),
            ),
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
