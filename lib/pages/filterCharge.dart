import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:ev/util/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FilterCharge extends StatefulWidget {
  final int slot;
  final String id;
  FilterCharge({super.key, required this.slot, required this.id});
  @override
  _FilterChargeState createState() => _FilterChargeState();
}

class _FilterChargeState extends State<FilterCharge> {
  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    print(selectedIndex);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Filter Charge",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Making the text bold
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 0; // Update the selected index
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
              ),
              margin: EdgeInsets.all(12),
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12), // Add padding to the left for the text
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Full Charge",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Radio<int>(
                      activeColor: Colors.green,
                      value: 0,
                      groupValue: selectedIndex,
                      onChanged: (int? value) {
                        setState(() {
                          selectedIndex = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 1; // Update the selected index
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
              ),
              margin: EdgeInsets.all(12),
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12), // Add padding to the left for the text
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Full Charge",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Radio<int>(
                      activeColor: Colors.green,
                      value: 1,
                      groupValue: selectedIndex,
                      onChanged: (int? value) {
                        setState(() {
                          selectedIndex = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = 2; // Update the selected index
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 246, 246),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5),
              ),
              margin: EdgeInsets.all(12),
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 12), // Add padding to the left for the text
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Full Charge",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Radio<int>(
                      activeColor: Colors.green,
                      value: 2,
                      groupValue: selectedIndex,
                      onChanged: (int? value) {
                        setState(() {
                          selectedIndex = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: Size(280, 50),
                textStyle: TextStyle(fontSize: 16),
                // primary: Color.fromARGB(255, 99, 225, 103),
                // onPrimary: Colors.white,
                backgroundColor: Color.fromARGB(255, 99, 225, 103),
                foregroundColor: Colors.white,
                shadowColor: Color.fromARGB(255, 26, 255, 0),
                elevation: 4,
              ),
              child: Text("Start Charging",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: () async {
                DocumentSnapshot<Object?> data =
                    await readDB(Entity.shop, widget.id);
                Map<String, dynamic> datas =
                    data!.data() as Map<String, dynamic>;
                DateTime now = DateTime.now();
                if (now.millisecondsSinceEpoch -
                        int.parse(datas["charger"]['${selectedIndex}']
                                ["timestamp"]
                            .toString()) <
                    90000) {
                  print("connect");
                } else {
                  // print("please reconnect plug to ev");
                  Fluttertoast.showToast(
                      msg: "Please reconnect plug to ev",
                      backgroundColor: Colors.grey,
                      fontSize: 14,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.white);
                }
              },
            ),
          ),
        ]));
  }
}
