import 'package:contactless_payments_trial/services/nfc_communication_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NfctransactionScreens());
  }
}

class NfctransactionScreens extends StatefulWidget {
  const NfctransactionScreens({super.key});

  @override
  State<NfctransactionScreens> createState() => _NfctransactionScreensState();
}

class _NfctransactionScreensState extends State<NfctransactionScreens> {
  String nfcData = 'tap to read nfc ';

  final TextEditingController amountController = TextEditingController();
  final TextEditingController senderController = TextEditingController();
  final TextEditingController receiverController = TextEditingController();

  writeNfc() {
    try {
      NfcCommunicationService().writeTransactionData(
        amountController.text,
        receiverController.text,
        senderController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction written to NFC successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to write NFC: $e")));
    }
  }

  readNfc() async {
    try {
      String? transactData =
          await NfcCommunicationService().readTransactionData();
      if (transactData != null) {
        setState(() {
          nfcData = transactData;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Transaction read by NFC successfully!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("no data found ")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to write NFC: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NFC Wallet Transfer")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Amount"),
            ),
            TextField(
              controller: senderController,
              decoration: InputDecoration(labelText: "Sender ID"),
            ),
            TextField(
              controller: receiverController,
              decoration: InputDecoration(labelText: "Receiver ID"),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    writeNfc();
                  },
                  child: Text("Write NFC"),
                ),
                ElevatedButton(
                  onPressed: () {
                    readNfc();
                  },
                  child: Text("Read NFC"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("NFC Data: $nfcData"),
          ],
        ),
      ),
    );
  }
}
