import 'package:flutter/material.dart';

import 'package:sidequest/app.dart';

/// Entry point for the SideQuest application.
///
/// Initializes Firebase and runs the app. Firebase initialization
/// is currently commented out until `flutterfire configure` is run.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO(firebase): Uncomment after running `flutterfire configure`
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const SideQuestApp());
}
