import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spacing tokens based on a 4dp base unit (Material Design 3 standard).
///
/// Access via `Theme.of(context).extension<AppSpacing>()`.
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing({
    this.xs = 4.0,
    this.sm = 8.0,
    this.md = 16.0,
    this.lg = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  /// Minimum touch target size (exceeds WCAG 44pt requirement).
  static const double minTouchTarget = 48;

  @override
  AppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
    );
  }

  @override
  AppSpacing lerp(covariant AppSpacing? other, double t) {
    if (other == null) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t) ?? xs,
      sm: lerpDouble(sm, other.sm, t) ?? sm,
      md: lerpDouble(md, other.md, t) ?? md,
      lg: lerpDouble(lg, other.lg, t) ?? lg,
      xl: lerpDouble(xl, other.xl, t) ?? xl,
      xxl: lerpDouble(xxl, other.xxl, t) ?? xxl,
    );
  }
}

/// Semantic colors beyond the standard Material 3 color scheme.
///
/// Access via `Theme.of(context).extension<SemanticColors>()`.
class SemanticColors extends ThemeExtension<SemanticColors> {
  const SemanticColors({
    required this.deltaPositive,
    required this.deltaPositiveSurface,
    required this.deltaDeclining,
    required this.deltaDecliningSurface,
    required this.deltaNeutral,
    required this.confidenceHigh,
    required this.confidenceLow,
    required this.coachVoice,
    required this.surfaceElevated,
  });

  /// Improving trends — up arrows.
  final Color deltaPositive;

  /// Background for positive delta badges.
  final Color deltaPositiveSurface;

  /// Declining trends — neutral slate, NEVER red.
  final Color deltaDeclining;

  /// Background for declining delta badges.
  final Color deltaDecliningSurface;

  /// No change from previous session.
  final Color deltaNeutral;

  /// High data quality indicator (≥90% of strokes).
  final Color confidenceHigh;

  /// Low data quality indicator (<90% of strokes).
  final Color confidenceLow;

  /// Coach voice accent ("One thing to try" label).
  final Color coachVoice;

  /// Tonal elevation surface for cards (replaces drop shadows).
  final Color surfaceElevated;

  /// The Analyst — light theme semantic colors.
  static const light = SemanticColors(
    deltaPositive: Color(0xFF277150),
    deltaPositiveSurface: Color(0xFFD4EDDF),
    deltaDeclining: Color(0xFF71787E),
    deltaDecliningSurface: Color(0xFFE8EAEB),
    deltaNeutral: Color(0xFF71787E),
    confidenceHigh: Color(0xFF455A64),
    confidenceLow: Color(0xFF71787E),
    coachVoice: Color(0xFF455A64),
    surfaceElevated: Color(0xFFECF0F3),
  );

  @override
  SemanticColors copyWith({
    Color? deltaPositive,
    Color? deltaPositiveSurface,
    Color? deltaDeclining,
    Color? deltaDecliningSurface,
    Color? deltaNeutral,
    Color? confidenceHigh,
    Color? confidenceLow,
    Color? coachVoice,
    Color? surfaceElevated,
  }) {
    return SemanticColors(
      deltaPositive: deltaPositive ?? this.deltaPositive,
      deltaPositiveSurface:
          deltaPositiveSurface ?? this.deltaPositiveSurface,
      deltaDeclining: deltaDeclining ?? this.deltaDeclining,
      deltaDecliningSurface:
          deltaDecliningSurface ?? this.deltaDecliningSurface,
      deltaNeutral: deltaNeutral ?? this.deltaNeutral,
      confidenceHigh: confidenceHigh ?? this.confidenceHigh,
      confidenceLow: confidenceLow ?? this.confidenceLow,
      coachVoice: coachVoice ?? this.coachVoice,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
    );
  }

  @override
  SemanticColors lerp(covariant SemanticColors? other, double t) {
    if (other == null) return this;
    return SemanticColors(
      deltaPositive: Color.lerp(deltaPositive, other.deltaPositive, t)!,
      deltaPositiveSurface:
          Color.lerp(deltaPositiveSurface, other.deltaPositiveSurface, t)!,
      deltaDeclining:
          Color.lerp(deltaDeclining, other.deltaDeclining, t)!,
      deltaDecliningSurface:
          Color.lerp(deltaDecliningSurface, other.deltaDecliningSurface, t)!,
      deltaNeutral: Color.lerp(deltaNeutral, other.deltaNeutral, t)!,
      confidenceHigh:
          Color.lerp(confidenceHigh, other.confidenceHigh, t)!,
      confidenceLow: Color.lerp(confidenceLow, other.confidenceLow, t)!,
      coachVoice: Color.lerp(coachVoice, other.coachVoice, t)!,
      surfaceElevated:
          Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
    );
  }
}

