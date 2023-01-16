import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:thesis/constants.dart';
import 'package:thesis/widgets/function_button.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String qrCodeData = "";
  bool alignmentCenter = true;
  List<String> information = [
    "Nome",
    "Data di Nascita",
    "Gruppo Sanguigno",
    "Contatto ICE1",
    "Contatto ICE2",
    "Patologia",
    "Patologia",
    "Allergie",
    "Informazioni"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("QR Code Scanner"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        (qrCodeData != "")
            ? (qrCodeData != "-1")
                ? _createCard()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/scan_qr_error.jpg"),
                  )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/scan_qr.jpg"),
              ),
        Text("Esegui la scansione di un codice QR:"),
        FunctionButton(_scanQRCode, Icon(Icons.qr_code_scanner), "Scan"),
      ],
    );
  }

  Widget _createCard() {
    List<String> patientList = qrCodeData.split("\n");
    if (patientList[0] != datiSalvavita && patientList[0] != greenPass) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("assets/images/scan_qr_error.jpg"),
      );
    }
    return Column(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: patientList[0] == datiSalvavita
                        ? List.generate(patientList.length, (index) {
                            if (index == 1 || index == 4 || index == 6) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        patientList[index],
                                      ))
                                ],
                              );
                            }
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  patientList[index],
                                  style: TextStyle(
                                      fontWeight: index == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ));
                          })
                        : List.generate(patientList.length - 1, (index) {
                            if (index == 1 || index == 2) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(patientList[index]))
                                ],
                              );
                            }
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  patientList[index],
                                  style: TextStyle(
                                      fontWeight: index == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ));
                          }))),
          ),
        ),
      ],
    );
  }

  _scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCodeData = qrCode;
      });
    } on PlatformException {
      qrCodeData = 'Failed to get platform version.';
    }
  }
}
