import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:structure/features/device_info/data/device_diagnostics_service.dart';

class DeviceDiagnosticsScreen extends StatefulWidget {
  const DeviceDiagnosticsScreen({super.key});

  @override
  State<DeviceDiagnosticsScreen> createState() =>
      _DeviceDiagnosticsScreenState();
}

class _DeviceDiagnosticsScreenState extends State<DeviceDiagnosticsScreen> {
  final DeviceDiagnosticsService _service = DeviceDiagnosticsService();
  DeviceSnapshot? _snapshot;
  Object? _error;
  bool _isLoading = true;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _load();
    }
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final MediaQueryData media = MediaQuery.of(context);
      final DeviceSnapshot snapshot = await _service.collect(
        logicalSize: media.size,
        devicePixelRatio: media.devicePixelRatio,
        textScaleFactor: media.textScaler.scale(1),
        platformBrightness: media.platformBrightness,
      );
      if (!mounted) {
        return;
      }
      setState(() => _snapshot = snapshot);
    } on Object catch (error) {
      if (mounted) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _copyJson() async {
    final DeviceSnapshot? snapshot = _snapshot;
    if (snapshot == null) {
      return;
    }
    await Clipboard.setData(ClipboardData(text: snapshot.toPrettyJson()));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Device data copied as JSON')));
  }

  @override
  Widget build(BuildContext context) {
    const Color ink = Color(0xff17212F);
    const Color canvas = Color(0xffF4F7F8);
    return Scaffold(
      backgroundColor: canvas,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          color: const Color(0xff007C78),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _Header(
                  marker: _deviceUdid,
                  isLoading: _isLoading,
                  onRefresh: _load,
                  onCopy: _copyJson,
                ),
              ),
              if (_error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(error: _error!, onRetry: _load),
                )
              else if (_snapshot == null)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...<Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: <Widget>[
                        Text(
                          'AVAILABLE DATA',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: ink.withValues(alpha: 0.58),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          '$_fieldCount fields',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: ink.withValues(alpha: 0.52)),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 36),
                  sliver: SliverList.separated(
                    itemCount: _snapshot!.sections.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final MapEntry<String, Map<String, Object?>> section =
                          _snapshot!.sections.entries.elementAt(index);
                      return _DataCard(
                        title: section.key,
                        values: section.value,
                        icon: _iconFor(section.key),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? get _deviceUdid {
    final Object? value = _snapshot?.sections['Identity']?['udid'];
    return value?.toString();
  }

  int get _fieldCount =>
      _snapshot?.sections.values.fold<int>(
        0,
        (int total, Map<String, Object?> section) => total + section.length,
      ) ??
      0;

  IconData _iconFor(String section) => switch (section) {
    'App' => Icons.apps_rounded,
    'Identity' => Icons.fingerprint_rounded,
    'Hardware' => Icons.memory_rounded,
    'Operating system' => Icons.settings_suggest_rounded,
    'Resources' => Icons.storage_rounded,
    'Battery' => Icons.battery_charging_full_rounded,
    'Network' => Icons.wifi_rounded,
    'Display' => Icons.aspect_ratio_rounded,
    'Runtime' => Icons.code_rounded,
    _ => Icons.info_outline_rounded,
  };
}

class _Header extends StatelessWidget {
  const _Header({
    required this.marker,
    required this.isLoading,
    required this.onRefresh,
    required this.onCopy,
  });

  final String? marker;
  final bool isLoading;
  final VoidCallback onRefresh;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xff17212F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xff65D6CC).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.phonelink_setup_rounded,
                  color: Color(0xff65D6CC),
                ),
              ),
              const Spacer(),
              IconButton.filledTonal(
                tooltip: 'Refresh data',
                onPressed: isLoading ? null : onRefresh,
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                ),
                icon: isLoading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Device diagnostics',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Permission-free information exposed by this device',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Color(0xff087E78), Color(0xff12675F)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.verified_user_outlined, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'DEVICE UDID',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SelectableText(
                        marker ?? 'Collecting…',
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Copy all data as JSON',
                  onPressed: marker == null ? null : onCopy,
                  color: Colors.white,
                  icon: const Icon(Icons.copy_all_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({
    required this.title,
    required this.values,
    required this.icon,
  });

  final String title;
  final Map<String, Object?> values;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffE5EAEC)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x09000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 9),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xffE8F5F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: const Color(0xff087E78)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xff17212F),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '${values.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xff8B959E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final MapEntry<String, Object?> entry in values.entries)
              _DataRow(label: entry.key, value: _formatValue(entry.value)),
          ],
        ),
      ),
    );
  }

  static String _formatValue(Object? value) {
    if (value == null || value.toString().isEmpty) {
      return 'Not available';
    }
    if (value is List<Object?>) {
      return value.join(', ');
    }
    if (value is bool) {
      return value ? 'Yes' : 'No';
    }
    return value.toString();
  }
}

class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              _readable(label),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xff7D8790),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: SelectableText(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xff26323E),
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _readable(String value) => value
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (Match match) => '${match[1]} ${match[2]}',
      )
      .replaceAll('_', ' ')
      .split(' ')
      .map(
        (String word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, size: 48),
          const SizedBox(height: 12),
          Text(
            'Could not collect device data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(error.toString(), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}
