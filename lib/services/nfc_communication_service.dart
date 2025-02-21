import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_emulator/nfc_emulator.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcCommunicationService {
  final NfcManager? instance = NfcManager.instance;

  Future<void> setUpNfc(String cardAid, String cardUid) async {
    try {
      NfcStatus currentDeviceNfcStatus = await NfcEmulator.nfcStatus;
      debugPrint('Device NFC status: $currentDeviceNfcStatus');

      if (currentDeviceNfcStatus == NfcStatus.enabled) {
        await NfcEmulator.startNfcEmulator(cardAid, cardUid);
        debugPrint('NFC emulation started successfully.');
      } else {
        debugPrint('NFC is not enabled on this device.');
        // Optionally handle the case where NFC is not enabled.
        // For example, you might want to show a dialog or a snackbar
      }
    } on PlatformException catch (e) {
      debugPrint('Platform exception during NFC setup: ${e.message}');
    } catch (e) {
      debugPrint('An error occurred during NFC setup: $e');
      // Handle other errors, such as invalid AID or UID.
    }
  }

  Future<void> scanCard() async {
    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        var uid = tag.data["mifare"]["identifier"];
        debugPrint("Card UID: $uid");
        NfcManager.instance.stopSession();
      },
    );
  }
}
