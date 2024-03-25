import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ev/util/rewardCalculate.dart';
import 'package:ev/util/cryptoTrans.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web3dart/web3dart.dart';

final storage = new FlutterSecureStorage();

class Rewarding extends StatelessWidget {
  final textController = TextEditingController();
  late CryptoTrans cryptoTrans;
  final String data;
  Rewarding({super.key, required String this.data}){
    cryptoTrans = CryptoTrans();
  }

  @override
  Widget build(BuildContext context) {
    var split = data.split(";");
    cryptoTrans.publicAddress = EthereumAddress.fromHex(split[0]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 80,
        ),
        Center(
            child: Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        )),
        SizedBox(
          height: 10,
        ),
        Center(child: Text(split[1], style: TextStyle(color: Colors.grey))),
        SizedBox(
          height: 10,
        ),
        Center(child: Text(split[0], style: TextStyle(color: Colors.grey))),
        SizedBox(
          height: 30,
        ),
        const Align(
          alignment: Alignment.center,
          child: Text(
            "Total Purchase Amount",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
        ),
        Center(
            child: Container(
          width: 120,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.lightGreen))),
          child: TextField(
            textInputAction: TextInputAction.search,
            controller: textController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              border: InputBorder.none,
              // hintText: 'Shop Name',
            ),
            style: TextStyle(color: Colors.black),
            cursorColor: Colors.green,
          ),
        )),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            minimumSize: Size(120, 40),
            textStyle: TextStyle(fontSize: 16),
            // primary: Color.fromARGB(255, 99, 225, 103),
            // onPrimary: Colors.white,
            backgroundColor: Color.fromARGB(255, 99, 225, 103),
            foregroundColor: Colors.white,
            shadowColor: Color.fromARGB(255, 26, 255, 0),
            elevation: 4,
          ),
          child: Text("Reward", style: TextStyle(fontWeight: FontWeight.w700)),
          onPressed: ()async{
            var priv = await storage.read(key: "privateKey");
            int amount = RewardCalculator.calculateRewards(double.parse(textController.text)).round();
            // showAlertDialog(context);
            var res = await cryptoTrans.sendCoinTwo(amount, priv!, EthereumAddress.fromHex(split[0]));
            print(res);
            },
        ),
      ]),
    );
  }

  // showAlertDialog(BuildContext context) { ... }

}
