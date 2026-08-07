import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class VisionOcrService {
  static const _channel = MethodChannel('com.secl.hello_world_ios/vision');
  Future<List<String>> recognize(Uint8List jpegBytes) async {
    final result = await _channel.invokeMethod<List<dynamic>>(
      'recognizeDigits',
      Uint8List.fromList(jpegBytes),
    );
    return (result ?? const []).cast<String>();
  }

  Future<List<String>> pollLatestFrame() async {
    final frame = await _channel.invokeMethod<Uint8List>('readLatestFrame');
    if (frame == null || frame.isEmpty) return const [];
    return recognize(frame);
  }
}

void main() => runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: CalculatorPage()));

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final models = <String, List<int>>{
    '模型 1': [1080, 540, 216, 90, 27, 27, 18],
    '模型 2': [1080, 540, 216, 90, 27, 27, 18],
    '模型 3': [900, 450, 180, 75, 24, 24, 15],
    '模型 4': [800, 400, 160, 70, 21, 21, 14],
    '模型 5': [700, 350, 140, 60, 18, 18, 12],
    '模型 6': [600, 300, 120, 50, 15, 15, 10],
    '模型 7': [500, 250, 100, 45, 12, 12, 9],
    '模型 8': [400, 200, 80, 36, 10, 10, 8],
  };
  String selected = '模型 2';
  final remain = TextEditingController(text: '117');
  final tickets = TextEditingController(text: '3');
  final discard = List.generate(7, (i) => TextEditingController(text: i == 1 ? '2' : i == 2 ? '4' : i == 3 ? '10' : i == 4 ? '31' : i == 5 ? '30' : i == 6 ? '40' : '0'));
  final chosen = List.generate(7, (i) => TextEditingController(text: i == 6 ? '1' : '0'));
  Offset box = const Offset(80, 120);
  double size = 240;
  int get value { final p = models[selected]!; final r = int.tryParse(remain.text) ?? 0; final t = int.tryParse(tickets.text) ?? 0; final d = List.generate(7, (i) => (int.tryParse(discard[i].text) ?? 0) * p[i]).fold<int>(0, (a,b)=>a+b); final c = List.generate(7, (i) => int.tryParse(chosen[i].text) ?? 0).fold<int>(0,(a,b)=>a+b); return ((r*t*300)-d*10) ~/ (c == 0 ? 1 : c); }
  Color get valueColor { final threshold = selected == '模型 8' ? 5500 : 15500; final ratio = (value / threshold).clamp(0.0, 2.0); return Color.lerp(const Color(0xffb8f5c1), const Color(0xffe53935), ratio / 2)!; }
  void refresh() => setState(() {});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('实时奖励计算'), actions:[IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CameraOcrPage())), icon:const Icon(Icons.camera_alt))]), body: LayoutBuilder(builder: (context, c) { final wide = c.maxWidth > 700; return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [DropdownButtonFormField<String>(value: selected, decoration: const InputDecoration(labelText: '奖励模型'), items: models.keys.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(), onChanged:(v){if(v!=null){selected=v;refresh();}}), const SizedBox(height:12), _number('剩余数量', remain), _number('单抽券数', tickets), const SizedBox(height:12), Container(height: wide ? 300 : 240, decoration: BoxDecoration(color: Colors.black12,borderRadius: BorderRadius.circular(12)), child: Stack(children:[Positioned(left:box.dx,top:box.dy-80,child:GestureDetector(onPanUpdate:(d){setState(()=>box+=d.delta);},child:Container(width:size,height:size,decoration:BoxDecoration(border:Border.all(color:Colors.white,width:3),color:Colors.white10),child:const Center(child:Text('拖动框选区域',style:TextStyle(color:Colors.white))))))])), Slider(value:size,min:100,max:400,label:'识别框大小',onChanged:(v)=>setState(()=>size=v)), Card(color:valueColor,child:Padding(padding:const EdgeInsets.all(18),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('蓝框均值',style:TextStyle(fontSize:18,fontWeight:FontWeight.bold)),Text('$value 钻石',style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900))]))), const SizedBox(height:12), for(int i=0;i<7;i++) Row(children:[Expanded(child:_number('${String.fromCharCode(65+i)} 放弃',discard[i])),const SizedBox(width:8),Expanded(child:_number('${String.fromCharCode(65+i)} 选中',chosen[i]))]), ]); }));
  Widget _number(String label, TextEditingController c) => TextField(controller:c, keyboardType:TextInputType.number, decoration:InputDecoration(labelText:label), onChanged:(_)=>refresh());
}

class CameraOcrPage extends StatefulWidget { const CameraOcrPage({super.key}); @override State<CameraOcrPage> createState()=>_CameraOcrPageState(); }
class _CameraOcrPageState extends State<CameraOcrPage> {
  CameraController? controller; bool ready=false; bool busy=false; DateTime last=DateTime.fromMillisecondsSinceEpoch(0); String recognized='等待识别';
  @override void initState(){super.initState(); _start();}
  Future<void> _start() async { final cameras=await availableCameras(); if(cameras.isEmpty)return; controller=CameraController(cameras.first, ResolutionPreset.high, enableAudio:false); await controller!.initialize(); if(mounted)setState(()=>ready=true); }
  @override void dispose(){controller?.dispose(); super.dispose();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('相机实时识别')), body:!ready?const Center(child:CircularProgressIndicator()):Stack(fit:StackFit.expand,children:[CameraPreview(controller!), Center(child:Container(width:260,height:180,decoration:BoxDecoration(border:Border.all(color:Colors.white,width:3),color:Colors.transparent))), Positioned(top:24,left:20,right:20,child:ColoredBox(color:Colors.black54,child:Padding(padding:const EdgeInsets.all(10),child:Text(recognized,style:const TextStyle(color:Colors.white,fontSize:16))))), Positioned(bottom:24,left:20,right:20,child:FilledButton.icon(onPressed:busy?null:_sample,icon:busy?const SizedBox(width:18,height:18,child:CircularProgressIndicator()):const Icon(Icons.document_scanner),label:const Text('识别当前框')))]);
  Future<void> _sample() async { if(DateTime.now().difference(last).inMilliseconds<250||busy)return; last=DateTime.now(); setState(()=>busy=true); try { final file=await controller!.takePicture(); final source=img.decodeImage(await File(file.path).readAsBytes()); if(source==null)throw StateError('无法读取图像'); final w=(source.width*0.72).round(), h=(source.height*0.48).round(); final cropped=img.copyCrop(source,x:(source.width-w)~/2,y:(source.height-h)~/2,width:w,height:h); final bytes=Uint8List.fromList(img.encodeJpg(cropped,quality:88)); final values=await VisionOcrService().recognize(bytes); if(mounted)setState(()=>recognized=values.isEmpty?'未识别到数字':values.join(' · ')); } catch (e) { if(mounted)setState(()=>recognized='识别失败: $e'); } finally { if(mounted)setState(()=>busy=false); } }
}
