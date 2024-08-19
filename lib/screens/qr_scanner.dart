import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fytness_system/services/reservation_service.dart';
import 'package:provider/provider.dart';
import 'package:fytness_system/providers/user_provider.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey _qrKey = GlobalKey();
  QRViewController? _qrController;
  //final ReservationService _reservationService = ReservationService(baseUrl: 'https://192.168.1.79:7083/api');
  final ReservationService _reservationService = ReservationService(baseUrl: 'https://10.0.2.2:7083/api');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    }
    _qrController?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          QRView(
            key: _qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        ],
      ),
    );
  }

  void _simulateQRScan(String code) async {
    final sessionId = int.tryParse(code);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (sessionId != null && userProvider.user != null) {
      try {
        await _reservationService.confirmReservation(sessionId, userProvider.user!.jmbg);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation confirmed successfully'),
          ),
        );


        Navigator.pushReplacementNamed(context, 'reservations/');

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm reservation: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code or user not found'),
        ),
      );
    }



  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      _simulateQRScan(scanData.code ?? '');
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}
