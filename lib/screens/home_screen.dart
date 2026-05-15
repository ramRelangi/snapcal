import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../.env.dart';
import 'result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _controller;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() => isProcessing = true);
    final XFile file = await _controller!.takePicture();
    final result = await _analyzeFoodWithGemini(File(file.path));
    if (mounted) {
      setState(() => isProcessing = false);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result, image: File(file.path))));
    }
  }

  Future<Map<String, dynamic>> _analyzeFoodWithGemini(File image) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiApiKey);
    final prompt = '''
You are an expert Indian nutritionist specializing in Hyderabad/Telugu food.
Analyze this plate. Reply ONLY in this exact JSON:
{"items":["item1","item2"],"total_cal":680,"protein":25,"carbs":90,"fat":28,"tip":"Short friendly tip"}
    ''';
    final imagePart = await image.readAsBytes();
    final content = [Content.multi([TextPart(prompt), DataPart('image/jpeg', imagePart)])];
    final response = await model.generateContent(content);
    final text = response.text ?? '{}';
    return {"raw": text};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SnapCal 🍛', style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.orange),
      body: Column(
        children: [
          Expanded(child: _controller != null && _controller!.value.isInitialized ? CameraPreview(_controller!) : const Center(child: CircularProgressIndicator())),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.photo_library, size: 40), onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? file = await picker.pickImage(source: ImageSource.gallery);
                  if (file != null) {
                    setState(() => isProcessing = true);
                    final result = await _analyzeFoodWithGemini(File(file.path));
                    setState(() => isProcessing = false);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(result: result, image: File(file.path))));
                  }
                }),
                GestureDetector(
                  onTap: isProcessing ? null : _takePicture,
                  child: Container(
                    height: 80, width: 80,
                    decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 20)]),
                    child: isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.camera_alt, size: 40, color: Colors.white),
                  ),
                ),
                const Icon(Icons.info_outline, size: 40, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}