import 'package:ev/choose.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ev/util/auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
String? name = "";

class Acc extends StatefulWidget {
  @override
  _Acc createState() => _Acc();
}

class _Acc extends State<Acc> {
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    storage.read(key: "name").then((names) => {
          setState(() {
            name = names;
          })
        });

    // print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Container(
          height: 160,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120.0,
                    height: 120.0,
                    child: Center(
                        child: Image.asset(
                      "assets/images/avatar1.jpg",
                      width: 120,
                      height: 120,
                    )),
                  ),
                  Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.green, // Set the color of the border
                        width: 2.0, // Set the width of the border
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Center(child: Text(name!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
              )
            ],
          ),
        ),
        InkWell(
            onTap: () {
              print("tapped");
            },
            child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(width: 1, color: Colors.green),
                      ),
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      // alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Iconsax.info_circle),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Help",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    )))),
        InkWell(
            onTap: () async {
              await signOutFromGoogle();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Choose()));
            },
            child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(width: 1, color: Colors.green),
                      ),
                ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      // alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Iconsax.logout),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Sign Out",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ))))
      ],
    );
  }
}
