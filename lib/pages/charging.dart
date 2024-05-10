import 'package:flutter/material.dart';
import 'package:ev/util/csCryptoTrans.dart';
import 'package:ev/util/CryptoTrans.dart';
import 'package:web3dart/web3dart.dart';

class ChargingScreen extends StatelessWidget {
  final int time;
  final int chargeRate;
  final int fees;
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
      required this.percentage,
      required this.slot,
      required this.cs,
      required this.ev,
      required this.priv,
      required this.privcs
      });
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
        percentage: percentage,
        slot:slot,
        cs: cs,
        ev:ev,
        priv:priv,
        privcs:privcs

      ),
    );
  }
}

class ChargingBody extends StatelessWidget {
  final CsCryptoTrans crypto = CsCryptoTrans();
  final CryptoTrans cryptoToken = CryptoTrans();
  final int time;
  final int chargeRate;
  final int fees;
  final String cs;
  final int slot;
  final int percentage;
  final String ev;
  final String priv;
  final String privcs;
  ChargingBody(
      {super.key,
      required this.time,
      required this.chargeRate,
      required this.fees,
      required this.percentage,
      required this.slot,
      required this.cs,
      required this.priv,
      required this.privcs,
      required this.ev,
      }){
        // crypto.publicAddress = EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
    cryptoToken.publicAddress = EthereumAddress.fromHex("0xfbe7f0842387a5269bf86e370e4fbc71f542fcf5");
      }
  @override
  Widget build(BuildContext context) {
    return Column(
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
                      "${chargeRate} kWh", // Change with actual value
                      style: TextStyle(fontSize: 18),
                    ),
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
                Text(time.toString()+" min"), // Change with actual value
              ],
            ),
            Column(
              children: [
                Text("Battery Percentage"),
                Text("${percentage}%"), // Change with actual value
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
                Text("${fees} evc"), // Change with actual value
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async{
            print(await crypto.endCharge(privcs, EthereumAddress.fromHex(cs), slot, time));
            // int cost = await crypto.getPayment(EthereumAddress.fromHex(cs), slot);
            print(await cryptoToken.transferFrom(privcs,EthereumAddress.fromHex(ev),EthereumAddress.fromHex(cs),fees));
            Navigator.pop(context);
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
