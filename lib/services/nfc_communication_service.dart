import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ndef/ndef.dart' as ndef;

class NfcCommunicationService {
  final NfcManager? instance = NfcManager.instance;
  Future<bool> isNfcEnabled() async {
    return NfcManager.instance.isAvailable();
  }

  void nfcEnabledChecker() async {
    bool isNfcEnabledFOThisDevice = await isNfcEnabled();

    if (isNfcEnabledFOThisDevice) {
      debugPrint('nfc communication enabled here');
    } else {
      debugPrint('nfc is not enabled on this device ');
    }
  }

  Future accertainifNfcEnabled() async {
    return FlutterNfcKit.nfcAvailability;
  }

  Future writeTransactionData(
    String amount,
    String receiver,
    String senderId,
  ) async {
    var timeStamp = DateTime.now().toIso8601String();
    var data =
        '{"amount: "$amount" , "to": "$receiver" , "from": "$senderId", "at": "$timeStamp"}';
    debugPrint(data);
    var transactonData = jsonEncode(data);
    try {
      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 20));
      if (tag.ndefAvailable == true) {
        await FlutterNfcKit.writeNDEFRecords([
          ndef.TextRecord(text: transactonData),
        ]);

        await FlutterNfcKit.finish();
      }
    } catch (e) {
      debugPrint("❌ Error writing NFC: $e");
    }
  }

  Future<String?> readTransactionData() async {
    try {
      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));

      if (tag.ndefAvailable == true) {
        var records = await FlutterNfcKit.readNDEFRecords();

        if (records.isNotEmpty) {
          var transactionData =
              records.first.payload; // Assuming the first record contains JSON
          debugPrint("✅ Received Transaction: $transactionData");

          try {
            var parsedData = jsonDecode(transactionData as String);
            return parsedData.toString();
          } catch (e) {
            debugPrint("⚠️ Error decoding JSON: $e");
            return null;
          }
        } else {
          debugPrint("⚠️ No NDEF records found.");
          return null;
        }
      } else {
        debugPrint("⚠️ No NDEF data found.");
        return null;
      }
    } catch (e) {
      debugPrint("❌ NFC Error: $e");
      return null;
    }
  }
}
