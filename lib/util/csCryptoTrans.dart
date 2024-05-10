import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class CsCryptoTrans {
  late Web3Client ethClient;
  late String entit;
  CsCryptoTrans([String entity ='']) {
    this.entit = entity;
    Client httpClient = Client();
    ethClient =
        Web3Client("https://rpc-amoy.polygon.technology", httpClient);
  }
  // Stream<FilterEvent>? event;
  // late EthereumAddress publicAddress;

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abiCs.json");
    String contractAddress = "0xaA9c22584cB9B0767d5D45ED39b8071167FE2f2b";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "abs"),
        EthereumAddress.fromHex(contractAddress));
    // if (event == null) {
    //   final auctionEvent = contract.event('Transfer');
    //   String to = "0x000000000000000000000000" + publicAddress.toString().substring(2);
    //   FilterOptions options;
    //   if(entit != ''){
    //     options = FilterOptions(
    //     address: contract.address,
    //     topics: [
    //       [bytesToHex(auctionEvent.signature, padToEvenLength: true, include0x: true)],
    //       [to],
    //       []
    //     ],
    //   );
    //   }else{
    //   options = FilterOptions(
    //     address: contract.address,
    //     topics: [
    //       [bytesToHex(auctionEvent.signature, padToEvenLength: true, include0x: true)],
    //       [],
    //       [to]
    //     ],
    //   );
    //   }
    //   event = ethClient.events(options);
    // }
    return contract;
  }

  // Stream<FilterEvent> loadEvent(){
  //   return event!;
  // }

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
  Future<int> estimateChargingCost(int chargeRate, int duration) async {
    List<dynamic> result = await query("estimateChargingCost", [BigInt.from(chargeRate),BigInt.from(duration)]);
    BigInt data = result[0];
    return data.toInt();
    // balance = data.toDouble();
  }
  Future<int> getPayment(EthereumAddress csAddress, int slotIndex) async {
    List<dynamic> result = await query("getPayment", [csAddress,BigInt.from(slotIndex)]);
    BigInt data = result[0];
    return data.toInt();
    // balance = data.toDouble();
  }
  Future<String> startCharge(String privAddress, EthereumAddress evAddress, EthereumAddress csAddress, int slotIndex,int chargeRate,int duration) async {
    var response = await submit("startChargingApp",[evAddress,csAddress,BigInt.from(slotIndex),BigInt.from(chargeRate),BigInt.from(duration)],privAddress);
    return response;
    // balance = data.toDouble();
  }
  Future<String> endCharge(String privAddress,EthereumAddress csAddress, int slotIndex,int duration) async {
    var response = await submit("endCharging",[csAddress,BigInt.from(slotIndex),BigInt.from(duration)],privAddress);
    return response;
    // balance = data.toDouble();
  }
  Future<String> transfer(String privAddress, int chargeRate, int duration) async {
    var response = await submit("estimateChargingCost", [chargeRate,duration],privAddress);
    return response;
    // balance = data.toDouble();
  }

  Future<String> sendCoinTwo(int myAmount,String privAddress,EthereumAddress targetAddress) async {
    var bigAmount = BigInt.from(myAmount);
    var response = await submit("transfer",[targetAddress,bigAmount],privAddress);
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
