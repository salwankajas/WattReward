import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  const QRImage(this.controller, {super.key});

  final String controller;

  @override
  Widget build(BuildContext context) {
    print(controller);
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("QR Code"),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: QrImageView(
            data: controller,
            size: 220,
            // You can include embeddedImageStyle Property if you 
            //wanna embed an image from your Asset folder
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(
                100,
                100,
              ),
            ),
          ),
        ),
     );
   }
}