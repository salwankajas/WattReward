import 'package:ev/nav/reward.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

// void main() => runApp(QRCodeScannerApp());

class QRCodeScannerApp extends StatefulWidget{
  final Future<bool> Function(String) isValidFunction;
  final Function(String) navigator;

  QRCodeScannerApp({required this.isValidFunction,required this.navigator});

  @override
  _QRCodeScannerAppState createState() => _QRCodeScannerAppState();
}

class _QRCodeScannerAppState extends State<QRCodeScannerApp> {
  int count=0;
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<PermissionStatus> _getCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result;
    } else {
      return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return FutureBuilder<PermissionStatus>(
        future: _getCameraPermission(),
        builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
          if (snapshot.hasError) {
            return Text("something went wrong");
          }
          if (snapshot.hasData) {
            return Scaffold(
              body: SizedBox(
                    // flex: 5,
                    child: QRView(
                      key: _qrKey,
                      overlay: QrScannerOverlayShape(
                          borderColor: Colors.red,
                          borderRadius: 10,
                          borderLength: 30,
                          borderWidth: 10,
                          cutOutSize: scanArea),
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
            );
          } else {
            return Text("No Camera permission");
          }
        });
  }

//   bool isValidEthereumAddress(String data) {
//     var address = data.split(";")[0];
//   if (address.length == 42 && address.startsWith("0x")) {
//     return true;
//   }
//   return false;
// }

  void _onQRViewCreated(QRViewController controller){
      _controller = controller;
      _controller!.scannedDataStream.listen((scanData) async{
        if(count == 0 ){
          if(await widget.isValidFunction(scanData.code!)){
            // Navigator.pushReplacement(context,
            //           MaterialPageRoute(builder: (context) => Rewarding(data:scanData.code!)));
            widget.navigator(scanData.code!);         
            count++;
          }else{
            Fluttertoast.cancel();
            Fluttertoast.showToast(
              msg: "Invalid QR code",
              backgroundColor: Colors.grey,
              fontSize: 12,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.white
            );
            count = 0 ;
          }
        }
    });
  }
}
