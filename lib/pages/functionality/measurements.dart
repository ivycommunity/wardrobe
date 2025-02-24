// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

/// A screen that enables users to capture or select an image
/// and extract body measurements using pose detection.
class BodyMeasurementScreen extends StatefulWidget {
  const BodyMeasurementScreen({super.key});

  @override
  _BodyMeasurementScreenState createState() => _BodyMeasurementScreenState();
}

class _BodyMeasurementScreenState extends State<BodyMeasurementScreen> {
  final poseDetector = PoseDetector(options: PoseDetectorOptions());
  File? _imageFile;
  Map<String, double>? _measurements;
  bool _processing = false;
  bool _showGuide = true;

  /// Picks an image from the specified source (camera or gallery) and processes it.
  /// @param source - The source from which to pick the image (camera or gallery).
  Future<void> _getImageFromSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _measurements = null;
        _processing = true;
        _showGuide = false;
      });

      await _processPose();
    }
  }

  /// Picks an image from the camera and processes it.
  /// Picks an image from the camera after a 3-second countdown.
  Future<void> _getImageFromCamera() async {
    await _getImageFromSource(ImageSource.camera);
  }

  /// Picks an image from the gallery and processes it.
  Future<void> _getImageFromGallery() async {
    await _getImageFromSource(ImageSource.gallery);
  }

  // Shows a modal bottom sheet with options to pick an image from the camera or gallery.
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              subtitle: const Text('Stand with your full body visible'),
              onTap: () {
                Navigator.pop(context);
                _getImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              subtitle: const Text('Select a full body photo'),
              onTap: () {
                Navigator.pop(context);
                _getImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Calculates the Euclidean distance between two pose landmarks.
  /// This is useful for estimating measurements such as shoulder width, waist width, etc.
  /// @param first - The first pose landmark.
  /// @param second - The second pose landmark.
  /// @returns The distance between the two landmarks in pixels.
  double _getDistance(PoseLandmark first, PoseLandmark second) {
    return sqrt(pow(first.x - second.x, 2) + pow(first.y - second.y, 2));
  }

  /// Processes the selected image to detect the pose and calculate measurements.
  Future<void> _processPose() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    if (poses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No pose detected. Please try again.')),
      );
      setState(() {
        _processing = false;
        _showGuide = true;
      });
      return;
    }

    final pose = poses.first;

    // Calculate relative measurements using pixel distances
    // These are approximations and require calibration for real-world measurements
    Map<String, double> measurements = {
      'shoulder_width': _getDistance(
        pose.landmarks[PoseLandmarkType.leftShoulder]!,
        pose.landmarks[PoseLandmarkType.rightShoulder]!,
      ),
      'chest_width': _getDistance(
            pose.landmarks[PoseLandmarkType.leftShoulder]!,
            pose.landmarks[PoseLandmarkType.rightShoulder]!,
          ) *
          1.1, // Estimated chest width
      'waist_width': _getDistance(
            pose.landmarks[PoseLandmarkType.leftHip]!,
            pose.landmarks[PoseLandmarkType.rightHip]!,
          ) *
          1.2, // Estimated waist width
      'hip_width': _getDistance(
            pose.landmarks[PoseLandmarkType.leftHip]!,
            pose.landmarks[PoseLandmarkType.rightHip]!,
          ) *
          1.3, // Estimated hip width
      'inseam': _getDistance(
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
      ),
      'height': _getDistance(
            pose.landmarks[PoseLandmarkType.nose]!,
            pose.landmarks[PoseLandmarkType.leftAnkle]!,
          ) *
          1.05, // Approximate full height
    };

    // Convert pixel distances to approximate centimeters
    // This requires calibration with a known reference object
    const pixelToCmRatio = 0.2; // Example ratio, requires calibration
    measurements = measurements.map((key, value) =>
        MapEntry(key, (value * pixelToCmRatio).roundToDouble()));

    setState(() {
      _measurements = measurements;
      _processing = false;
    });
  }

  // Builds the guide widget that shows proper posture examples for accurate measurements.
  Widget _buildPostureGuide() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          const Text(
            'For Accurate Measurements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SVG illustration of proper posture
              Container(
                width: 120,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomPaint(
                  painter: PoseIllustrationPainter(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGuideStep(
                      '1',
                      'Stand straight facing the camera',
                      'Feet shoulder-width apart',
                    ),
                    _buildGuideStep(
                      '2',
                      'Arms slightly away from body',
                      'Palms facing forward',
                    ),
                    _buildGuideStep(
                      '3',
                      'Ensure entire body is visible',
                      'From head to feet',
                    ),
                    _buildGuideStep(
                      '4',
                      'Wear fitting clothes',
                      'For most accurate measurements',
                    ),
                    _buildGuideStep(
                      '5',
                      'Good lighting',
                      'Avoid shadows and backlighting',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds a single step in the posture guide.
  // @param number - The step number.
  // @param title - The title of the step.
  // @param subtitle - The subtitle of the step.
  // @returns A widget representing a single guide step.
  Widget _buildGuideStep(String number, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Measurements'),
        actions: [
          IconButton(
            icon: Icon(_showGuide ? Icons.visibility_off : Icons.help_outline),
            onPressed: () {
              setState(() {
                _showGuide = !_showGuide;
              });
            },
            tooltip: _showGuide ? 'Hide guide' : 'Show guide',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'For accurate measurements, please ensure your full body from head to toe is visible in the photo.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            if (_showGuide) _buildPostureGuide(),
            if (_imageFile != null) ...[
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!),
              ),
            ],
            if (_processing)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('Analyzing pose...'),
                  ],
                ),
              )
            else if (_measurements != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: _measurements!.entries.map((entry) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title:
                            Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                        trailing: Text('${entry.value.toStringAsFixed(1)} cm'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _showImageSourceOptions,
              icon: const Icon(Icons.add_a_photo),
              label: const Text('Select Image', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to draw the pose illustration.
class PoseIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade800
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.blue.shade200
      ..style = PaintingStyle.fill;

    final double w = size.width;
    final double h = size.height;

    // Draw head
    final headRadius = w * 0.15;
    canvas.drawCircle(Offset(w / 2, h * 0.1), headRadius, fillPaint);
    canvas.drawCircle(Offset(w / 2, h * 0.1), headRadius, paint);

    // Draw body
    final Path bodyPath = Path()
      ..moveTo(w / 2, h * 0.1 + headRadius) // neck
      ..lineTo(w * 0.3, h * 0.25) // left shoulder
      ..lineTo(w * 0.2, h * 0.45) // left hand
      ..lineTo(w * 0.3, h * 0.25) // back to shoulder
      ..lineTo(w / 2, h * 0.5) // waist
      ..lineTo(w * 0.7, h * 0.25) // right shoulder
      ..lineTo(w * 0.8, h * 0.45) // right hand
      ..lineTo(w * 0.7, h * 0.25) // back to right shoulder
      ..close();

    canvas.drawPath(bodyPath, fillPaint);
    canvas.drawPath(bodyPath, paint);

    // Draw legs
    final leftLegPath = Path()
      ..moveTo(w / 2, h * 0.5) // waist
      ..lineTo(w * 0.35, h * 0.75) // left knee
      ..lineTo(w * 0.3, h * 0.95); // left foot

    final rightLegPath = Path()
      ..moveTo(w / 2, h * 0.5) // waist
      ..lineTo(w * 0.65, h * 0.75) // right knee
      ..lineTo(w * 0.7, h * 0.95); // right foot

    canvas.drawPath(leftLegPath, paint);
    canvas.drawPath(rightLegPath, paint);

    // Draw feet
    final leftFootPath = Path()
      ..moveTo(w * 0.3, h * 0.95)
      ..lineTo(w * 0.15, h * 0.95);

    final rightFootPath = Path()
      ..moveTo(w * 0.7, h * 0.95)
      ..lineTo(w * 0.85, h * 0.95);

    canvas.drawPath(leftFootPath, paint);
    canvas.drawPath(rightFootPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
