// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';

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

  Future<void> _getImageFromSource(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _measurements = null;
        _processing = true;
      });

      await _processPose();
    }
  }

  // Functions to handle specific image sources
  Future<void> _getImageFromCamera() async {
    await _getImageFromSource(ImageSource.camera);
  }

  Future<void> _getImageFromGallery() async {
    await _getImageFromSource(ImageSource.gallery);
  }

  // Show a modal bottom sheet with image source options
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
              onTap: () {
                Navigator.pop(context);
                _getImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
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

  double _getDistance(PoseLandmark first, PoseLandmark second) {
    return sqrt(pow(first.x - second.x, 2) + pow(first.y - second.y, 2));
  }

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
      });
      return;
    }

    final pose = poses.first;

    // Calculate relative measurements using pixel distances
    // Note: These are approximate and need calibration for real measurements
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
    };

    // Convert pixel distances to approximate centimeters
    // This needs calibration with a known reference object
    const pixelToCmRatio = 0.2; // This is an example ratio, needs calibration
    measurements = measurements.map((key, value) =>
        MapEntry(key, (value * pixelToCmRatio).roundToDouble()));

    setState(() {
      _measurements = measurements;
      _processing = false;
    });
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (_imageFile != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!),
              ),
              const SizedBox(height: 20),
            ],
            if (_processing)
              const CircularProgressIndicator()
            else if (_measurements != null)
              Padding(
                padding: const EdgeInsets.all(16),
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