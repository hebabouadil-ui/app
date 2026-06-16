/// A compact, privacy-safe summary of an on-device face detection pass.
///
/// IMPORTANT: this never leaves the device and is only used to seed
/// entertainment results. It contains no biometric template and no identity.
class FaceFeatures {
  const FaceFeatures({
    required this.faceFound,
    this.smilingProbability = 0.5,
    this.leftEyeOpen = 0.5,
    this.rightEyeOpen = 0.5,
    this.headAngleX = 0,
    this.headAngleY = 0,
    this.headAngleZ = 0,
    this.faceWidth = 0,
    this.faceHeight = 0,
    this.landmarkCount = 0,
    this.symmetry = 0.5,
  });

  /// Fallback used when no face is detected or detection is unavailable, so the
  /// app can still produce a (clearly random, for-fun) result.
  const FaceFeatures.none() : this(faceFound: false);

  final bool faceFound;
  final double smilingProbability; // 0–1
  final double leftEyeOpen; // 0–1
  final double rightEyeOpen; // 0–1
  final double headAngleX; // pitch, degrees
  final double headAngleY; // yaw, degrees
  final double headAngleZ; // roll, degrees
  final double faceWidth; // px
  final double faceHeight; // px
  final int landmarkCount;
  final double symmetry; // 0–1 derived hint

  double get aspectRatio => faceHeight == 0 ? 1 : faceWidth / faceHeight;

  /// A stable string used to seed the result generator. Bucketed so tiny
  /// pixel differences between two photos of the same person tend to land on
  /// the same seed (results feel consistent), while different people differ.
  String get seedSignature {
    final int smile = (smilingProbability * 10).round();
    final int eyes = ((leftEyeOpen + rightEyeOpen) * 5).round();
    final int ratio = (aspectRatio * 10).round();
    final int sym = (symmetry * 10).round();
    final int tilt = (headAngleZ.abs() / 5).round();
    return 'f$smile-e$eyes-r$ratio-s$sym-t$tilt-l$landmarkCount';
  }
}
