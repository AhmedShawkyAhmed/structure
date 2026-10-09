import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:structure/core/di/service_locator.dart';
import 'package:structure/core/routing/app_router.dart';
import 'package:structure/features/issue_reporting/data/issue_draft_store.dart';
import 'package:structure/features/issue_reporting/data/issue_report.dart';
import 'package:structure/features/issue_reporting/data/issue_report_repository.dart';
import 'package:structure/features/issue_reporting/data/issue_reporting_controller.dart';
import 'package:structure/features/localization/generated/app_localizations.dart';

class _Store extends Mock implements IssueDraftStore {}

class _Repository extends Mock implements IssueReportRepository {}

class _Preferences extends Mock implements SharedPreferencesAsync {}

void main() {
  late _Store store;
  late _Repository repository;
  late IssueReportingController controller;
  late GlobalKey<NavigatorState> navigatorKey;

  setUpAll(() {
    registerFallbackValue(const IssueReportState(id: 'id', screen: '/home'));
    registerFallbackValue(CancelToken());
    registerFallbackValue((int sent, int total) {});
  });
  setUp(() async {
    await serviceLocator.reset();
    store = _Store();
    repository = _Repository();
    when(() => store.load()).thenAnswer((_) async => null);
    when(() => store.save(any())).thenAnswer((_) async {});
    when(() => store.clear()).thenAnswer((_) async {});
    when(() => repository.configured).thenReturn(true);
    when(() => repository.simulated).thenReturn(false);
    navigatorKey = GlobalKey<NavigatorState>();
    controller = IssueReportingController(
      navigatorKey: navigatorKey,
      preferences: _Preferences(),
    );
    serviceLocator.registerSingleton<IssueReportingController>(controller);
    serviceLocator.registerSingleton<IssueDraftStore>(store);
    serviceLocator.registerSingleton<IssueReportRepository>(repository);
  });
  tearDown(() async {
    controller.dispose();
    await serviceLocator.reset();
  });

  Future<void> launch(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [controller.routeObserver],
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: AppRouter().onGenerateRoute,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'launcher has separate feature entries; cancelling never opens a draft',
    (tester) async {
      await launch(tester);
      expect(find.text('Twist music'), findsOneWidget);
      expect(find.text('Device info'), findsOneWidget);
      expect(find.text('Issue reporting'), findsOneWidget);
      await tester.tap(find.byTooltip('Report an issue'));
      await tester.pumpAndSettle();
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, false);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verifyNever(() => store.load());
      expect(controller.opening, false);
      expect(tester.takeException(), null);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('restored report needs fresh consent; editing revokes consent', (
    tester,
  ) async {
    when(() => store.load()).thenAnswer(
      (_) async => const IssueReportState(
        id: 'draft-id',
        screen: '/twist',
        description: 'Music stopped',
      ),
    );
    await launch(tester);
    await tester.tap(find.byTooltip('Report an issue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Music stopped'), findsOneWidget);
    expect(
      find.text('Screen where the issue occurred: /twist'),
      findsOneWidget,
    );
    final send = find.widgetWithText(FilledButton, 'Send report');
    await tester.scrollUntilVisible(
      send,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(send).onPressed, null);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(tester.widget<FilledButton>(send).onPressed, isNotNull);
    await tester.scrollUntilVisible(
      find.byKey(const Key('report_description')),
      -300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const Key('report_description')),
      'Music stopped twice',
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      send,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(send).onPressed, null);
    expect(tester.takeException(), null);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('Arabic launcher and report form fit a phone viewport', (
    tester,
  ) async {
    await launch(tester, locale: const Locale('ar'));
    await tester.tap(find.byTooltip('الإبلاغ عن مشكلة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(find.text('ماذا حدث؟'), findsOneWidget);
    final send = find.widgetWithText(FilledButton, 'إرسال التقرير');
    await tester.scrollUntilVisible(
      send,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), null);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });

  testWidgets('simulated submission is labelled in the form and receipt', (
    tester,
  ) async {
    when(() => repository.simulated).thenReturn(true);
    when(() => store.load()).thenAnswer(
      (_) async => const IssueReportState(
        id: 'draft-id',
        screen: '/home',
        description: 'Broken',
      ),
    );
    when(
      () => repository.submit(
        any(),
        cancelToken: any(named: 'cancelToken'),
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer((_) async => 'SIMULATED-draft-id');
    await launch(tester);
    await tester.tap(find.byTooltip('Report an issue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(
      find.text('Test mode: submissions are simulated. No report is uploaded.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('report_consent')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('report_consent')));
    await tester.pumpAndSettle();
    final send = find.widgetWithText(FilledButton, 'Send report');
    await tester.scrollUntilVisible(
      send,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(send);
    await tester.pumpAndSettle();
    expect(find.text('Simulation complete'), findsOneWidget);
    expect(
      find.text(
        'No report was uploaded. Check the debug console for the request and simulated response.',
      ),
      findsOneWidget,
    );
    expect(find.text('Report sent'), findsNothing);
    verify(() => store.clear()).called(1);
    expect(tester.takeException(), null);
    await tester.pumpWidget(const SizedBox());
  });
}
