import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the current [ThemeMode] for the app.
///
/// Defaults to [ThemeMode.system]. Can be toggled by the user
/// in settings to force light or dark mode.
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);
