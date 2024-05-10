import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class CryptoTrans {
  late Web3Client ethClient;
  late String entit;
  CryptoTrans([String entity ='']) {
    this.entit = entity;
    Client httpClient = Client();
    ethClient =
        Web3Client("https://rpc-amoy.polygon.technology", httpClient);
  }
  Stream<FilterEvent>? event;
  late EthereumAddress publicAddress;

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = "0x965b9ca7dd9ec22ff615a156b731e97b7baf9da1";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "EVCoin"),
        EthereumAddress.fromHex(contractAddress));
    if (event == null && publicAddress != null) {
      final auctionEvent = contract.event('Transfer');
      String to = "0x000000000000000000000000" + publicAddress.toString().substring(2);
      FilterOptions options;
      if(entit != ''){
        options = FilterOptions(
        address: contract.address,
        topics: [
          [bytesToHex(auctionEvent.signature, padToEvenLength: true, include0x: true)],
          [to],
          []
        ],
      );
      }else{
      options = FilterOptions(
        address: contract.address,
        topics: [
          [bytesToHex(auctionEvent.signature, padToEvenLength: true, include0x: true)],
          [],
          [to]
        ],
      );
      }
      event = ethClient.events(options);
    }
    return contract;
  }

  Stream<FilterEvent> loadEvent(){
    return event!;
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

  Future<int> getBalance(EthereumAddress credentialAddress) async {
    List<dynamic> result = await query("balanceOf", [credentialAddress]);
    BigInt data = result[0];
    return data.toInt();
    // balance = data.toDouble();
  }
  // Future<int> approve(EthereumAddress spender,int value) async {
  //   List<dynamic> result = await query("approve", [spender,BigInt.from(value)]);
  //   BigInt data = result[0];
  //   return data.toInt();
  //   // balance = data.toDouble();
  // }

  Future<String> approve(String privAddress,EthereumAddress spender,int value) async {
    // var bigAmount = BigInt.from(myAmount);
    var response = await submit("approve", [spender,BigInt.from(value)],privAddress);
    return response;
  }
  Future<String> sendCoinTwo(int myAmount,String privAddress,EthereumAddress targetAddress) async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("transfer",[targetAddress,bigAmount],privAddress);
    return response;
  }
  Future<String> transferFrom(String privAddress,EthereumAddress from,EthereumAddress to,int value) async {
    var response = await submit("transferFrom",[from,to,BigInt.from(value)],privAddress);
    return response;
  }

  Future<String> submit(String functionName, List<dynamic> args,String privAddress) async {
    DeployedContract contract = await loadContract();
    final ethFunction = contract.function(functionName);
    EthPrivateKey key = EthPrivateKey.fromHex(privAddress);
    Transaction transaction = Transaction.callContract(contract: contract, function: ethFunction, parameters: args);
    final result = await ethClient.sendTransaction(key,transaction ,chainId:80002);
    return result;
  }

}
