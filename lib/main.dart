import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AwkwardSkyHomeApp());
}

class AwkwardSkyHomeApp extends StatelessWidget {
  const AwkwardSkyHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awkward Sky Projects',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE3B45B),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Trebuchet MS',
        scaffoldBackgroundColor: const Color(0xFF11151C),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFFE9EDF5),
          displayColor: const Color(0xFFFFF3D2),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<ProjectShowcase> _projects = [
    ProjectShowcase(
      name: 'ReactionSpeedLab',
      url: 'https://awkwardsky.github.io/ReactionSpeedLab/',
      status: 'Live',
      category: 'Interactive Web Lab',
      description:
          'A browser-based reaction speed test with multilingual controls, theme switching, and room for future monetization experiments.',
      accent: Color(0xFF87E36B),
      isLive: true,
    ),
    ProjectShowcase(
      name: 'Different Experiments',
      url: 'https://awkwardsky.github.io/',
      status: 'Planning',
      category: 'Project Index',
      description:
          'A home base for tools, demos, dashboards, small games, and other projects that should feel intentionally different from each other.',
      accent: Color(0xFFE38D6B),
      isLive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SelectionArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _Atmosphere()),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                      child: _TopBar(onOpenReactionLab: _openReactionLab),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 72, 24, 36),
                      child: _HeroSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 56),
                      child: _ProjectGrid(projects: _projects),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
                      child: _Footer(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _openReactionLab() async {
    await _openUrl('https://awkwardsky.github.io/ReactionSpeedLab/');
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onOpenReactionLab});

  final VoidCallback onOpenReactionLab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFE3B45B), Color(0xFF87E36B)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x553E2B10),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Color(0xFF11151C)),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'awkwardsky.github.io',
                style: TextStyle(
                  color: Color(0xFFFFF3D2),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .4,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onOpenReactionLab,
              icon: const Icon(Icons.open_in_new, size: 18),
              label: const Text('Open first project'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x1AFFF3D2),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0x33FFF3D2)),
              ),
              child: Text(
                'Project homepage',
                style: const TextStyle(
                  color: Color(0xFFE3B45B),
                  fontWeight: FontWeight.w700,
                  letterSpacing: .5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Awkward Sky Projects',
              style: TextStyle(
                fontFamily: 'Georgia',
                color: Color(0xFFFFF3D2),
                fontSize: 72,
                height: .95,
                fontWeight: FontWeight.w700,
                letterSpacing: -2.8,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: const Text(
                '這裡整理我發布在 GitHub Pages 的作品。第一個是 ReactionSpeedLab，之後的新專案也會加在這裡。',
                style: TextStyle(
                  color: Color(0xFFC6D0DF),
                  fontSize: 20,
                  height: 1.55,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({required this.projects});

  final List<ProjectShowcase> projects;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1040
                ? 3
                : constraints.maxWidth >= 700
                ? 2
                : 1;
            const spacing = 18.0;
            final cardWidth =
                (constraints.maxWidth - (spacing * (columns - 1))) / columns;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final entry in projects.indexed)
                  SizedBox(
                    width: cardWidth,
                    child: _AnimatedProjectCard(
                      delayIndex: entry.$1,
                      project: entry.$2,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedProjectCard extends StatelessWidget {
  const _AnimatedProjectCard({required this.delayIndex, required this.project});

  final int delayIndex;
  final ProjectShowcase project;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 520 + (delayIndex * 120)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 28 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _ProjectCard(project: project),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectShowcase project;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 330),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B2330),
            Color.alphaBlend(
              project.accent.withValues(alpha: .10),
              const Color(0xFF151A22),
            ),
          ],
        ),
        border: Border.all(color: project.accent.withValues(alpha: .32)),
        boxShadow: [
          BoxShadow(
            color: project.accent.withValues(alpha: .10),
            blurRadius: 34,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: project.accent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: project.accent.withValues(alpha: .65),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                project.status,
                style: TextStyle(
                  color: project.accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            project.name,
            style: const TextStyle(
              color: Color(0xFFFFF3D2),
              fontSize: 30,
              height: 1,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.category,
            style: const TextStyle(
              color: Color(0xFF98A6B9),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            project.description,
            style: const TextStyle(
              color: Color(0xFFD9E0EA),
              fontSize: 16,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          SelectableText(
            project.url,
            style: const TextStyle(
              color: Color(0xFF98A6B9),
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: project.isLive ? () => _openUrl(project.url) : null,
              icon: Icon(project.isLive ? Icons.open_in_new : Icons.lock_clock),
              label: Text(project.isLive ? 'Open project' : 'Coming soon'),
              style: FilledButton.styleFrom(
                backgroundColor: project.accent,
                foregroundColor: const Color(0xFF11151C),
                disabledBackgroundColor: const Color(0xFF2A313B),
                disabledForegroundColor: const Color(0xFF7D8794),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: .10)),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 22),
            child: Text(
              'Add a new project repo, deploy it with GitHub Pages, then add one more card here.',
              style: TextStyle(color: Color(0xFF98A6B9), height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

class _Atmosphere extends StatelessWidget {
  const _Atmosphere();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F141B), Color(0xFF14202B), Color(0xFF11151C)],
        ),
      ),
      child: CustomPaint(painter: _OrbitPainter()),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: .035)
      ..strokeWidth = 1;
    const gap = 56.0;

    for (var x = 0.0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glowPaint = Paint()
      ..shader =
          const RadialGradient(
            colors: [Color(0x55E3B45B), Color(0x00000000)],
          ).createShader(
            Rect.fromCircle(
              center: Offset(size.width * .82, size.height * .16),
              radius: size.shortestSide * .36,
            ),
          );
    canvas.drawCircle(
      Offset(size.width * .82, size.height * .16),
      size.shortestSide * .36,
      glowPaint,
    );

    final orbitPaint = Paint()
      ..color = const Color(0x33FFF3D2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * .72, size.height * .28),
        width: size.width * .58,
        height: size.height * .34,
      ),
      orbitPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProjectShowcase {
  const ProjectShowcase({
    required this.name,
    required this.url,
    required this.status,
    required this.category,
    required this.description,
    required this.accent,
    required this.isLive,
  });

  final String name;
  final String url;
  final String status;
  final String category;
  final String description;
  final Color accent;
  final bool isLive;
}

Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);
  final opened = await launchUrl(uri, webOnlyWindowName: '_blank');
  if (!opened) {
    throw StateError('Could not open $url');
  }
}
