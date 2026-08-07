import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '我的第一个应用',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FC),
        useMaterial3: true,
        fontFamily: 'Avenir',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _started = false;

  void _startExploring() {
    setState(() => _started = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('欢迎来到你的第一个应用！'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width > 1080 ? (width - 1080) / 2 : 24.0;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              EdgeInsets.fromLTRB(horizontalPadding, 28, horizontalPadding, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7568FF), Color(0xFF4D9BFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x337568FF),
                            blurRadius: 18,
                            offset: Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: Colors.white, size: 25),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'HELLO WORLD',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: const Color(0xFF6C63FF),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.2,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF151F46), Color(0xFF293B78)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x29101A3A),
                        blurRadius: 28,
                        offset: Offset(0, 16)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -55,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '你好，世界！  ·  Hello World',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: const Color(0xFFB9C4FF),
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '我的第一个应用',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hello World',
                          style: TextStyle(
                            color: Color(0xFF9EA9E2),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          '从一个简单的 Hello World 开始，\n把每个好想法变成现实。',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFD5DAF7),
                                    height: 1.5,
                                  ),
                        ),
                        const SizedBox(height: 26),
                        FilledButton.icon(
                          onPressed: _startExploring,
                          icon: Icon(_started
                              ? Icons.check_rounded
                              : Icons.arrow_forward_rounded),
                          label: Text(_started ? '已准备好' : '开始探索'),
                          style: FilledButton.styleFrom(
                            foregroundColor: const Color(0xFF18234B),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        if (!kIsWeb &&
                            defaultTargetPlatform ==
                                TargetPlatform.android) ...[
                          const SizedBox(height: 12),
                          TextButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const AutomationPage(),
                              ),
                            ),
                            icon: const Icon(Icons.touch_app_rounded),
                            label: const Text('打开 Android 自动化'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                '应用特点',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF101A3A),
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 14),
              const _FeatureGrid(),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  'Built with Flutter  •  1.0.0',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: const Color(0xFF8D94AA)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const _features = [
    _FeatureData(Icons.phone_iphone_rounded, '一次开发', '同时支持 iOS 与 Android'),
    _FeatureData(Icons.bolt_rounded, '快速启动', '轻量、流畅、响应迅速'),
    _FeatureData(Icons.palette_outlined, '精美界面', '为你的想法留下好印象'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
                ? 2
                : 1;
        const gap = 14.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final feature in _features)
              SizedBox(
                width: cardWidth,
                child: _FeatureCard(
                  icon: feature.icon,
                  title: feature.title,
                  detail: feature.detail,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FeatureData {
  const _FeatureData(this.icon, this.title, this.detail);

  final IconData icon;
  final String title;
  final String detail;
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard(
      {required this.icon, required this.title, required this.detail});

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: const Color(0xFF6C63FF), size: 28),
              const SizedBox(height: 18),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: Color(0xFF101A3A))),
              const SizedBox(height: 6),
              Text(detail,
                  style:
                      const TextStyle(color: Color(0xFF737B92), height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}

class AutomationPage extends StatefulWidget {
  const AutomationPage({super.key});

  @override
  State<AutomationPage> createState() => _AutomationPageState();
}

class _AutomationPageState extends State<AutomationPage>
    with WidgetsBindingObserver {
  static const _channel = MethodChannel('com.secl.hello_world_ios/automation');

  var _overlayEnabled = false;
  var _serviceEnabled = false;
  var _running = false;
  final List<_AutomationPoint> _points = [
    const _AutomationPoint(x: 500, y: 500, rate: 1, priority: 5),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshStatus();
    }
  }

  Future<void> _refreshStatus() async {
    final result = await _channel.invokeMapMethod<String, dynamic>('getStatus');
    if (!mounted || result == null) return;
    setState(() {
      _serviceEnabled = result['serviceEnabled'] == true;
      _overlayEnabled = result['overlayEnabled'] == true;
      _running = result['running'] == true;
    });
  }

  Future<void> _saveConfiguration() {
    return _channel.invokeMethod<void>(
      'saveConfiguration',
      _points.map((point) => point.toMap()).toList(),
    );
  }

  Future<void> _setOverlayEnabled(bool enabled) async {
    await _channel.invokeMethod<void>('setOverlayEnabled', enabled);
    await _refreshStatus();
  }

  Future<void> _startOrStop() async {
    if (!_serviceEnabled) {
      await _channel.invokeMethod<void>('openAccessibilitySettings');
      return;
    }
    if (_running) {
      await _channel.invokeMethod<void>('stopAutoClick');
    } else {
      await _saveConfiguration();
      await _channel.invokeMethod<void>('startAutoClick');
    }
    await _refreshStatus();
  }

  void _updatePoint(int index, _AutomationPoint point) {
    setState(() => _points[index] = point);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Android 自动化')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('使用说明',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text(
                        '先在系统设置中手动启用无障碍服务。坐标使用屏幕宽高的千分比，旋转屏幕时会自动按当前尺寸换算。'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => _channel
                          .invokeMethod<void>('openAccessibilitySettings'),
                      icon: Icon(_serviceEnabled
                          ? Icons.check_circle_outline
                          : Icons.settings_accessibility),
                      label: Text(_serviceEnabled ? '无障碍服务已启用' : '前往启用无障碍服务'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              title: const Text('悬浮控制球'),
              subtitle: const Text('显示在其他应用上层，点击可开始或停止连点'),
              value: _overlayEnabled,
              onChanged: _serviceEnabled ? _setOverlayEnabled : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('连点位置（${_points.length}/10）',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                  tooltip: '添加位置',
                  onPressed: _points.length < 10
                      ? () => setState(() => _points.add(const _AutomationPoint(
                          x: 500, y: 500, rate: 1, priority: 5)))
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            for (var index = 0; index < _points.length; index++)
              _PointEditor(
                index: index,
                point: _points[index],
                canRemove: _points.length > 1,
                onChanged: (point) => _updatePoint(index, point),
                onRemove: () => setState(() => _points.removeAt(index)),
              ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _startOrStop,
              icon: Icon(_running
                  ? Icons.stop_circle_outlined
                  : Icons.play_circle_outline),
              label: Text(_running ? '停止连点' : '保存并开始连点'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointEditor extends StatelessWidget {
  const _PointEditor({
    required this.index,
    required this.point,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final int index;
  final _AutomationPoint point;
  final bool canRemove;
  final ValueChanged<_AutomationPoint> onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
        child: Column(
          children: [
            Row(
              children: [
                Text('位置 ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const Spacer(),
                IconButton(
                    onPressed: canRemove ? onRemove : null,
                    icon: const Icon(Icons.delete_outline)),
              ],
            ),
            _PointSlider(
              label: '横向位置',
              value: point.x,
              suffix: '‰',
              onChanged: (value) => onChanged(point.copyWith(x: value)),
            ),
            _PointSlider(
              label: '纵向位置',
              value: point.y,
              suffix: '‰',
              onChanged: (value) => onChanged(point.copyWith(y: value)),
            ),
            _PointSlider(
              label: '频率',
              value: point.rate,
              min: 1,
              max: 10,
              suffix: ' 次/秒',
              onChanged: (value) => onChanged(point.copyWith(rate: value)),
            ),
            _PointSlider(
              label: '优先级',
              value: point.priority,
              min: 1,
              max: 10,
              suffix: '',
              onChanged: (value) => onChanged(point.copyWith(priority: value)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointSlider extends StatelessWidget {
  const _PointSlider({
    required this.label,
    required this.value,
    required this.suffix,
    required this.onChanged,
    this.min = 0,
    this.max = 1000,
  });

  final String label;
  final int value;
  final String suffix;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [Text(label), const Spacer(), Text('$value$suffix')],
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

class _AutomationPoint {
  const _AutomationPoint(
      {required this.x,
      required this.y,
      required this.rate,
      required this.priority});

  final int x;
  final int y;
  final int rate;
  final int priority;

  _AutomationPoint copyWith({int? x, int? y, int? rate, int? priority}) {
    return _AutomationPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      rate: rate ?? this.rate,
      priority: priority ?? this.priority,
    );
  }

  Map<String, int> toMap() =>
      {'x': x, 'y': y, 'rate': rate, 'priority': priority};
}
