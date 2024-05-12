import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ev/util/wallet_creation.dart';
import 'package:ev/util/database.dart';
import 'package:ev/util/qrScan.dart';
import 'package:ev/util/cryptoTrans.dart';
import 'package:web3dart/web3dart.dart';
import 'package:ev/pages/rewarding.dart';

final storage = new FlutterSecureStorage();

class Reward extends StatefulWidget {
  @override
  _Reward createState() => _Reward();
}

class _Reward extends State<Reward> with AutomaticKeepAliveClientMixin<Reward> {
  late CryptoTrans cryptoTrans;
  var event;
  int? selected;
  String? publicAddress;
  String? privateAddress;
  bool isWallet = false;
  bool clicked = false;
  Color clr = Colors.black;
  int balance = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    cryptoTrans = CryptoTrans("shop");
    super.initState();

    // print(name);
  }
  Future<bool> isValidEthereumAddress(String data)async{
    var address = data.split(";")[0];
  if (address.length == 42 && address.startsWith("0x")) {
    return true;
  }
  return false;
}
navigator(String datas){
  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Rewarding(data:datas)));
}

  Future<bool> getWallet() async {
    if (isWallet) {
      return true;
    } else {
      var res = await storage.read(key: "isWallet");
      if (res == null) {
        String? id = await storage.read(key: "id");
        DocumentSnapshot<Object?> data = await readDB(Entity.shop, id!);
        Map<String, dynamic> datas = data!.data() as Map<String, dynamic>;
        isWallet = data["wallet"];
        if (isWallet) {
          privateAddress = data["privateKey"];
          await storage.write(key: "privateKey", value: privateAddress);
          publicAddress = data["publicKey"];
          await storage.write(key: "publicKey", value: publicAddress);
          await storage.write(key: "isWallet", value: "true");
          cryptoTrans.publicAddress = EthereumAddress.fromHex(publicAddress!);
          balance = await cryptoTrans
              .getBalance(EthereumAddress.fromHex(publicAddress!));
          event = cryptoTrans.loadEvent();
          event.listen((e) async {
            balance = await cryptoTrans
              .getBalance(EthereumAddress.fromHex(publicAddress!));
            setState(() {});
          });
          return true;
        } else {
          return false;
        }
      } else if (res == "true") {
        privateAddress = await storage.read(key: "privateKey");
        publicAddress = await storage.read(key: "publicKey");
        cryptoTrans.publicAddress = EthereumAddress.fromHex(publicAddress!);
        cryptoTrans.getBalance(EthereumAddress.fromHex(publicAddress!)).then((value) => {if(balance != value){
          setState(() {
            balance = value;
          })
          }});
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: getWallet(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError) {
            return Text("something went wrong");
          }
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return Column(
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    "assets/images/coin.png",
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Text(
                      balance.toString() + " EVCN",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Balance Token",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                      onTapDown: (e) {
                        setState(() {
                          clr = Colors.green;
                        });
                        Future.delayed(const Duration(milliseconds: 200))
                            .then((val) {
                          setState(() {
                            clr = Colors.black;
                          });
                        });
                      },
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => QRCodeScannerApp(isValidFunction: isValidEthereumAddress, navigator: navigator,)))
                          },
                      child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Icon(
                                Iconsax.scan_barcode,
                                color: clr,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Scan QR Code",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: clr),
                              ),
                            ],
                          ))),
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: const Text("Add a Wallet"),
                      ),
                      Container(
                          margin: const EdgeInsets.all(20),
                          child: GestureDetector(
                            child: const Icon(
                              Icons.add,
                              color: Colors.green,
                              size: 26,
                            ),
                            onTap: () async {
                              if (!clicked) {
                                clicked = true;
                                WalletAddress service = WalletAddress();
                                final mnemonic = service.generateMnemonic();
                                final privateKey =
                                    await service.getPrivateKey(mnemonic);
                                final publicKey =
                                    await service.getPublicKey(privateKey);
                                String? id = await storage.read(key: "id");
                                // print(id);
                                privateAddress = privateKey.toString();
                                publicAddress = publicKey.toString();
                                // addUserDetails(privateKey, publicKey);
                                isWallet = true;
                                await storage.write(
                                    key: "isWallet", value: "true");
                                await storage.write(
                                    key: "privateKey", value: privateAddress);
                                await storage.write(
                                    key: "privateKey", value: publicAddress);
                                addWallet(id!, Entity.shop, privateAddress!,
                                    publicAddress!);
                                setState(() {});
                              }
                            },
                          ))
                    ],
                  )
                ],
              );
            }
          }
          return Text("loading");
        });
  }

  @override
  bool get wantKeepAlive => true;
}
