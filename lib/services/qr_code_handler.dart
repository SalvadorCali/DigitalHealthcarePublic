import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:universal_html/html.dart' as html;

class QRCodeHandler {
  QrImage generateQRCode(String data) {
    return QrImage(
      data: data,
      version: QrVersions.auto,
      size: 250.0,
    );
  }

  openQRCode(String data) async {
    if (kIsWeb) {
      await openQRCodeWeb(data);
    } else {
      String path = await _createImage(data);
      if (path != "Error") {
        await OpenFile.open(path);
      }
    }
  }

  saveQRCodeToGallery(String data) async {
    if (kIsWeb) {
      await downloadQRCodeWeb(data);
    } else {
      String path = await _createImage(data);
      if (await Permission.storage.request().isGranted) {
        await ImageGallerySaver.saveFile(path);
        Fluttertoast.showToast(msg: "Downloaded!");
      } else {
        Fluttertoast.showToast(msg: "Permission not granted!");
      }
    }
  }

  openQRCodeWeb(String data) async {
    await _createImageWeb(data);
  }

  downloadQRCodeWeb(String data) async {
    await _downloadImageWeb(data);
  }

  Future<String> _createImage(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode,
        emptyColor: const Color(0xffffffff),
        gapless: false,
      );

      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      String path = '$tempPath/$ts.png';

      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      await _writeToFile(picData, path);
      return path;
    } else {
      return "Error";
    }
  }

  _createImageWeb(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode,
        emptyColor: const Color(0xffffffff),
        gapless: false,
      );
      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);

      final blob = html.Blob([picData], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, "_blank");
      html.Url.revokeObjectUrl(url);
    } else {
      return "Error";
    }
  }

  _downloadImageWeb(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode,
        emptyColor: const Color(0xffffffff),
        gapless: false,
      );
      final picData =
          await painter.toImageData(2048, format: ImageByteFormat.png);

      final blob = html.Blob([picData], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '$ts.png';
      html.document.body.children.add(anchor);
      anchor.click();
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      return "Error";
    }
  }

  Future<void> _writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
