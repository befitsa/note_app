import 'package:flutter/material.dart';
import 'package:note_app_2/app/app.bottomsheets.dart';
import 'package:note_app_2/app/app.dialogs.dart';
import 'package:note_app_2/app/app.locator.dart';
import 'package:note_app_2/app/app.router.dart';
import 'package:note_app_2/services/storage_service.dart';
import 'package:note_app_2/services/theme_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/services.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await locator<StorageService>().init();
  await locator<ThemeService>().initialise();
  setupDialogUi();
  setupBottomSheetUi();
  SystemChrome.setSystemUIOverlayStyle(
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  ),
);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = locator<ThemeService>();

    return AnimatedBuilder(
      animation: themeService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Note App',

          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [StackedService.routeObserver],

          themeMode: themeService.themeMode,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blue,
          ),

          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
        );
      },
    );
  }
}