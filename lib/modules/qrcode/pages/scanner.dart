import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with WidgetsBindingObserver {
  CameraDescription? _camera;
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    availableCameras().then((value) {
      for (var cl in value) {
        if (cl.lensDirection == CameraLensDirection.back) {
          _camera = cl;
          break;
        }
      }
      if (_camera == null) {
        return;
      }
      _cameraController =
          CameraController(_camera!, ResolutionPreset.high, enableAudio: false);
      _cameraController!.initialize().then((value) {
        if (!mounted) {
          return;
        }
      });
    });
  }

  void _startCameraStreaming() {
    if (_cameraController == null) {
      return;
    }
    _cameraController!.startImageStream((image) {
      if (!mounted) {
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modules_qrcode_scan),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_album_outlined),
            onPressed: () {
              _onClickImagePick();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _camera == null ? Container() : Container(),
          ),
          ElevatedButton(
            onPressed: () => {},
            child:
                Text(AppLocalizations.of(context)!.modules_qrcode_image_pick),
          ),
        ],
      ),
    );
  }

  void _onClickImagePick() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print(image.path);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}

class _ScannerResult extends StatelessWidget {
  const _ScannerResult({
    Key? key,
    required this.result,
  }) : super(key: key);
  final String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.modules_qrcode_scan),
      ),
      body: Center(
        child: Text(result),
      ),
    );
  }
}
