import 'package:flutter/material.dart';

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
