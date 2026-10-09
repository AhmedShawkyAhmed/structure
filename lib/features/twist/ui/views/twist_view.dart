import 'dart:async';

import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/core/resources/app_theme.dart';
import 'package:structure/core/shared/widgets/app_ui.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:twist_music_player/twist_music_player.dart';

class TwistView extends StatefulWidget {
  const TwistView({super.key});

  @override
  State<TwistView> createState() => _TwistViewState();
}

class _TwistViewState extends State<TwistView> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (locale != _locale) {
      _locale = locale;
      unawaited(TwistMusicPlayer.instance.laneController.reload());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: Text(localizations.twistFeatureTitle),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: TextButton.icon(
              onPressed: () => _changeLanguage(isArabic),
              icon: const Icon(Icons.language_rounded),
              label: Text(
                isArabic ? localizations.english : localizations.arabic,
              ),
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: EdgeInsets.only(
              bottom: TwistPlayerHost.bottomPaddingOf(context) + 24,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 2),
                child: _WelcomeCard(),
              ),
              TwistMusicSwimlane(
                style: TwistSwimlaneStyle.banner,
                backgroundColor: Colors.transparent,
                emptyBuilder: (context) => const _EmptyMusicState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(bool isArabic) {
    LocalizationHelper.changeLocal(isArabic ? Languages.en : Languages.ar);
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return AppHeroCard(
      title: l.musicHeroTitle,
      subtitle: l.musicHeroSubtitle,
      icon: Icons.headphones_rounded,
      footer: ExcludeSemantics(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final height in [
              12.0,
              24.0,
              18.0,
              38.0,
              48.0,
              28.0,
              42.0,
              20.0,
              34.0,
              48.0,
              28.0,
              16.0,
              38.0,
              24.0,
              12.0,
            ])
              Flexible(
                child: Container(
                  width: 8,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyMusicState extends StatelessWidget {
  const _EmptyMusicState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.line),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.headphones_rounded,
              color: AppTheme.violet,
              size: 42,
            ),
            const SizedBox(height: 14),
            Text(
              localizations.musicEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              localizations.musicEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppTheme.muted),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: TwistMusicPlayer.instance.laneController.reload,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(localizations.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
