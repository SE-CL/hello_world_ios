import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('实时奖励计算'), actions:[IconButton(onPressed:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CameraPage())), icon:const Icon(Icons.camera_alt))]), body: LayoutBuilder(builder: (context, c) { final wide = c.maxWidth > 700; return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [DropdownButtonFormField<String>(value: selected, decoration: const InputDecoration(labelText: '奖励模型'), items: models.keys.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(), onChanged:(v){if(v!=null){selected=v;refresh();}}), const SizedBox(height:12), _number('剩余数量', remain), _number('单抽券数', tickets), const SizedBox(height:12), Container(height: wide ? 300 : 240, decoration: BoxDecoration(color: Colors.black12,borderRadius:BorderRadius.circular(12)), child: Stack(children:[Positioned(left:box.dx,top:box.dy-80,child:GestureDetector(onPanUpdate:(d){setState(()=>box+=d.delta);},child:Container(width:size,height:size,decoration:BoxDecoration(border:Border.all(color:Colors.white,width:3)),child:const Center(child:Text('拖动框选区域')))))])), Slider(value:size,min:100,max:400,onChanged:(v)=>setState(()=>size=v)), Card(color:valueColor,child:Padding(padding:const EdgeInsets.all(18),child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[const Text('蓝框均值'),Text('$value 钻石',style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900))]))), for(int i=0;i<7;i++) Row(children:[Expanded(child:_number('${String.fromCharCode(65+i)} 放弃',discard[i])),const SizedBox(width:8),Expanded(child:_number('${String.fromCharCode(65+i)} 选中',chosen[i]))]), ]); }));
  Widget _number(String label, TextEditingController c) => TextField(controller:c, keyboardType:TextInputType.number, decoration:InputDecoration(labelText:label), onChanged:(_)=>refresh());
}

class CameraPage extends StatefulWidget { const CameraPage({super.key}); @override State<CameraPage> createState()=>_CameraPageState(); }
class _CameraPageState extends State<CameraPage> { CameraController? controller; bool ready=false; @override void initState(){super.initState();_init();} Future<void> _init() async { final list=await availableCameras(); if(list.isEmpty)return; controller=CameraController(list.first,ResolutionPreset.high,enableAudio:false); await controller!.initialize(); if(mounted)setState(()=>ready=true); } @override void dispose(){controller?.dispose();super.dispose();} @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('相机识别')),body:!ready?const Center(child:CircularProgressIndicator()):Stack(fit:StackFit.expand,children:[CameraPreview(controller!),Center(child:Container(width:260,height:180,decoration:BoxDecoration(border:Border.all(color:Colors.white,width:3)))),Positioned(bottom:24,left:20,right:20,child:FilledButton.icon(onPressed:()=>controller!.takePicture(),icon:const Icon(Icons.camera),label:const Text('采样当前画面')))]); }
