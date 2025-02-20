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

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _measurements = null;
        _processing = true;
      });
      
      await _processPose();
    }
  }

  double _getDistance(PoseLandmark first, PoseLandmark second) {
    return sqrt(
      pow(first.x - second.x, 2) + pow(first.y - second.y, 2)
    );
  }

  Future<void> _processPose() async {
    if (_imageFile == null) return;

    final inputImage = InputImage.fromFile(_imageFile!);
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    if (poses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No pose detected. Please try again.')),
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
      ) * 1.1, // Estimated chest width
      'waist_width': _getDistance(
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.rightHip]!,
      ) * 1.2, // Estimated waist width
      'hip_width': _getDistance(
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.rightHip]!,
      ) * 1.3, // Estimated hip width
      'inseam': _getDistance(
        pose.landmarks[PoseLandmarkType.leftHip]!,
        pose.landmarks[PoseLandmarkType.leftAnkle]!,
      ),
    };

    // Convert pixel distances to approximate centimeters
    // This needs calibration with a known reference object
    const pixelToCmRatio = 0.2; // This is an example ratio, needs calibration
    measurements = measurements.map((key, value) => 
      MapEntry(key, (value * pixelToCmRatio).roundToDouble())
    );

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
        title: Text('Body Measurements'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_imageFile != null) ...[
              Image.file(_imageFile!),
              SizedBox(height: 20),
            ],
            if (_processing)
              CircularProgressIndicator()
            else if (_measurements != null)
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: _measurements!.entries.map((entry) {
                    return Card(
                      child: ListTile(
                        title: Text(entry.key.replaceAll('_', ' ').toUpperCase()),
                        trailing: Text('${entry.value.toStringAsFixed(1)} cm'),
                      ),
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Take Photo'),
            ),
          ],
        ),
      ),
    );
  }
}