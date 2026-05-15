import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_ui.dart';
import 'app_controller.dart';
import 'localization/app_localizations.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MiniAdimlarApp extends ConsumerStatefulWidget {
  const MiniAdimlarApp({super.key});

  @override
  ConsumerState<MiniAdimlarApp> createState() => _MiniAdimlarAppState();
}

class _MiniAdimlarAppState extends ConsumerState<MiniAdimlarApp>
    with WidgetsBindingObserver {
  late final AppController _controller;
  late final GoRouter _router;
  late ThemeMode _themeMode;
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = ref.read(appControllerProvider);
    _router = buildAppRouter(_controller);
    _themeMode = _themeModeFor(_controller);
    _locale = _controller.locale;
    _controller.addListener(_syncAppShellSettings);
  }

  @override
  void dispose() {
    _controller.removeListener(_syncAppShellSettings);
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    super.dispose();
  }

  void _syncAppShellSettings() {
    final nextThemeMode = _themeModeFor(_controller);
    final nextLocale = _controller.locale;
    if (nextThemeMode == _themeMode && nextLocale == _locale) return;
    if (!mounted) return;
    setState(() {
      _themeMode = nextThemeMode;
      _locale = nextLocale;
    });
  }

  ThemeMode _themeModeFor(AppController controller) {
    return controller.snapshot.user?.theme == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _controller.refreshTimeSensitiveViews();
    unawaited(_controller.refreshAfterExternalChange(refreshRemote: true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MiniAdımlar',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      theme: buildAppTheme(),
      darkTheme: buildAppTheme(brightness: Brightness.dark),
      themeMode: _themeMode,
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
