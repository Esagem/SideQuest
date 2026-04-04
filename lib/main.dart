import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sidequest/app.dart';

/// Entry point for the SideQuest application.
///
/// Wraps the app in a [ProviderScope] for Riverpod state management.
/// Firebase initialization is commented out until `flutterfire configure`
/// is run.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(firebase): Uncomment after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    const ProviderScope(child: SideQuestApp()),
  );
}
