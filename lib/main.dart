import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const AwkwardSkyHomeApp());
}

class AwkwardSkyHomeApp extends StatefulWidget {
  const AwkwardSkyHomeApp({super.key});

  @override
  State<AwkwardSkyHomeApp> createState() => _AwkwardSkyHomeAppState();
}

class _AwkwardSkyHomeAppState extends State<AwkwardSkyHomeApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  AppLanguage _language = AppLanguage.zhHant;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awkward Sky Projects',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: HomePage(
        language: _language,
        themeMode: _themeMode,
        onLanguageChanged: (language) => setState(() => _language = language),
        onToggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  const brandCyan = Color(0xFF00FFFF);
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: brandCyan,
        brightness: brightness,
      ).copyWith(
        primary: isDark ? brandCyan : const Color(0xFF007C89),
        surfaceTint: brandCyan,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF020B0E)
        : const Color(0xFFF4FBFC),
    textTheme: Typography.material2021().black.apply(
      bodyColor: isDark ? const Color(0xFFE9FEFF) : const Color(0xFF162124),
      displayColor: isDark ? const Color(0xFFF7FFFF) : const Color(0xFF162124),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: isDark ? brandCyan : const Color(0xFF007C89),
        foregroundColor: isDark ? const Color(0xFF001619) : Colors.white,
        disabledBackgroundColor: isDark
            ? const Color(0xFF102125)
            : const Color(0xFFDCEDEF),
        disabledForegroundColor: isDark
            ? const Color(0xFF678287)
            : const Color(0xFF64787C),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: const StadiumBorder(),
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onToggleTheme,
    super.key,
  });

  final AppLanguage language;
  final ThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final copy = AppCopy.of(language);
    final projects = ProjectShowcase.localized(copy);

    return Scaffold(
      body: SelectionArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _PageBackground()),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
                      child: _TopBar(
                        copy: copy,
                        language: language,
                        themeMode: themeMode,
                        onLanguageChanged: onLanguageChanged,
                        onToggleTheme: onToggleTheme,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 92, 22, 52),
                      child: _HeroSection(copy: copy),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 58),
                      child: _ProjectGrid(projects: projects, copy: copy),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 34),
                      child: _Footer(copy: copy),
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
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.copy,
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onToggleTheme,
  });

  final AppCopy copy;
  final AppLanguage language;
  final ThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 280,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: colors.accentGlow,
                            blurRadius: 22,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: colors.accentText,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        copy.siteName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.primaryText,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _TopBarControls(
                copy: copy,
                language: language,
                themeMode: themeMode,
                onLanguageChanged: onLanguageChanged,
                onToggleTheme: onToggleTheme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBarControls extends StatelessWidget {
  const _TopBarControls({
    required this.copy,
    required this.language,
    required this.themeMode,
    required this.onLanguageChanged,
    required this.onToggleTheme,
  });

  final AppCopy copy;
  final AppLanguage language;
  final ThemeMode themeMode;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        _ThemeIconButton(
          label: copy.themeToggleLabel,
          isDark: themeMode == ThemeMode.dark,
          onPressed: onToggleTheme,
        ),
        _LanguageSelect(
          label: copy.languageLabel,
          value: language,
          onChanged: onLanguageChanged,
        ),
      ],
    );
  }
}

class _ThemeIconButton extends StatelessWidget {
  const _ThemeIconButton({
    required this.label,
    required this.isDark,
    required this.onPressed,
  });

