import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../models/face_features.dart';

/// Runs Google ML Kit face detection **entirely on-device**. No image or
/// landmark data ever leaves the phone. The output is reduced to a tiny,
/// non-biometric [FaceFeatures] summary used only to seed fun results.
class FaceDetectionService {
  FaceDetectionService();

  FaceDetector? _detector;

  FaceDetector get _instance => _detector ??= FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true, // smiling / eyes-open probabilities
          enableLandmarks: true, // eyes, nose, mouth, ears, cheeks
          enableContours: false,
          enableTracking: false,
          performanceMode: FaceDetectorMode.accurate,
          minFaceSize: 0.15,
        ),
      );

  /// Returns the largest detected face as [FaceFeatures], or
  /// [FaceFeatures.none] if no face is found / detection fails.
  Future<FaceFeatures> analyzeFile(String imagePath) async {
    try {
      final InputImage input = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await _instance.processImage(input);
      if (faces.isEmpty) return const FaceFeatures.none();

      // Choose the most prominent face (largest bounding box).
      faces.sort((Face a, Face b) =>
          (b.boundingBox.width * b.boundingBox.height)
              .compareTo(a.boundingBox.width * a.boundingBox.height));
      return _toFeatures(faces.first);
    } catch (e, st) {
      debugPrint('FaceDetectionService error: $e\n$st');
      return const FaceFeatures.none();
    }
  }

  FaceFeatures _toFeatures(Face face) {
    final int landmarkCount =
        face.landmarks.values.where((FaceLandmark? l) => l != null).length;

    return FaceFeatures(
      faceFound: true,
      smilingProbability: face.smilingProbability ?? 0.5,
      leftEyeOpen: face.leftEyeOpenProbability ?? 0.5,
      rightEyeOpen: face.rightEyeOpenProbability ?? 0.5,
      headAngleX: face.headEulerAngleX ?? 0,
      headAngleY: face.headEulerAngleY ?? 0,
      headAngleZ: face.headEulerAngleZ ?? 0,
      faceWidth: face.boundingBox.width,
      faceHeight: face.boundingBox.height,
      landmarkCount: landmarkCount,
      symmetry: _symmetryHint(face),
    );
  }

  /// Derives a rough 0–1 "balance" hint from the horizontal placement of the
  /// eyes relative to the nose. Purely for entertainment flavor — not a
  /// scientific symmetry measurement.
  double _symmetryHint(Face face) {
    final FaceLandmark? leftEye = face.landmarks[FaceLandmarkType.leftEye];
    final FaceLandmark? rightEye = face.landmarks[FaceLandmarkType.rightEye];
    final FaceLandmark? nose = face.landmarks[FaceLandmarkType.noseBase];
    if (leftEye == null || rightEye == null || nose == null) {
      // Fall back to head roll: less tilt -> higher hint.
      final double roll = (face.headEulerAngleZ ?? 0).abs();
      return (1 - (roll / 45)).clamp(0.3, 1.0);
    }
    final double leftDist = (nose.position.x - leftEye.position.x).abs();
    final double rightDist = (rightEye.position.x - nose.position.x).abs();
    final double maxDist = math.max(leftDist, rightDist);
    if (maxDist == 0) return 0.7;
    final double ratio = math.min(leftDist, rightDist) / maxDist;
    return ratio.clamp(0.0, 1.0);
  }

  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
  }
}
