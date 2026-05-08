import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _router = buildAppRouter(ref.read(appControllerProvider));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _router.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    final controller = ref.read(appControllerProvider);
    controller.refreshFamilyInvites(force: false);
    controller.refreshRemoteFamilies(force: false);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appSnapshotProvider);
    final controller = ref.read(appControllerProvider);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'MiniAdımlar',
          debugShowCheckedModeBanner: false,
          theme: buildAppTheme(),
          darkTheme: buildAppTheme(brightness: Brightness.dark),
          themeMode: controller.snapshot.user?.theme == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light,
          locale: controller.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: _router,
        );
      },
    );
  }
}
