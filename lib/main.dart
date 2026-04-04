import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/app.dart';

/// Entry point for the SideQuest application.
///
/// Initializes Firebase services (auth, Firestore, Crashlytics,
/// performance monitoring) and wraps the app in [ProviderScope]
/// for Riverpod state management.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(firebase): Uncomment after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  //
  // // Crashlytics: catch Flutter framework errors
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //
  // // Crashlytics: catch async errors
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  //
  // // Performance monitoring
  // await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  runApp(
    const ProviderScope(child: SideQuestApp()),
  );
}
