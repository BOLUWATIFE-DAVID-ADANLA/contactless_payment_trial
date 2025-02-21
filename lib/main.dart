import 'package:contactless_payments_trial/services/nfc_communication_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Center(child: ElevatedButton(onPressed: () {}, child: Text(''))),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  NfcCommunicationService().scanCard();
                },
                child: Text('scan card nfc'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
