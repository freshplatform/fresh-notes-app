import 'package:flutter/foundation.dart' show kDebugMode, kReleaseMode;
import 'package:flutter/material.dart' show MaterialApp, Scaffold;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding, runApp;
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:logging/logging.dart';

import 'core/flavor_config.dart';
import 'core/my_app.dart';
import 'core/start/app_startup.dart';
import 'presentation/components/others/w_error.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (!kReleaseMode) {
      Logger.root.level = Level.ALL; // defaults to Level.INFO
      Logger.root.onRecord.listen((record) {
        if (kDebugMode) {
          print(record.message);
        }
      });
    }

    FlavorConfig.setup(
      appStore: const String.fromEnvironment('APP_STORE', defaultValue: ''),
      isShouldCheckForUpdates:
          const bool.fromEnvironment('UPDATE_CHECK', defaultValue: false),
    );

    await dotenv.load(fileName: '.env');
    await AppStartup.getInstance().initialize();
    runApp(const MyApp());
  } catch (e) {
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ErrorWithoutTryAgain(),
        ),
      ),
    );
  }
}
