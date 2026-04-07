import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/core/theme/app_theme.dart';
import 'package:pingpongbuddy/core/theme/design_tokens.dart';

/// Computes WCAG 2.1 relative luminance for an sRGB color.
double _relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearize(color.r);
  final g = linearize(color.g);
  final b = linearize(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// WCAG contrast ratio between two colors (always >= 1).
double _contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = math.max(la, lb);
  final darker = math.min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('appTheme', () {
    testWidgets('should use Material 3 with all theme extensions', (
      tester,
    ) async {
      late ThemeData capturedTheme;
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme(),
          home: Builder(
            builder: (context) {
              capturedTheme = Theme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(capturedTheme.useMaterial3, isTrue);
      expect(
        capturedTheme.extension<AppSpacing>(),
        isNotNull,
      );
      expect(
        capturedTheme.extension<SemanticColors>(),
        isNotNull,
      );
      expect(
        capturedTheme.extension<AppTypography>(),
        isNotNull,
      );
    });

    testWidgets('should provide correct AppSpacing values from context', (
      tester,
    ) async {
      late AppSpacing spacing;
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme(),
          home: Builder(
            builder: (context) {
              spacing = Theme.of(context).extension<AppSpacing>()!;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(spacing.xs, 4);
      expect(spacing.sm, 8);
      expect(spacing.md, 16);
      expect(spacing.lg, 24);
      expect(spacing.xl, 32);
      expect(spacing.xxl, 48);
    });

    testWidgets('should provide SemanticColors from context', (
      tester,
    ) async {
      late SemanticColors colors;
      await tester.pumpWidget(
        MaterialApp(
          theme: appTheme(),
          home: Builder(
            builder: (context) {
              colors = Theme.of(context).extension<SemanticColors>()!;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(colors.deltaPositive, const Color(0xFF277150));
      expect(colors.surfaceElevated, const Color(0xFFECF0F3));
    });

    testWidgets(
      'should provide AppTypography with correct metric sizes',
      (tester) async {
        late AppTypography typography;
        await tester.pumpWidget(
          MaterialApp(
            theme: appTheme(),
            home: Builder(
              builder: (context) {
                typography = Theme.of(context).extension<AppTypography>()!;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(typography.heroMetric.fontSize, 56);
        expect(typography.heroMetric.fontWeight, FontWeight.w700);
        expect(typography.heroMetric.letterSpacing, closeTo(-1.12, 0.01));
        expect(typography.sectionMetric.fontSize, 28);
        expect(typography.miniMetric.fontSize, 18);
        expect(typography.display.fontSize, 22);
        expect(typography.display.fontWeight, FontWeight.w600);
        expect(typography.body.fontSize, 14);
        expect(typography.body.fontWeight, FontWeight.w400);
        expect(typography.coachVoice.fontSize, 14);
        expect(typography.coachVoice.fontWeight, FontWeight.w500);
        expect(typography.label.fontSize, 12);
        expect(typography.caption.fontSize, 10);
      },
    );
  });

  group('WCAG 2.1 AA contrast compliance', () {
    test('Primary on Surface should meet 4.5:1', () {
      final ratio = _contrastRatio(
        const Color(0xFF455A64),
        const Color(0xFFF8FAFB),
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('On Surface on Surface should meet 4.5:1', () {
      final ratio = _contrastRatio(
        const Color(0xFF191C1E),
        const Color(0xFFF8FAFB),
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('On Surface Variant on Surface should meet 4.5:1', () {
      final ratio = _contrastRatio(
        const Color(0xFF41484D),
        const Color(0xFFF8FAFB),
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Delta Positive on Delta Positive Surface should meet 4.5:1', () {
      final ratio = _contrastRatio(
        const Color(0xFF277150),
        const Color(0xFFD4EDDF),
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('On Primary on Primary should meet 4.5:1', () {
      final ratio = _contrastRatio(
        const Color(0xFFFFFFFF),
        const Color(0xFF455A64),
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });
  });
}
