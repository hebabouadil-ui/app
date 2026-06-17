import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../core/utils/seeded_random.dart';

/// Produces a stable, privacy-safe signature from a photo (e.g. a palm) so the
/// reading feels consistent for the same image but differs between photos.
/// The image is never uploaded — only sampled locally to seed a fun result.
class ImageScanService {
  Future<String> scanSignature(String path) async {
    try {
      final Uint8List bytes = await File(path).readAsBytes();
      if (bytes.isEmpty) return 'scan-empty';
      // Sample ~1024 bytes evenly across the file for a stable fingerprint.
      int hash = 0x811C9DC5;
      final int step = (bytes.length / 1024).ceil().clamp(1, bytes.length);
      for (int i = 0; i < bytes.length; i += step) {
        hash ^= bytes[i];
        hash = (hash * 0x01000193) & 0xFFFFFFFF;
      }
      return 'scan-${bytes.length % 4096}-$hash';
    } catch (e) {
      debugPrint('ImageScanService.scanSignature failed: $e');
      return 'scan-fallback';
    }
  }

  /// Exposed for tests / reuse.
  static int hashBytes(Uint8List bytes) => SeededRandom.fnv1a32(
        String.fromCharCodes(bytes.take(256)),
      );
}