/// Typography styles for PingPongBuddy.
///
/// Dual-family: Source Serif 4 for numeric metrics, DM Sans for UI text.
/// Access via `Theme.of(context).extension<AppTypography>()`.
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.heroMetric,
    required this.sectionMetric,
    required this.miniMetric,
    required this.display,
    required this.title,
    required this.body,
    required this.coachVoice,
    required this.label,
    required this.caption,
  });

  /// The Analyst — light theme typography.
  factory AppTypography.light() => AppTypography(
    heroMetric: _sourceSerif(fontSize: 56, letterSpacing: -1.12),
    sectionMetric: _sourceSerif(fontSize: 28),
    miniMetric: _sourceSerif(fontSize: 18),
    display: _dmSans(fontWeight: FontWeight.w600, fontSize: 22),
    title: _dmSans(fontWeight: FontWeight.w600, fontSize: 16),
    body: _dmSans(fontWeight: FontWeight.w400, fontSize: 14),
    coachVoice: _dmSans(fontWeight: FontWeight.w500, fontSize: 14),
    label: _dmSans(fontWeight: FontWeight.w500, fontSize: 12),
    caption: _dmSans(fontWeight: FontWeight.w500, fontSize: 10),
  );

  /// 56sp Source Serif 4 Bold — primary session metric (on-table rate).
  final TextStyle heroMetric;

  /// 28sp Source Serif 4 Bold — per-stroke-type breakdown values.
  final TextStyle sectionMetric;

  /// 18sp Source Serif 4 Bold — mini-metric card values.
  final TextStyle miniMetric;

  /// 22sp DM Sans SemiBold — screen titles.
  final TextStyle display;

  /// 16sp DM Sans SemiBold — section headers.
  final TextStyle title;

  /// 14sp DM Sans Regular — descriptions, general UI text.
  final TextStyle body;

  /// 14sp DM Sans Medium — coaching insight text.
  final TextStyle coachVoice;

  /// 12sp DM Sans Medium — metric labels, timestamps, metadata.
  final TextStyle label;

  /// 10sp DM Sans Medium — fine print, confidence indicators.
  final TextStyle caption;

  static TextStyle _sourceSerif({
    required double fontSize,
    double? letterSpacing,
  }) =>
      GoogleFonts.sourceSerif4(
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
      );

  static TextStyle _dmSans({
    required FontWeight fontWeight,
    required double fontSize,
  }) =>
      GoogleFonts.dmSans(
        fontWeight: fontWeight,
        fontSize: fontSize,
      );

  @override
  AppTypography copyWith({
    TextStyle? heroMetric,
    TextStyle? sectionMetric,
    TextStyle? miniMetric,
    TextStyle? display,
    TextStyle? title,
    TextStyle? body,
    TextStyle? coachVoice,
    TextStyle? label,
    TextStyle? caption,
  }) {
    return AppTypography(
      heroMetric: heroMetric ?? this.heroMetric,
      sectionMetric: sectionMetric ?? this.sectionMetric,
      miniMetric: miniMetric ?? this.miniMetric,
      display: display ?? this.display,
      title: title ?? this.title,
      body: body ?? this.body,
      coachVoice: coachVoice ?? this.coachVoice,
      label: label ?? this.label,
      caption: caption ?? this.caption,
    );
  }

  @override
  AppTypography lerp(covariant AppTypography? other, double t) {
    if (other == null) return this;
    return AppTypography(
      heroMetric: TextStyle.lerp(heroMetric, other.heroMetric, t)!,
      sectionMetric:
          TextStyle.lerp(sectionMetric, other.sectionMetric, t)!,
      miniMetric: TextStyle.lerp(miniMetric, other.miniMetric, t)!,
      display: TextStyle.lerp(display, other.display, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      coachVoice: TextStyle.lerp(coachVoice, other.coachVoice, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
    );
  }
}
