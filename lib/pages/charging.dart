import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ev/util/csCryptoTrans.dart';
import 'package:ev/util/CryptoTrans.dart';
import 'package:web3dart/web3dart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChargingScreen extends StatelessWidget {
  final int time;
  final int chargeRate;
  final int fees;
  final int percLimit;
  final int percentage;
  final String cs;
  final int slot;
  final String priv;
  final String privcs;
  final String ev;
  ChargingScreen(
      {super.key,
      required this.time,
      required this.chargeRate,
      required this.fees,
      required this.percLimit,
      required this.percentage,
      required this.slot,
      required this.cs,
      required this.ev,
      required this.priv,
      required this.privcs});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charging"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              // Add close button functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Add more options functionality
            },
          ),
        ],
      ),
      body: ChargingBody(
          time: time,
          chargeRate: chargeRate,
          fees: fees,
          percLimit: percLimit,
          percentage: percentage,
          slot: slot,
          cs: cs,
          ev: ev,
          priv: priv,
          privcs: privcs),
    );
  }
}

class ChargingBody extends StatefulWidget {
  final CsCryptoTrans crypto = CsCryptoTrans();
  final CryptoTrans cryptoToken = CryptoTrans();
  final int time;
  final int chargeRate;
  final int fees;
  final int percLimit;
  final String cs;
  final int slot;
  final int percentage;
  final String ev;
  final String priv;
  final String privcs;
  ChargingBody({
    super.key,
    required this.time,
    required this.chargeRate,
    required this.fees,
    required this.percLimit,
    required this.percentage,
    required this.slot,
    required this.cs,
    required this.priv,
    required this.privcs,
    required this.ev,
  }) {
    // crypto.publicAddress = EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
    cryptoToken.publicAddress =
        EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
  }
  @override
  _ChargingBody createState() => _ChargingBody();
}

class _ChargingBody extends State<ChargingBody> {
  final socket = IO.io('http://192.168.1.6:5002', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  late String curPerc;
  double fee = 0;
  late BuildContext contexts;
  bool _showProgressDialog = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    socket.close();
    print("DFgr");
    socket.clearListeners();
    super.dispose();
  }

  @override
  void initState() {
    curPerc = widget.percentage.toString();
    socket.connect();
    socket.on(
        "initialized",
        (data) => {
              setState(() {
                _showProgressDialog = false;
              })
            });
    String jsonMessage = jsonEncode({
      "message": "START_CHARGING",
      "data": {
        "privcs": widget.privcs,
        "curPerc": widget.percentage,
        "percLimit": widget.percLimit,
        "costEst": widget.fees,
        "from": widget.ev,
        "to": widget.cs,
        "slot": widget.slot,
        "chargeRate": widget.chargeRate
      }
    });
    socket.onConnect((_) {
      print('connect');
      socket.emit('message', jsonMessage);
    });
    super.initState();
    socket.on(
        "stop",
        (data) =>
            // setState(() {
            showDialog(
              context: contexts,
              barrierDismissible:
                  false, // Prevents users from dismissing the dialog by tapping outside
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CircularProgressIndicator(),
                      Text(
                        'Charging Finished...',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
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
                        child: Text("Ok",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        onPressed: () {
                          socket.close();
                          print("DFgr");
                          socket.clearListeners();
                          Navigator.pushReplacementNamed(context, '/home');
                          // Navigator.pop(context);
                        },
                      ),

                      // Text('Please wait...'),
                    ],
                  ),
                );
              },
            )
        // Navigator.pop(contexts);
        // })
        );
    socket.on(
        "percentage",
        (data) => setState(() {
              curPerc = data;
              fee = (int.parse(widget.fees.toString()) /
                      (100 - widget.percentage)) *
                  (int.parse(curPerc) - widget.percentage);
            }));
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return _showProgressDialog
        ? AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green,),
                SizedBox(height: 16),
                Text('Initialising Charging Station...'),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.battery_charging_full,
                            color: Colors.yellow,
                            size: 50,
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${curPerc} %", // Change with actual value
                            style: TextStyle(fontSize: 18),
                          ),
                          // SizedBox(height: 5),
                          // Text(
                          //   "${widget.chargeRate} kWh", // Change with actual value
                          //   style: TextStyle(fontSize: 18),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("Charging Time"),
                      Text(
                          "${widget.percLimit - int.parse(curPerc)} sec"), // Change with actual value
                    ],
                  ),
                  Column(
                    children: [
                      Text("Battery Percentage"),
                      Text("${widget.percentage}%"), // Change with actual value
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Column(
                  //   children: [
                  //     Text("Current (Ampere)"),
                  //     Text("10 A"), // Change with actual value
                  //   ],
                  // ),
                  Column(
                    children: [
                      Text("Total Fee"),
                      // Text("${(widget.fees * (int.parse(curPerc)-widget.percentage)/100).ceil()} evc"), // Change with actual value
                      Text(fee.ceil().toString() +
                          "evc"), // Change with actual value
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // print(await crypto.endCharge(privcs, EthereumAddress.fromHex(cs), slot, time));
                  // // int cost = await crypto.getPayment(EthereumAddress.fromHex(cs), slot);
                  // print(await cryptoToken.transferFrom(privcs,EthereumAddress.fromHex(ev),EthereumAddress.fromHex(cs),fees));
                  // Navigator.pop(context);
                  String jsonMessage = jsonEncode({
                    "message": "STOP_CHARGING",
                    "data": {"priv": widget.privcs}
                  });
                  socket.emit('message', jsonMessage);
                  // await channel.ready;
                  print("STOP_CHARGING");
                },
                child: Text(
                  "Stop Charging",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          );
  }
}
