import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Saves a rendered share-card image to a temp file and opens the native share
/// sheet (which surfaces Instagram, WhatsApp, TikTok, X, Facebook, etc.).
class ShareService {
  ShareService();

  Future<File> _writeTempImage(Uint8List bytes) async {
    final Directory dir = await getTemporaryDirectory();
    final String path =
        '${dir.path}/dream_ai_${DateTime.now().millisecondsSinceEpoch}.png';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// Shares a PNG [bytes] image plus [text]. Returns true if the user completed
  /// a share action (best-effort; some platforms report dismissed).
  Future<bool> shareImage({
    required Uint8List bytes,
    required String text,
    String? subject,
  }) async {
    try {
      final File file = await _writeTempImage(bytes);
      final ShareResult result = await Share.shareXFiles(
        <XFile>[XFile(file.path, mimeType: 'image/png')],
        text: text,
        subject: subject,
      );
      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('shareImage failed: $e');
      return false;
    }
  }

  /// Shares plain text (e.g. a referral invite link).
  Future<bool> shareText(String text, {String? subject}) async {
    try {
      final ShareResult result = await Share.share(text, subject: subject);
      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('shareText failed: $e');
      return false;
    }
  }
}
