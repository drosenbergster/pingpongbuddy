import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pingpongbuddy/core/theme/design_tokens.dart';

void main() {
  group('AppSpacing', () {
    test('should have correct default token values', () {
      const spacing = AppSpacing();
      expect(spacing.xs, 4);
      expect(spacing.sm, 8);
      expect(spacing.md, 16);
      expect(spacing.lg, 24);
      expect(spacing.xl, 32);
      expect(spacing.xxl, 48);
    });

    test('should have minimum touch target of 48dp', () {
      expect(AppSpacing.minTouchTarget, 48);
    });

    test('should produce correct values from copyWith', () {
      const original = AppSpacing();
      final modified = original.copyWith(md: 20, xl: 40);
      expect(modified.xs, 4);
      expect(modified.sm, 8);
      expect(modified.md, 20);
      expect(modified.lg, 24);
      expect(modified.xl, 40);
      expect(modified.xxl, 48);
    });

    test('should lerp between two instances', () {
      const a = AppSpacing();
      const b = AppSpacing(xs: 8, sm: 16, md: 32, lg: 48, xl: 64, xxl: 96);
      final mid = a.lerp(b, 0.5);
      expect(mid.xs, 6);
      expect(mid.sm, 12);
      expect(mid.md, 24);
      expect(mid.lg, 36);
      expect(mid.xl, 48);
      expect(mid.xxl, 72);
    });

    test('should return self when lerping with null', () {
      const spacing = AppSpacing();
      final result = spacing.lerp(null, 0.5);
      expect(result.xs, spacing.xs);
      expect(result.xxl, spacing.xxl);
    });
  });

  group('SemanticColors', () {
    test('should define all 9 light theme semantic colors', () {
      const colors = SemanticColors.light;
      expect(colors.deltaPositive, const Color(0xFF277150));
      expect(colors.deltaPositiveSurface, const Color(0xFFD4EDDF));
      expect(colors.deltaDeclining, const Color(0xFF71787E));
      expect(colors.deltaDecliningSurface, const Color(0xFFE8EAEB));
      expect(colors.deltaNeutral, const Color(0xFF71787E));
      expect(colors.confidenceHigh, const Color(0xFF455A64));
      expect(colors.confidenceLow, const Color(0xFF71787E));
      expect(colors.coachVoice, const Color(0xFF455A64));
      expect(colors.surfaceElevated, const Color(0xFFECF0F3));
    });

    test('should never use red for declining metrics', () {
      const colors = SemanticColors.light;
      expect(colors.deltaDeclining, isNot(equals(const Color(0xFFBA1A1A))));
      expect(
        colors.deltaDeclining.r,
        lessThan(0.6),
        reason: 'Declining color should not have high red channel',
      );
    });

    test('should produce correct values from copyWith', () {
      const colors = SemanticColors.light;
      final modified = colors.copyWith(
        deltaPositive: const Color(0xFF000000),
      );
      expect(modified.deltaPositive, const Color(0xFF000000));
      expect(modified.deltaDeclining, colors.deltaDeclining);
    });

    test('should lerp between two instances', () {
      const a = SemanticColors.light;
      final b = a.copyWith(deltaPositive: const Color(0xFFFFFFFF));
      final mid = a.lerp(b, 0.5);
      expect(mid.deltaPositive, isNot(equals(a.deltaPositive)));
      expect(mid.deltaPositive, isNot(equals(b.deltaPositive)));
    });

    test('should return self when lerping with null', () {
      const colors = SemanticColors.light;
      final result = colors.lerp(null, 0.5);
      expect(result.deltaPositive, colors.deltaPositive);
    });
  });
}
