import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/nav/acc.dart';
import 'package:ev/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ev/util/wallet_creation.dart';
import 'package:ev/util/database.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:ev/util/cryptoTrans.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ev/util/qrGenerate.dart';

final storage = new FlutterSecureStorage();

class Wallet extends StatefulWidget {
  @override
  _Wallet createState() => _Wallet();
}

class _Wallet extends State<Wallet> with AutomaticKeepAliveClientMixin<Wallet> {
  late Client httpClient;
  late CryptoTrans cryptoTrans;
  late Stream<FilterEvent> event;
  late Web3Client ethClient;
  int? selected;
  String? publicAddress;
  String? privateAddress;
  String? name;
  bool isWallet = false;
  bool clicked = false;
  Color clr = Colors.black;
  Color clr1 = Colors.black;
  int balance = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    cryptoTrans = CryptoTrans();
    super.initState();

    // print(name);
  }

  Future<bool> getWallet() async {
    if (isWallet) {
      return true;
    } else {
      var res = await storage.read(key: "isWallet");
      // var ress;
      if (res == null) {
        String? id = await storage.read(key: "id");
        DocumentSnapshot<Object?> data = await readDB(Entity.user, id!);
        // Map<String, dynamic> datas = data.data() as Map<String, dynamic>;
        isWallet = data["wallet"];
        if (isWallet) {
          privateAddress = data["privateKey"];
          await storage.write(key: "privateKey", value: privateAddress);
          publicAddress = data["publicKey"];
          await storage.write(key: "publicKey", value: publicAddress);
          name = data["name"];
          await storage.write(key: "name", value: name);
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
        name = await storage.read(key: "name");
        cryptoTrans.publicAddress = EthereumAddress.fromHex(publicAddress!);
        balance = await cryptoTrans
              .getBalance(EthereumAddress.fromHex(publicAddress!));
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
                      // balance.toStringAsFixed(2) + " EVCN",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          onTap: () async {
                            balance = await cryptoTrans.getBalance(
                                EthereumAddress.fromHex(publicAddress!));
                            setState(() {});
                          },
                          child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(
                                    Iconsax.wallet,
                                    color: clr,
                                  ),
                                  Text(
                                    "Buy",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: clr),
                                  ),
                                ],
                              ))),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTapDown: (e) {
                            setState(() {
                              clr1 = Colors.green;
                            });
                            Future.delayed(const Duration(milliseconds: 100))
                                .then((val) {
                              setState(() {
                                clr1 = Colors.black;
                              });
                            });
                          },
                          onTap: () async => {
                                // print(publicAddress)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) {
                                      return QRImage("$publicAddress;$name");
                                    }),
                                  ),
                                )
                              },
                          child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Icon(
                                    Iconsax.barcode,
                                    color: clr1,
                                  ),
                                  Text(
                                    "QR Code",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: clr1),
                                  ),
                                ],
                              ))),
                    ],
                  ),
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
                                await storage.write(
                                    key: "isWallet", value: "true");
                                await storage.write(
                                    key: "privateKey", value: privateAddress);
                                await storage.write(
                                    key: "publicKey", value: publicAddress);
                                addWallet(id!, Entity.user, privateAddress!,
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
