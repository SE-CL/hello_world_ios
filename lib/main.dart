import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: CalculatorPage()));

class CalculatorPage extends StatefulWidget { const CalculatorPage({super.key}); @override State<CalculatorPage> createState() => _CalculatorPageState(); }

class _CalculatorPageState extends State<CalculatorPage> {
  final remain = TextEditingController(text: '117');
  final tickets = TextEditingController(text: '3');
  final discard = List.generate(7, (_) => TextEditingController(text: '0'));
  final chosen = List.generate(7, (_) => TextEditingController(text: '0'));
  int get average { final d = List.generate(7, (i) => (int.tryParse(discard[i].text) ?? 0) * [1080,540,216,90,27,27,18][i]).fold(0, (a,b) => a+b); final c = List.generate(7, (i) => int.tryParse(chosen[i].text) ?? 0).fold(0, (a,b) => a+b); return (((int.tryParse(remain.text) ?? 0) * (int.tryParse(tickets.text) ?? 0) * 300) - d * 10) ~/ (c == 0 ? 1 : c); }
  Widget input(String label, TextEditingController c) => TextField(controller: c, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: label), onChanged: (_) => setState(() {}));
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('实时奖励计算'), actions: [IconButton(icon: const Icon(Icons.camera_alt), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraPage())))]), body: ListView(padding: const EdgeInsets.all(16), children: [input('剩余数量', remain), input('单抽券数', tickets), Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('蓝框均值: $average 钻石', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)))), for (var i = 0; i < 7; i++) Row(children: [Expanded(child: input('放弃 ${String.fromCharCode(65+i)}', discard[i])), const SizedBox(width: 8), Expanded(child: input('选中 ${String.fromCharCode(65+i)}', chosen[i]))])]);
}

class CameraPage extends StatefulWidget { const CameraPage({super.key}); @override State<CameraPage> createState() => _CameraPageState(); }
class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  @override void initState() { super.initState(); _init(); }
  Future<void> _init() async { final cameras = await availableCameras(); if (cameras.isEmpty) return; final c = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false); await c.initialize(); if (mounted) setState(() => controller = c); }
  @override void dispose() { controller?.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) { final c = controller; return Scaffold(appBar: AppBar(title: const Text('相机识别')), body: c == null ? const Center(child: CircularProgressIndicator()) : Stack(fit: StackFit.expand, children: [CameraPreview(c), Center(child: Container(width: 260, height: 180, decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3)))), Positioned(bottom: 24, left: 20, right: 20, child: FilledButton.icon(onPressed: () => c.takePicture(), icon: const Icon(Icons.camera), label: const Text('采样当前画面'))])); }
}
