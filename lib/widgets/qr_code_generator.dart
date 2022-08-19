import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR {
  qrGenerator(String qrData) {
    return Center(
      child: QrImage(
        backgroundColor: Colors.black,
        data: qrData.toString(),
        version: QrVersions.auto,
        size: 200.0,
        eyeStyle:
            const QrEyeStyle(color: Colors.white, eyeShape: QrEyeShape.square),
        dataModuleStyle: const QrDataModuleStyle(color: Colors.white),
      ),
    );
  }

  qrScanner(String qrData) {
    return Center(
      child: QrImage(
        //backgroundColor: Colors.black,
        data: qrData.toString(),
        version: QrVersions.auto,
        size: 200.0,

        // eyeStyle: const QrEyeStyle(
        //     color: Colors.white, eyeShape: QrEyeShape.square),
        // dataModuleStyle: const QrDataModuleStyle(color: Colors.white),
      ),
    );
  }
}