  final String label;
  final bool isDark;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: colors.control,
              shape: BoxShape.circle,
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: colors.accent,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelect extends StatelessWidget {
  const _LanguageSelect({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return SizedBox(
      width: 210,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                color: colors.secondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: .8,
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colors.control,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: value,
                isExpanded: true,
                dropdownColor: colors.menu,
                borderRadius: BorderRadius.circular(8),
                icon: Icon(Icons.expand_more_rounded, color: colors.accent),
                style: TextStyle(
                  color: colors.primaryText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                items: [
                  for (final language in AppLanguage.values)
                    DropdownMenuItem(
                      value: language,
                      child: Text(language.label),
                    ),
                ],
                onChanged: (language) {
                  if (language != null) {
                    onChanged(language);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.copy});

  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SizedBox(
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    copy.eyebrow,
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    copy.title,
                    style: TextStyle(
                      color: colors.primaryText,
                      fontSize: isNarrow ? 54 : 76,
                      height: isNarrow ? 1.04 : .95,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Text(
                      copy.subtitle,
                      style: TextStyle(
                        color: colors.secondaryText,
                        fontSize: isNarrow ? 18 : 21,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ProjectGrid extends StatelessWidget {
  const _ProjectGrid({required this.projects, required this.copy});

  final List<ProjectShowcase> projects;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                copy.projectsHeading,
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 760 ? 2 : 1;
                  const spacing = 18.0;
                  final cardWidth =
                      (constraints.maxWidth - (spacing * (columns - 1))) /
                      columns;

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
                            copy: copy,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedProjectCard extends StatelessWidget {
  const _AnimatedProjectCard({
    required this.delayIndex,
    required this.project,
    required this.copy,
  });

  final int delayIndex;
  final ProjectShowcase project;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + (delayIndex * 90)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: _ProjectCard(project: project, copy: copy),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.copy});

  final ProjectShowcase project;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 286),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 26,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: project.url != null ? colors.accent : colors.muted,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                project.status,
                style: TextStyle(
                  color: project.url != null ? colors.accent : colors.muted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: .3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            project.name,
            style: TextStyle(
              color: colors.primaryText,
              fontSize: 30,
              height: 1,
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.category,
            style: TextStyle(color: colors.accent, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Text(
            project.description,
            style: TextStyle(
              color: colors.bodyText,
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          if (project.displayUrl != null) ...[
            SelectableText(
              project.displayUrl!,
              style: TextStyle(
                color: colors.secondaryText,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: project.url == null
                  ? null
                  : () => _openUrl(project.url!),
              icon: Icon(
                project.url == null
                    ? Icons.schedule_rounded
                    : project.actionIcon,
                size: 18,
              ),
              label: Text(
                project.url == null
                    ? copy.comingSoon
                    : project.actionLabel ?? copy.openProject,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.copy});

  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                copy.footer,
                style: TextStyle(
                  color: colors.secondaryText,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageBackground extends StatefulWidget {
  const _PageBackground();

  @override
  State<_PageBackground> createState() => _PageBackgroundState();
}

class _PageBackgroundState extends State<_PageBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _TechGeometryBackgroundPainter(
              colors: colors,
              isDark: isDark,
              progress: _controller.value,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _TechGeometryBackgroundPainter extends CustomPainter {
  const _TechGeometryBackgroundPainter({
    required this.colors,
    required this.isDark,
    required this.progress,
  });

  final _AppleColors colors;
  final bool isDark;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBase(canvas, size);
    _paintGrid(canvas, size);
    _paintTriangulatedField(canvas, size);
    _paintConstellation(canvas, size);
    _paintOrbitArcs(canvas, size);
    _paintWaveTrace(canvas, size);
  }

  void _paintBase(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [Color(0xFF010709), Color(0xFF031B20), Color(0xFF020B0E)]
            : const [Color(0xFFF4FBFC), Color(0xFFE8FBFD), Color(0xFFF8FFFF)],
      ).createShader(rect);

    canvas.drawRect(rect, backgroundPaint);

    final diagonalPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          colors.accent.withValues(alpha: isDark ? .2 : .1),
          Colors.transparent,
          colors.background.withValues(alpha: .18),
        ],
        stops: const [0, .5, 1],
      ).createShader(rect);
    canvas.drawRect(rect, diagonalPaint);
  }

  void _paintGrid(Canvas canvas, Size size) {
    final step = size.width < 600 ? 34.0 : 48.0;
    final phase = progress * step;
    final gridPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .07 : .09)
      ..strokeWidth = 1;

    for (double x = -step + (phase % step); x < size.width + step; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (
      double y = -step + ((phase * .55) % step);
      y < size.height + step;
      y += step
    ) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final axisPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .1 : .12)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(size.width * .09, 0),
      Offset(size.width * .09, size.height),
      axisPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * .58),
      Offset(size.width, size.height * .58),
      axisPaint,
    );
  }

  void _paintTriangulatedField(Canvas canvas, Size size) {
    final points = <Offset>[
      Offset(size.width * .42, size.height * .05),
      Offset(size.width * .64, size.height * .08),
      Offset(size.width * .88, size.height * .03),
      Offset(size.width * .55, size.height * .28),
      Offset(size.width * .78, size.height * .31),
      Offset(size.width * 1.02, size.height * .24),
      Offset(size.width * .58, size.height * .52),
      Offset(size.width * .86, size.height * .5),
      Offset(size.width * 1.05, size.height * .62),
    ];

    final drift = Offset(
      math.sin(progress * math.pi * 2) * 10,
      math.cos(progress * math.pi * 2) * 8,
    );
    final shifted = points.map((point) => point + drift).toList();
    final linePaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .16 : .12)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .035 : .045)
      ..style = PaintingStyle.fill;

    void triangle(int a, int b, int c) {
      final path = Path()
        ..moveTo(shifted[a].dx, shifted[a].dy)
        ..lineTo(shifted[b].dx, shifted[b].dy)
        ..lineTo(shifted[c].dx, shifted[c].dy)
        ..close();
      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, linePaint);
    }

    triangle(0, 1, 3);
    triangle(1, 3, 4);
    triangle(1, 2, 4);
    triangle(2, 4, 5);
    triangle(3, 4, 6);
    triangle(4, 6, 7);
    triangle(4, 5, 7);
    triangle(5, 7, 8);
  }

  void _paintConstellation(Canvas canvas, Size size) {
    final nodes = <Offset>[
      Offset(size.width * .12, size.height * .18),
      Offset(size.width * .24, size.height * .08),
      Offset(size.width * .34, size.height * .23),
      Offset(size.width * .18, size.height * .42),
      Offset(size.width * .32, size.height * .5),
      Offset(size.width * .47, size.height * .37),
      Offset(size.width * .61, size.height * .58),
      Offset(size.width * .75, size.height * .44),
      Offset(size.width * .91, size.height * .67),
      Offset(size.width * .7, size.height * .82),
      Offset(size.width * .46, size.height * .77),
    ];

    final animatedNodes = [
      for (final entry in nodes.indexed)
        entry.$2 +
            Offset(
              math.sin((progress * math.pi * 2) + entry.$1) * 5,
              math.cos((progress * math.pi * 2) + entry.$1 * .7) * 5,
            ),
    ];

    final connectionPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .16 : .14)
      ..strokeWidth = 1;
    final nodePaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .7 : .62)
      ..style = PaintingStyle.fill;
    final nodeBorderPaint = Paint()
      ..color = colors.background.withValues(alpha: .86)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const pairs = [
      (0, 1),
      (0, 3),
      (1, 2),
      (2, 5),
      (3, 4),
      (4, 5),
      (5, 6),
      (6, 7),
      (6, 10),
      (7, 8),
      (8, 9),
      (9, 10),
    ];

    for (final pair in pairs) {
      canvas.drawLine(
        animatedNodes[pair.$1],
        animatedNodes[pair.$2],
        connectionPaint,
      );
    }

    for (final node in animatedNodes) {
      final rect = Rect.fromCenter(center: node, width: 6, height: 6);
      canvas.save();
      canvas.translate(node.dx, node.dy);
      canvas.rotate(math.pi / 4);
      canvas.translate(-node.dx, -node.dy);
      canvas.drawRect(rect, nodePaint);
      canvas.drawRect(rect, nodeBorderPaint);
      canvas.restore();
    }
  }

  void _paintOrbitArcs(Canvas canvas, Size size) {
    final center = Offset(size.width * .78, size.height * .2);
    final arcPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .28 : .18)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final faintArcPaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .1 : .08)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 4; i += 1) {
      final radius = 78.0 + (i * 36);
      final rect = Rect.fromCircle(center: center, radius: radius);
      final start = progress * math.pi * 2 + (i * math.pi / 5);
      canvas.drawArc(rect, start, math.pi * .65, false, arcPaint);
      canvas.drawArc(
        rect,
        start + math.pi,
        math.pi * .28,
        false,
        faintArcPaint,
      );
    }

    _drawHexagon(
      canvas,
      center + Offset(size.width * .08, size.height * .08),
      size.width < 600 ? 34 : 54,
      colors.accent.withValues(alpha: isDark ? .22 : .14),
    );
  }

  void _paintWaveTrace(Canvas canvas, Size size) {
    final path = Path();
    final baseline = size.height * .68;
    final amplitude = size.height * .035;
    final frequency = size.width < 600 ? .018 : .012;

    for (double x = -20; x <= size.width + 20; x += 10) {
      final y =
          baseline +
          math.sin((x * frequency) + progress * math.pi * 2) * amplitude +
          math.sin((x * frequency * 2.7) - progress * math.pi * 3) *
              amplitude *
              .28;
      if (x == -20) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final wavePaint = Paint()
      ..color = colors.accent.withValues(alpha: isDark ? .18 : .13)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, wavePaint);

    final mirrorPath = Path();
    for (double x = -20; x <= size.width + 20; x += 10) {
      final y =
          baseline +
          42 +
          math.cos((x * frequency * 1.4) - progress * math.pi * 2) *
              amplitude *
              .72;
      if (x == -20) {
        mirrorPath.moveTo(x, y);
      } else {
        mirrorPath.lineTo(x, y);
      }
    }
    canvas.drawPath(
      mirrorPath,
      Paint()
        ..color = const Color(0xFF6AA6FF).withValues(alpha: isDark ? .13 : .08)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Color color) {
    final path = Path();
    for (var i = 0; i < 6; i += 1) {
      final angle = (math.pi / 3 * i) + (progress * math.pi * 2);
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_TechGeometryBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark;
  }
}

class _AppleColors {
  const _AppleColors({
    required this.background,
    required this.accent,
    required this.accentText,
    required this.accentGlow,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
    required this.muted,
    required this.card,
    required this.control,
    required this.menu,
    required this.border,
    required this.shadow,
    required this.glow,
  });

  final Color background;
  final Color accent;
  final Color accentText;
  final Color accentGlow;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;
  final Color muted;
  final Color card;
  final Color control;
  final Color menu;
  final Color border;
  final Color shadow;
  final Color glow;

  static _AppleColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return isDark
        ? const _AppleColors(
            background: Color(0xFF020B0E),
            accent: Color(0xFF00FFFF),
            accentText: Color(0xFF001619),
            accentGlow: Color(0x6600FFFF),
            primaryText: Color(0xFFF2FFFF),
            secondaryText: Color(0xFF9FC1C6),
            bodyText: Color(0xFFC6DEE1),
            muted: Color(0xFF66868B),
            card: Color(0xFF071418),
            control: Color(0xFF0A1B20),
            menu: Color(0xFF0D252A),
            border: Color(0x4D00FFFF),
            shadow: Color(0x99000000),
            glow: Color(0x3300FFFF),
          )
        : const _AppleColors(
            background: Color(0xFFF4FBFC),
            accent: Color(0xFF007C89),
            accentText: Color(0xFFFFFFFF),
            accentGlow: Color(0x3300AAB6),
            primaryText: Color(0xFF162124),
            secondaryText: Color(0xFF5B7277),
            bodyText: Color(0xFF344A4F),
            muted: Color(0xFF82979B),
            card: Color(0xFFFFFFFF),
            control: Color(0xFFFFFFFF),
            menu: Color(0xFFFFFFFF),
            border: Color(0x33007C89),
            shadow: Color(0x1600191D),
            glow: Color(0xFFE5FBFC),
          );
  }
}

enum AppLanguage {
  zhHant('中文'),
  en('English'),
  ja('日本語');

  const AppLanguage(this.label);

  final String label;
}

class AppCopy {
  const AppCopy({
    required this.siteName,
    required this.languageLabel,
    required this.themeToggleLabel,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.projectsHeading,
    required this.openProject,
    required this.watchShowcase,
    required this.comingSoon,
    required this.footer,
    required this.liveStatus,
    required this.showcaseStatus,
    required this.futureStatus,
    required this.reactionCategory,
    required this.reactionDescription,
    required this.dashboardCategory,
    required this.dashboardDescription,
    required this.kageruneCategory,
    required this.kageruneDescription,
    required this.tamatamaCategory,
    required this.tamatamaDescription,
    required this.futureName,
    required this.futureCategory,
    required this.futureDescription,
  });

  final String siteName;
  final String languageLabel;
  final String themeToggleLabel;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String projectsHeading;
  final String openProject;
  final String watchShowcase;
  final String comingSoon;
  final String footer;
  final String liveStatus;
  final String showcaseStatus;
  final String futureStatus;
  final String reactionCategory;
  final String reactionDescription;
  final String dashboardCategory;
  final String dashboardDescription;
  final String kageruneCategory;
  final String kageruneDescription;
  final String tamatamaCategory;
  final String tamatamaDescription;
  final String futureName;
  final String futureCategory;
  final String futureDescription;

  static AppCopy of(AppLanguage language) {
    return switch (language) {
      AppLanguage.zhHant => const AppCopy(
        siteName: 'awkwardsky.github.io',
        languageLabel: '語言切換',
        themeToggleLabel: '切換主題',
        eyebrow: 'Project homepage',
        title: 'Awkward Sky Projects',
        subtitle: '這裡整理我發布在 GitHub Pages 的作品，也收錄不公開原始碼的影片展示。',
        projectsHeading: 'Projects',
        openProject: '開啟專案',
        watchShowcase: '觀看影片',
        comingSoon: '即將加入',
        footer: '公開工具會連到 GitHub Pages；私人專案只放展示影片或截圖，不公開原始碼。',
        liveStatus: '已上線',
        showcaseStatus: '展示影片',
        futureStatus: '規劃中',
        reactionCategory: '互動網頁工具',
        reactionDescription: '測試點擊反應速度的小工具，支援多語系、主題切換，以及後續放置廣告版位的空間。',
        dashboardCategory: '資料儀表板',
        dashboardDescription: '展示資料卡片、趨勢圖與營運指標的前端儀表板實驗，用來整理互動式 dashboard 介面。',
        kageruneCategory: '私人 Flutter 遊戲',
        kageruneDescription:
            '以戰鬥演出與操作手感為主的 Flutter 遊戲專案。此處只提供錄製展示，原始碼與完整可玩版本維持 private。',
        tamatamaCategory: '私人 Flutter 遊戲',
        tamatamaDescription:
            '以角色互動與遊戲流程展示為主的 Flutter 遊戲專案。此處只提供錄製展示，原始碼與完整可玩版本維持 private。',
        futureName: '更多專案',
        futureCategory: '專案索引',
        futureDescription: '新的工具、實驗或作品上線後，會以獨立卡片整理在這裡。',
      ),
      AppLanguage.en => const AppCopy(
        siteName: 'awkwardsky.github.io',
        languageLabel: 'Language',
        themeToggleLabel: 'Toggle theme',
        eyebrow: 'Project homepage',
        title: 'Awkward Sky Projects',
        subtitle:
            'A simple index for public GitHub Pages projects and video showcases for private work.',
        projectsHeading: 'Projects',
        openProject: 'Open project',
        watchShowcase: 'Watch video',
        comingSoon: 'Coming soon',
        footer:
            'Public tools link to GitHub Pages. Private projects use video or screenshots without publishing source code.',
        liveStatus: 'Live',
        showcaseStatus: 'Video showcase',
        futureStatus: 'Planning',
        reactionCategory: 'Interactive web tool',
        reactionDescription:
            'A reaction speed test for the browser, with multilingual controls, theme switching, and space for future ad placements.',
        dashboardCategory: 'Data dashboard',
        dashboardDescription:
            'A front-end dashboard experiment for data cards, trend charts, and operational metrics.',
        kageruneCategory: 'Private Flutter game',
        kageruneDescription:
            'A Flutter game project focused on combat presentation and game feel. This page provides a recorded showcase only; source code and the full playable build stay private.',
        tamatamaCategory: 'Private Flutter game',
        tamatamaDescription:
            'A Flutter game project focused on character interaction and gameplay flow. This page provides a recorded showcase only; source code and the full playable build stay private.',
        futureName: 'More Projects',
        futureCategory: 'Project index',
        futureDescription:
            'New tools, experiments, and demos will be added here as separate project cards.',
      ),
      AppLanguage.ja => const AppCopy(
        siteName: 'awkwardsky.github.io',
        languageLabel: '言語切替',
        themeToggleLabel: 'テーマ切替',
        eyebrow: 'Project homepage',
        title: 'Awkward Sky Projects',
        subtitle: 'GitHub Pages の公開プロジェクトと、非公開プロジェクトの動画展示をまとめるページです。',
        projectsHeading: 'Projects',
        openProject: 'プロジェクトを開く',
        watchShowcase: '動画を見る',
        comingSoon: '準備中',
        footer: '公開ツールは GitHub Pages にリンクし、非公開プロジェクトは動画やスクリーンショットのみ掲載します。',
        liveStatus: '公開中',
        showcaseStatus: '動画展示',
        futureStatus: '計画中',
        reactionCategory: 'インタラクティブ Web ツール',
        reactionDescription: 'ブラウザで反応速度を測定できるツールです。多言語、テーマ切替、今後の広告枠に対応しています。',
        dashboardCategory: 'データダッシュボード',
        dashboardDescription:
            'データカード、トレンドチャート、運用指標を表示するフロントエンド dashboard 実験です。',
        kageruneCategory: '非公開 Flutter ゲーム',
        kageruneDescription:
            '戦闘演出と操作感に重点を置いた Flutter ゲームプロジェクトです。ここでは録画展示のみを公開し、ソースコードと完全版は private のままにします。',
        tamatamaCategory: '非公開 Flutter ゲーム',
        tamatamaDescription:
            'キャラクターのインタラクションとゲーム進行を中心にした Flutter ゲームプロジェクトです。ここでは録画展示のみを公開し、ソースコードと完全版は private のままにします。',
        futureName: 'More Projects',
        futureCategory: 'プロジェクト一覧',
        futureDescription: '新しいツール、実験、デモは個別のカードとしてここに追加します。',
      ),
    };
  }
}

class ProjectShowcase {
  const ProjectShowcase({
    required this.name,
    required this.status,
    required this.category,
    required this.description,
    this.url,
    this.displayUrl,
    this.actionLabel,
    this.actionIcon = Icons.open_in_new_rounded,
  });

  final String name;
  final String status;
  final String category;
  final String description;
  final String? url;
  final String? displayUrl;
  final String? actionLabel;
  final IconData actionIcon;

  static List<ProjectShowcase> localized(AppCopy copy) {
    return [
      ProjectShowcase(
        name: 'ReactionSpeedLab',
        url: 'https://awkwardsky.github.io/ReactionSpeedLab/',
        displayUrl: 'https://awkwardsky.github.io/ReactionSpeedLab/',
        status: copy.liveStatus,
        category: copy.reactionCategory,
        description: copy.reactionDescription,
      ),
      ProjectShowcase(
        name: 'DashboardLab',
        url: 'https://awkwardsky.github.io/DashboardLab/',
        displayUrl: 'https://awkwardsky.github.io/DashboardLab/',
        status: copy.liveStatus,
        category: copy.dashboardCategory,
        description: copy.dashboardDescription,
      ),
      ProjectShowcase(
        name: 'Kagerune Color',
        url: 'showcases/kagerune_combat_showcase_1080p.mp4',
        actionLabel: copy.watchShowcase,
        actionIcon: Icons.play_circle_fill_rounded,
        status: copy.showcaseStatus,
        category: copy.kageruneCategory,
        description: copy.kageruneDescription,
      ),
      ProjectShowcase(
        name: 'Tamatama',
        url: 'showcases/tamatama_showcase_1080p.mp4',
        actionLabel: copy.watchShowcase,
        actionIcon: Icons.play_circle_fill_rounded,
        status: copy.showcaseStatus,
        category: copy.tamatamaCategory,
        description: copy.tamatamaDescription,
      ),
      ProjectShowcase(
        name: copy.futureName,
        status: copy.futureStatus,
        category: copy.futureCategory,
        description: copy.futureDescription,
      ),
    ];
  }
}

Future<void> _openUrl(String url) async {
  final uri = Uri.base.resolve(url);
  final opened = await launchUrl(uri, webOnlyWindowName: '_blank');
  if (!opened) {
    throw StateError('Could not open $url');
  }
}
