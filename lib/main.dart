import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/app.dart';
import 'firebase_options.dart';
import 'services/seed_service.dart';

/// Entry point for the SideQuest application.
///
/// Initializes Firebase services (auth, Firestore, Crashlytics,
/// performance monitoring) and wraps the app in [ProviderScope]
/// for Riverpod state management.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    await SeedService(FirebaseFirestore.instance).seedIfNeeded();
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    const ProviderScope(child: SideQuestApp()),
  );
}
