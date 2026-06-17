import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/router/app_routes.dart';
import '../../core/router/route_args.dart';
import '../../core/theme/app_gradients.dart';
import '../../data/models/analysis_type.dart';
import '../../shared/widgets/gradient_background.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key, required this.args});

  final ScanArgs args;

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  String? _secondImagePath;

  bool get _isFriendship =>
      widget.args.type == AnalysisType.friendshipCompatibility;

  bool get _isHand => widget.args.type.scanKind == ScanKind.hand;

  bool get _ready =>
      _imagePath != null && (!_isFriendship || _secondImagePath != null);

  Future<void> _pick(ImageSource source, {required bool second}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 90,
        preferredCameraDevice:
            _isHand ? CameraDevice.rear : CameraDevice.front,
      );
      if (file == null) return;
      setState(() {
        if (second) {
          _secondImagePath = file.path;
        } else {
          _imagePath = file.path;
        }
      });
    } catch (e) {
      if (mounted) context.showSnack('Could not open the image picker.');
    }
  }

  void _analyze() {
    context.pushReplacement(
      AppRoutes.analyzing,
      extra: AnalyzingArgs(
        type: widget.args.type,
        imagePath: _imagePath,
        secondImagePath: _secondImagePath,
        countsAgainstQuota: !widget.args.alreadyUnlocked,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_isHand ? 'Palm Scan' : l10n.scanTitle)),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  _isHand
                      ? 'Take a clear photo of your open palm. The scan runs on your device.'
                      : l10n.scanSubtitle,
                  style: context.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                _PhotoSlot(
                  label: _isFriendship ? 'You' : (_isHand ? 'Your palm' : null),
                  placeholderIcon:
                      _isHand ? Icons.front_hand : Icons.face_retouching_natural,
                  imagePath: _imagePath,
                  onCamera: () => _pick(ImageSource.camera, second: false),
                  onGallery: () => _pick(ImageSource.gallery, second: false),
                ),
                if (_isFriendship) ...<Widget>[
                  const SizedBox(height: 16),
                  _PhotoSlot(
                    label: 'Friend',
                    imagePath: _secondImagePath,
                    onCamera: () => _pick(ImageSource.camera, second: true),
                    onGallery: () => _pick(ImageSource.gallery, second: true),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _ready ? _analyze : null,
                  icon: const Icon(Icons.auto_awesome),
                  label: Text(l10n.scanAnalyze),
                ),
                const SizedBox(height: 12),
                Text(
                  'Photos are scanned on your device and are never uploaded. '
                  '${AppConstants.shortDisclaimer}',
                  style: context.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoSlot extends StatelessWidget {
  const _PhotoSlot({
    required this.imagePath,
    required this.onCamera,
    required this.onGallery,
    this.label,
    this.placeholderIcon = Icons.face_retouching_natural,
  });

  final String? imagePath;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final String? label;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label!, style: context.textTheme.titleSmall),
          ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              gradient: imagePath == null ? AppGradients.dusk : null,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.antiAlias,
            child: imagePath == null
                ? Center(
                    child: Icon(placeholderIcon,
                        size: 72, color: Colors.white70),
                  )
                : Image.file(File(imagePath!), fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            Expanded(
              child: FilledButton.tonalIcon(
                onPressed: onCamera,
                icon: const Icon(Icons.camera_alt_rounded),
                label: Text(l10n.scanTakePhoto),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onGallery,
                icon: const Icon(Icons.photo_library_rounded),
                label: Text(l10n.scanUploadPhoto),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
