import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:structure/core/helpers/localization_helper.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';
import 'package:twist_music_player/twist_music_player.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 20,
        title: const _AppTitle(),
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
      body: Builder(
        builder: (context) {
          return ListView(
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
          );
        },
      ),
    );
  }

  Future<void> _changeLanguage(bool isArabic) async {
    LocalizationHelper.changeLocal(isArabic ? Languages.en : Languages.ar);
    await TwistMusicPlayer.instance.laneController.reload();
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset('assets/images/pngs/logo.png'),
        ),
        const SizedBox(width: 12),
        Text(
          'Structure',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF151A2D), Color(0xFF343B63)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.musicHeroTitle,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  localizations.musicHeroSubtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              color: Color(0xFF7C5CFC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),
        ],
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
          border: Border.all(color: const Color(0xFFE8EAF2)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.headphones_rounded,
              color: Color(0xFF7C5CFC),
              size: 42,
            ),
            const SizedBox(height: 14),
            Text(
              localizations.musicEmptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              localizations.musicEmptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF74788D)),
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
