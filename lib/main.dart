import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CalculatorPage(),
  ));
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final remain = TextEditingController(text: '117');
  final tickets = TextEditingController(text: '3');
  final discard = List.generate(7, (_) => TextEditingController(text: '0'));
  final chosen = List.generate(7, (_) => TextEditingController(text: '0'));

  int get average {
    const prices = [1080, 540, 216, 90, 27, 27, 18];
    var lost = 0;
    var count = 0;
    for (var i = 0; i < 7; i++) {
      lost += (int.tryParse(discard[i].text) ?? 0) * prices[i];
      count += int.tryParse(chosen[i].text) ?? 0;
    }
    final total = (int.tryParse(remain.text) ?? 0) *
        (int.tryParse(tickets.text) ?? 0) * 300;
    return (total - lost * 10) ~/ (count == 0 ? 1 : count);
  }

  Widget field(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: (_) => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CameraPage()),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          field('Remaining', remain),
          field('Tickets per draw', tickets),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Average: $average diamonds',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          for (var i = 0; i < 7; i++)
            Row(
              children: [
                Expanded(child: field('Discard ${String.fromCharCode(65 + i)}', discard[i])),
                const SizedBox(width: 8),
                Expanded(child: field('Selected ${String.fromCharCode(65 + i)}', chosen[i])),
              ],
            ),
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  String? error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera available');
      final value = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);
      await value.initialize();
      if (mounted) setState(() => controller = value);
    } catch (exception) {
      if (mounted) setState(() => error = exception.toString());
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Camera OCR')),
      body: error != null
          ? Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Camera unavailable: $error')))
          : camera == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(camera),
                Center(
                  child: Container(
                    width: 260,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 20,
                  right: 20,
                  child: FilledButton.icon(
                    onPressed: () => camera.takePicture(),
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture'),
                  ),
                ),
              ],
            ),
    );
  }
}
