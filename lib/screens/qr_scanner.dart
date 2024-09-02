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
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;
  final ReservationService _reservationService = ReservationService(
    baseUrl: 'https://172.20.10.2:7083/api',
  );

  bool _isProcessing = false;

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
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
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

  Future<void> _simulateQRScan(String code) async {
    if (!mounted || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final sessionId = int.tryParse(code);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (sessionId != null && userProvider.user != null) {
      try {
        await _reservationService.confirmReservation(sessionId, userProvider.user!.jmbg);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation confirmed successfully'),
          ),
        );

        Navigator.pushReplacementNamed(context, 'reservations/');

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to confirm reservation: $e')),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid QR code or user not found'),
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        _qrController?.pauseCamera();
        await _simulateQRScan(scanData.code!);
        _qrController?.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}
