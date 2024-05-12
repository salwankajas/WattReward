import 'package:flutter/material.dart';
import 'package:ev/login/signIn.dart';
import 'package:ev/util/enum.dart';

class Choose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Align(
          alignment: FractionalOffset.topCenter,
          child: Container(
            margin: EdgeInsets.only(
                top: (MediaQuery.of(context).size.height / 100) * 16),
            height: 160,
            width: 320,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/227356.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
        Text("Select User",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 5),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            minimumSize: Size(300, 50),
            textStyle: TextStyle(fontSize: 16),
            foregroundColor: Color.fromARGB(255, 99, 225, 103),
            side: BorderSide(color: Color.fromARGB(255, 99, 225, 103)),
          ),
          child: Text("Shop", style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: () => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn(entity: Entity.shop)))
          },
        ),
        SizedBox(height: (MediaQuery.of(context).size.height / 100) * 1.5),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            minimumSize: Size(300, 50),
            textStyle: TextStyle(fontSize: 16),
            // primary: Color.fromARGB(255, 99, 225, 103),
            // onPrimary: Colors.white,
            backgroundColor: Color.fromARGB(255, 99, 225, 103),
            foregroundColor: Colors.white,
            shadowColor: Color.fromARGB(255, 26, 255, 0),
            elevation: 4,
          ),
          child: Text("User", style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: () => {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignIn(entity: Entity.user)))
          },
        ),
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
                color: Colors.black,
              ),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 4),
            ),
            // Second Circle
            Container(
              width: 10.0,
              height: 10.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              margin: EdgeInsets.symmetric(vertical: 20,horizontal: 4),
            ),
          ],
        )
      ]),
    );
  }
}
