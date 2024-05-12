import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:ev/util/database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ev/util/csCryptoTrans.dart';
import 'package:ev/util/cryptoTrans.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ev/pages/charging.dart';

final storage = new FlutterSecureStorage();

class FilterCharge extends StatefulWidget {
  final int slot;
  final String id;
  FilterCharge({super.key, required this.slot, required this.id});
  @override
  _FilterChargeState createState() => _FilterChargeState();
}

class _FilterChargeState extends State<FilterCharge> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  final CsCryptoTrans crypto = CsCryptoTrans();
  final CryptoTrans cryptoToken = CryptoTrans();
  bool perc = false;
  bool min = false;
  bool _isValid = true;
  int selectedIndex = -1;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    // crypto.pu /blicddress = EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
    cryptoToken.publicAddress =
        EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
    super.initState();
  }

  Future<void> _asyncFunction(
      BuildContext context, datas, time, publicKey, chargeRate) async {
        int perc=0;
    // Simulating some asynchronous operation, e.g., fetching data from an API
    print(selectedIndex);
    if (selectedIndex == 0) {
      // print((((int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) - int.parse(datas["charger"]['${widget.slot}']["currentBattery"]))/chargeRate)*60).ceil());
      time = ((((int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) -
                      int.parse(datas["charger"]['${widget.slot}']
                          ["currentBattery"])) /
                  chargeRate) *
              60)
          .ceil());
      perc = 100;
    } else if (selectedIndex == 1) {
      if (((int.parse(datas["charger"]['${widget.slot}']["currentBattery"]
                      .toString()) /
                  int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]
                      .toString())) *
              100) >=
          int.parse(_controller.text)) {
        Fluttertoast.showToast(
            msg: "Percentage less than current",
            backgroundColor: Colors.grey,
            fontSize: 14,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.white);
        return;
      } else {
        var perwatt =
            int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) *
                (int.parse(_controller.text) / 100);
        perc = int.parse(_controller.text);
        // print((((perwatt - int.parse(datas["charger"]['${widget.slot}']["currentBattery"]))/chargeRate)*60).ceil());
        time = ((((perwatt -
                        int.parse(datas["charger"]['${widget.slot}']
                            ["currentBattery"])) /
                    chargeRate) *
                60)
            .ceil());
      }
    } else if (selectedIndex == 2) {
      if (int.parse(_controller1.text) >
          ((((int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) -
                          int.parse(datas["charger"]['${widget.slot}']
                              ["currentBattery"])) /
                      chargeRate) *
                  60)
              .ceil())) {
        time =
            ((((int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) -
                            int.parse(datas["charger"]['${widget.slot}']
                                ["currentBattery"])) /
                        chargeRate) *
                    60)
                .ceil());
        perc = 100;
      } else {
        time = int.parse(_controller1.text);
        perc = (((int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]) -
                            int.parse(datas["charger"]['${widget.slot}']
                                ["currentBattery"]))/int.parse(datas["charger"]['${widget.slot}']["TotalBattery"]))*100).toInt();
      }
      // print(await crypto.getBalance(EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5")));
      // print(await crypto.startCharge("f16d49322270b645b6b25babcc61bd484ac2c04ca898d8fc0015390e3d9e081e",EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5"),EthereumAddress.fromHex("0x60706846c7bd6dc4679c388944421a053d3e129b"),0,5,1));
      // print(await crypto.transfer("75464c7931cca77018340d553d53f458d180e350b471c4209c3007f53572185b",EthereumAddress.fromHex("0x749c62e9ff5d3f856c398d0aea33e42674d737d9"),EthereumAddress.fromHex("0x60706846c7bd6dc4679c388944421a053d3e129b"),50));
    }
    int costEstimated =
        await crypto.estimateChargingCost((chargeRate / 60).ceil(), time);
        print(costEstimated);
    int balance = await cryptoToken.getBalance(EthereumAddress.fromHex(publicKey!));
        print("balance "+balance.toString());
    if (balance <
        costEstimated) {
      Fluttertoast.showToast(
          msg: "insufficient balance",
          backgroundColor: Colors.grey,
          fontSize: 14,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.white);
    } else {
      // await cryptoToken.approve("f16d49322270b645b6b25babcc61bd484ac2c04ca898d8fc0015390e3d9e081e",EthereumAddress.fromHex(datas["publicKey"]), costEstimated);
      // var res = await crypto.startCharge(datas["privateKey"], EthereumAddress.fromHex(publicKey), EthereumAddress.fromHex(datas["publicKey"]), widget.slot, chargeRate, time);
      var res = "sd";
      if (res != "s") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Success!'),
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ChargingScreen(
                      time: time,
                      chargeRate: chargeRate,
                      fees: costEstimated,
                      percentage: ((int.parse(datas["charger"]['${widget.slot}']
                                          ["currentBattery"]
                                      .toString()) /
                                  int.parse(datas["charger"]['${widget.slot}']
                                          ["TotalBattery"]
                                      .toString())) *
                              100)
                          .toInt(),
                      slot: widget.slot,
                      cs: datas["publicKey"],
                      ev: publicKey,
                      priv:
                          "f16d49322270b645b6b25babcc61bd484ac2c04ca898d8fc0015390e3d9e081e",
                      privcs: datas["privateKey"],
                      percLimit: perc,
                    )));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('error!')));
      }
    }
    // Once the operation is complete, show success message
  }

  @override
  Widget build(BuildContext context) {
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
        body: ListView(
          // alignment: Alignment.center,
          children: [
            // SizedBox(
            // height: MediaQuery.of(context).size.height - 100,
            // child:
            // SingleChildScrollView(
            // child:
            Column(children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                    min = false;
                    perc = false; // Update the selected index
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 246, 246),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 0.5),
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
                              min = false;
                              perc = false;
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
                    selectedIndex = 1;
                    min = false;
                    perc = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 246, 246),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 0.5),
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
                              "Percentage",
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
                              perc = true;
                              min = false;
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
                    selectedIndex = 2;
                    perc = false; // Update the selected index
                    min = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 246, 246, 246),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 0.5),
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
                              "Minute",
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
                              min = true;
                              perc = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: perc, // Show the input text bar if showInput is true
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // margin: EdgeInsets.only(bottom: 100),
                    child: SizedBox(
                        width: 170,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            // alignLabelWithHint: true,
                            labelText: 'Percentage for charging',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              // Customize the border when enabled
                              borderSide: BorderSide(
                                  color: Colors.black), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                            border: OutlineInputBorder(
                              // Customize the border
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),

                            focusedBorder: OutlineInputBorder(
                              // Customize the focused border
                              borderSide: BorderSide(
                                  color: Colors.black), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                            errorText: _isValid ? null : 'Invalid input',
                          ),
                          style: TextStyle(color: Colors.black),
                          onChanged: (value) {
                            setState(() {
                              _isValid = _validateInput(value);
                            });
                          },
                        ))),
              ),
              Visibility(
                visible: min, // Show the input text bar if showInput is true
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    // margin: EdgeInsets.only(bottom: 100),
                    child: SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            // alignLabelWithHint: true,
                            labelText: 'Minutes for charging',
                            labelStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                            enabledBorder: OutlineInputBorder(
                              // Customize the border when enabled
                              borderSide: BorderSide(
                                  color: Colors.black), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                            border: OutlineInputBorder(
                              // Customize the border
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),

                            focusedBorder: OutlineInputBorder(
                              // Customize the focused border
                              borderSide: BorderSide(
                                  color: Colors.black), // Border color
                              borderRadius:
                                  BorderRadius.circular(10), // Border radius
                            ),
                            // errorText: _isValid ? null : 'Invalid input',
                          ),
                          style: TextStyle(color: Colors.black),
                          // onChanged: (value) {
                          //   setState(() {
                          //     _isValid = _validateInput(value);
                          //   });
                          // },
                        ))),
              ),
              SizedBox(
                height: 100,
              )
            ]),
            // )
            // ),
            // Positioned(
            //   bottom: 10,
            //   child:
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
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
                  int chargeRate = 30;
                  int time = 0;
                  String? publicKey = await storage.read(key: "publicKey");
                  DocumentSnapshot<Object?> data =
                      await readDB(Entity.shop, widget.id);
                  Map<String, dynamic> datas =
                      data!.data() as Map<String, dynamic>;
                  DateTime now = DateTime.now();
                  if (now.millisecondsSinceEpoch -
                          int.parse(datas["charger"]['${widget.slot}']
                                  ["timestamp"]
                              .toString()) <
                      120000) {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevents users from dismissing the dialog by tapping outside
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.green,),
                              SizedBox(height: 16),
                              Text('Please wait...'),
                            ],
                          ),
                        );
                      },
                    );
                    _asyncFunction(context, datas, time, publicKey, chargeRate)
                        .then((_) {
                      // Dismiss the loading dialog after async function completes
                      // Navigator.of(context).pop();
                    });
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
              // ),
            )
          ],
        ));
  }

  bool _validateInput(String value) {
    if (value.isEmpty) {
      return true; // Allow empty input
    }
    try {
      int number = int.parse(value);
      return number >= 1 && number <= 100;
    } catch (e) {
      return false; // Invalid input (not a number)
    }
  }
}
