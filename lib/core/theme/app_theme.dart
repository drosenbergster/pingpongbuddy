import 'package:flutter/material.dart';
import 'package:pingpongbuddy/core/theme/design_tokens.dart';

/// Seed color for The Analyst color system (Blue Grey 700).
const _seedColor = Color(0xFF455A64);

/// Creates the PingPongBuddy light theme.
///
/// Material 3 dynamic color scheme from seed `#455A64` with
/// [SemanticColors], [AppTypography], and [AppSpacing] extensions.
ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: _seedColor);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    extensions: <ThemeExtension<dynamic>>[
      SemanticColors.light,
      const AppSpacing(),
      AppTypography.light(),
    ],
  );
}
