import 'package:flutter/material.dart';
import 'package:twist_music_player/twist_music_player.dart';

import '../../resources/app_theme.dart';

/// Keeps forms readable on tablets and clear of the shared music player.
class AppPageBody extends StatelessWidget {
  const AppPageBody({required this.children, this.maxWidth = 720, super.key});
  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          TwistPlayerHost.bottomPaddingOf(context) + 32,
        ),
        children: children,
      ),
    ),
  );
}

class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    required this.icon,
    this.color = AppTheme.violet,
    this.size = 56,
    super.key,
  });
  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(size * .3),
    ),
    child: Icon(icon, size: size * .48, color: color),
  );
}

class AppHeroCard extends StatelessWidget {
  const AppHeroCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.eyebrow,
    this.footer,
    super.key,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final String? eyebrow;
  final Widget? footer;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(26),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      gradient: const LinearGradient(
        colors: [Color(0xFF292443), Color(0xFF51417B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(icon, color: const Color(0xFFD2C6FF), size: 26),
            ),
            if (eyebrow != null) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  eyebrow!,
                  style: const TextStyle(
                    color: Color(0xFFD2C6FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: const Color(0xFFD5D0E6)),
        ),
        if (footer != null) ...[const SizedBox(height: 22), footer!],
      ],
    ),
  );
}

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(padding: padding, child: child),
  );
}

class AppNotice extends StatelessWidget {
  const AppNotice({
    required this.text,
    this.icon = Icons.info_outline_rounded,
    super.key,
  });
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.lavender,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.violet, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF57478E),
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ),
      ],
    ),
  );
}
