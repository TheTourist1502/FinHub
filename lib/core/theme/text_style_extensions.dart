import 'package:flutter/painting.dart';

extension FontWeightExtension on TextStyle {
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
}

extension LineHeightExtension on TextStyle {
  TextStyle get lh100 => copyWith(height: 1);
  TextStyle get lh105 => copyWith(height: 1.05);
  TextStyle get lh110 => copyWith(height: 1.10);
  TextStyle get lh115 => copyWith(height: 1.15);
  TextStyle get lh120 => copyWith(height: 1.20);
  TextStyle get lh125 => copyWith(height: 1.25);
  TextStyle get lh130 => copyWith(height: 1.30);
  TextStyle get lh133 => copyWith(height: 1.33);
  TextStyle get lh135 => copyWith(height: 1.35);
  TextStyle get lh140 => copyWith(height: 1.40);
  TextStyle get lh143 => copyWith(height: 1.43);
  TextStyle get lh145 => copyWith(height: 1.45);
  TextStyle get lh150 => copyWith(height: 1.50);
  TextStyle get lh155 => copyWith(height: 1.55);
  TextStyle get lh160 => copyWith(height: 1.60);
  TextStyle get lh165 => copyWith(height: 1.65);
  TextStyle get lh170 => copyWith(height: 1.70);
  TextStyle get lh175 => copyWith(height: 1.75);
  TextStyle get lh180 => copyWith(height: 1.80);
  TextStyle get lh185 => copyWith(height: 1.85);
  TextStyle get lh190 => copyWith(height: 1.90);
  TextStyle get lh195 => copyWith(height: 1.95);
  TextStyle get lh200 => copyWith(height: 2);
  TextStyle get lh205 => copyWith(height: 2.05);
  TextStyle get lh210 => copyWith(height: 2.10);
  TextStyle get lh215 => copyWith(height: 2.15);
  TextStyle get lh220 => copyWith(height: 2.20);
  TextStyle get lh225 => copyWith(height: 2.25);
  TextStyle get lh230 => copyWith(height: 2.30);
  TextStyle get lh235 => copyWith(height: 2.35);
  TextStyle get lh240 => copyWith(height: 2.40);
  TextStyle get lh245 => copyWith(height: 2.45);
  TextStyle get lh250 => copyWith(height: 2.50);
}

extension LetterSpacingExtension on TextStyle {
  TextStyle get lsN50 => copyWith(letterSpacing: -0.50);
  TextStyle get lsN45 => copyWith(letterSpacing: -0.45);
  TextStyle get lsN40 => copyWith(letterSpacing: -0.40);
  TextStyle get lsN35 => copyWith(letterSpacing: -0.35);
  TextStyle get lsN30 => copyWith(letterSpacing: -0.30);
  TextStyle get lsN25 => copyWith(letterSpacing: -0.25);
  TextStyle get lsN20 => copyWith(letterSpacing: -0.20);
  TextStyle get lsN15 => copyWith(letterSpacing: -0.15);
  TextStyle get lsN10 => copyWith(letterSpacing: -0.10);
  TextStyle get lsN05 => copyWith(letterSpacing: -0.05);
  TextStyle get ls00 => copyWith(letterSpacing: 0);
  TextStyle get ls05 => copyWith(letterSpacing: 0.05);
  TextStyle get ls10 => copyWith(letterSpacing: 0.10);
  TextStyle get ls15 => copyWith(letterSpacing: 0.15);
  TextStyle get ls20 => copyWith(letterSpacing: 0.20);
  TextStyle get ls25 => copyWith(letterSpacing: 0.25);
  TextStyle get ls30 => copyWith(letterSpacing: 0.30);
  TextStyle get ls35 => copyWith(letterSpacing: 0.35);
  TextStyle get ls40 => copyWith(letterSpacing: 0.40);
  TextStyle get ls45 => copyWith(letterSpacing: 0.45);
  TextStyle get ls50 => copyWith(letterSpacing: 0.50);
}
