import 'package:camera/camera.dart';
import 'package:document_scanner/base/widgets/base_scaffold.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  static String name = 'Camera';
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  Future<void>? _initializeControllerFuture;
  @override
  void initState() {
    getCameras();
    super.initState();
  }

  Future<void> getCameras() async {
    final cameras = await availableCameras();

    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      cameras.first,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return CameraPreview(_cameraController);
        } else {
          // Otherwise, display a loading indicator.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
