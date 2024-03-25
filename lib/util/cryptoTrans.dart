import 'package:flutter/services.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class CryptoTrans {
  late Web3Client ethClient;
  String? entit;
  CryptoTrans(String? entity) {
    this.entit = entity;
    Client httpClient = Client();
    ethClient =
        Web3Client("https://polygon-mumbai.g.alchemy.com/v2/yGX6D3Chr52l2FIkF5YQ3THPPMVaWECk", httpClient);
  }
  Stream<FilterEvent>? event;
  late EthereumAddress publicAddress;

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi/abi.json");
    String contractAddress = "0x263266c8b94e921f34e093df09B52A89B432a55a";
    final contract = DeployedContract(ContractAbi.fromJson(abi, "EVCoin"),
        EthereumAddress.fromHex(contractAddress));
    if (event == null) {
      final auctionEvent = contract.event('Transfer');
      String to = "0x000000000000000000000000" + publicAddress.toString().substring(2);
      if(entit != null){
        FilterOptions options = FilterOptions(
        address: contract.address,
        topics: [
          [bytesToHex(auctionEvent.signature, padToEvenLength: true, include0x: true)],
          [to],
          []
        ],
      );
      }else{
      FilterOptions options = FilterOptions(
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
    final result = await ethClient.sendTransaction(key,transaction ,chainId:80001);
    return result;
  }

}
