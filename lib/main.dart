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
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF007AFF),
    brightness: brightness,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark
        ? const Color(0xFF050507)
        : const Color(0xFFF5F5F7),
    textTheme: Typography.material2021().black.apply(
      bodyColor: isDark ? const Color(0xFFF5F5F7) : const Color(0xFF1D1D1F),
      displayColor: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1D1D1F),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF007AFF),
        foregroundColor: Colors.white,
        disabledBackgroundColor: isDark
            ? const Color(0xFF2A2A2E)
            : const Color(0xFFE5E5EA),
        disabledForegroundColor: isDark
            ? const Color(0xFF8E8E93)
            : const Color(0xFF6E6E73),
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
                      color: colors.primaryText,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: colors.background,
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
                        letterSpacing: -.2,
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
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: colors.primaryText,
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AppLanguage>(
                value: value,
                isExpanded: true,
                dropdownColor: colors.menu,
                borderRadius: BorderRadius.circular(16),
                icon: Icon(
                  Icons.expand_more_rounded,
                  color: colors.primaryText,
                ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              copy.eyebrow,
              style: TextStyle(
                color: colors.secondaryText,
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
                fontSize: 76,
                height: .95,
                fontWeight: FontWeight.w800,
                letterSpacing: -3.8,
              ),
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Text(
                copy.subtitle,
                style: TextStyle(
                  color: colors.secondaryText,
                  fontSize: 21,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
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
  const _ProjectGrid({required this.projects, required this.copy});

  final List<ProjectShowcase> projects;
  final AppCopy copy;

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              copy.projectsHeading,
              style: TextStyle(
                color: colors.primaryText,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -.7,
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
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: project.url != null
                      ? const Color(0xFF34C759)
                      : colors.secondaryText,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                project.status,
                style: TextStyle(
                  color: colors.secondaryText,
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
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            project.category,
            style: TextStyle(
              color: colors.secondaryText,
              fontWeight: FontWeight.w700,
            ),
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
    );
  }
}

class _PageBackground extends StatelessWidget {
  const _PageBackground();

  @override
  Widget build(BuildContext context) {
    final colors = _AppleColors.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        gradient: RadialGradient(
          center: const Alignment(.7, -1),
          radius: 1.15,
          colors: [colors.glow, colors.background],
        ),
      ),
    );
  }
}

class _AppleColors {
  const _AppleColors({
    required this.background,
    required this.primaryText,
    required this.secondaryText,
    required this.bodyText,
    required this.card,
    required this.control,
    required this.menu,
    required this.border,
    required this.shadow,
    required this.glow,
  });

  final Color background;
  final Color primaryText;
  final Color secondaryText;
  final Color bodyText;
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
            background: Color(0xFF050507),
            primaryText: Color(0xFFF5F5F7),
            secondaryText: Color(0xFFB8B8BE),
            bodyText: Color(0xFFD1D1D6),
            card: Color(0xFF151518),
            control: Color(0xFF1D1D20),
            menu: Color(0xFF242428),
            border: Color(0xFF2A2A2E),
            shadow: Color(0x66000000),
            glow: Color(0x332E6BFF),
          )
        : const _AppleColors(
            background: Color(0xFFF5F5F7),
            primaryText: Color(0xFF1D1D1F),
            secondaryText: Color(0xFF6E6E73),
            bodyText: Color(0xFF424245),
            card: Color(0xFFFFFFFF),
            control: Color(0xFFFFFFFF),
            menu: Color(0xFFFFFFFF),
            border: Color(0xFFE3E3E8),
            shadow: Color(0x1A000000),
            glow: Color(0xFFEAF2FF),
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
