import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/util/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ev/util/wallet_creation.dart';
import 'package:ev/util/database.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:ev/util/qrScan.dart';

final storage = new FlutterSecureStorage();

class Reward extends StatefulWidget {
  @override
  _Reward createState() => _Reward();
}

class _Reward extends State<Reward> with AutomaticKeepAliveClientMixin<Reward> {
  late Client httpClient;
  late Web3Client ethClient;
  int? selected;
  String? publicAddress;
  String? privateAddress;
  bool isWallet = false;
  bool clicked = false;
  Color clr = Colors.black;
  double balance = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(
        "https://polygon-mumbai.g.alchemy.com/v2/yGX6D3Chr52l2FIkF5YQ3THPPMVaWECk",
        httpClient);
    super.initState();

    // print(name);
  }

  Future<bool> getWallet() async {
    if (isWallet) {
      return true;
    } else {
      var res = await storage.read(key: "isWallet");
      if (res == null) {
        String? id = await storage.read(key: "id");
        DocumentSnapshot<Object?> data = await readUser(id!);
        Map<String, dynamic> datas = data!.data() as Map<String, dynamic>;
        isWallet = data["wallet"];
        if (isWallet) {
          privateAddress = data["privateKey"];
          await storage.write(key: "privateKey", value: privateAddress);
          publicAddress = data["publicKey"];
          await storage.write(key: "privateKey", value: publicAddress);
          await storage.write(key: "isWallet", value: "true");
          getBalance(EthPrivateKey.fromHex(privateAddress!).address);
          return true;
        } else {
          return false;
        }
      } else if (res == "true") {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = "0x965b9ca7dd9ec22ff615a156b731e97b7baf9da1";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "EVCoin"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    try {
      final contract = await loadContract();
      final ethFunction = contract.function(functionName);
      final result = await ethClient.call(
          contract: contract, function: ethFunction, params: args);
      return result;
    } catch (error, trace) {
      print(error);
      return [];
    }
  }

  Future<void> getBalance(EthereumAddress credentialAddress) async {
    List<dynamic> result = await query("balanceOf", [credentialAddress]);
    BigInt data = result[0];
    setState(() {
      balance = data.toDouble();
    });
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
                      balance.toStringAsFixed(2) + " EVCN",
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
                        Future.delayed(const Duration(milliseconds: 200)).then((val) {
                          setState(() {
                            clr = Colors.black;
                          });
                        });
                      },
                      onTap: () => {
                        Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QRCodeScannerApp()))

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
                              SizedBox(height: 5,),
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
                                await storage.write(
                                    key: "isWallet", value: "true");
                                await storage.write(
                                    key: "privateKey", value: privateAddress);
                                await storage.write(
                                    key: "privateKey", value: publicAddress);
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
