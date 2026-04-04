import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sidequest/core/theme/app_colors.dart';

void main() {
  group('AppColors.categoryColor', () {
    test('returns correct color for each category', () {
      expect(AppColors.categoryColor('travel'), AppColors.categoryTravel);
      expect(AppColors.categoryColor('food'), AppColors.categoryFood);
      expect(AppColors.categoryColor('fitness'), AppColors.categoryFitness);
      expect(AppColors.categoryColor('creative'), AppColors.categoryCreative);
      expect(AppColors.categoryColor('social'), AppColors.categorySocial);
      expect(AppColors.categoryColor('career'), AppColors.categoryCareer);
      expect(AppColors.categoryColor('thrill'), AppColors.categoryThrill);
      expect(AppColors.categoryColor('random'), AppColors.categoryRandom);
    });

    test('is case-insensitive', () {
      expect(AppColors.categoryColor('Travel'), AppColors.categoryTravel);
      expect(AppColors.categoryColor('FOOD'), AppColors.categoryFood);
    });

    test('returns softGray for unknown category', () {
      expect(AppColors.categoryColor('unknown'), AppColors.softGray);
      expect(AppColors.categoryColor(''), AppColors.softGray);
    });
  });

  group('AppColors.intentColor', () {
    test('returns correct color for each intent', () {
      expect(AppColors.intentColor('growth'), AppColors.intentGrowth);
      expect(AppColors.intentColor('connection'), AppColors.intentConnection);
      expect(AppColors.intentColor('fun'), AppColors.intentFun);
      expect(AppColors.intentColor('challenge'), AppColors.intentChallenge);
      expect(AppColors.intentColor('explore'), AppColors.intentExplore);
      expect(AppColors.intentColor('create'), AppColors.intentCreate);
    });

    test('is case-insensitive', () {
      expect(AppColors.intentColor('Growth'), AppColors.intentGrowth);
      expect(AppColors.intentColor('FUN'), AppColors.intentFun);
    });

    test('returns softGray for unknown intent', () {
      expect(AppColors.intentColor('unknown'), AppColors.softGray);
      expect(AppColors.intentColor(''), AppColors.softGray);
    });
  });

  group('color values', () {
    test('light mode primary colors have correct hex values', () {
      expect(AppColors.navy, const Color(0xFF1B2A4A));
      expect(AppColors.white, const Color(0xFFFFFFFF));
      expect(AppColors.offWhite, const Color(0xFFF5F6F8));
    });

    test('light mode accent colors have correct hex values', () {
      expect(AppColors.warmYellow, const Color(0xFFF5A623));
      expect(AppColors.sunsetOrange, const Color(0xFFE8734A));
      expect(AppColors.emberRed, const Color(0xFFD94F4F));
    });

    test('dark mode primary colors have correct hex values', () {
      expect(AppColors.deepNavy, const Color(0xFF0D1B2A));
      expect(AppColors.cardNavy, const Color(0xFF1B2D45));
      expect(AppColors.slate, const Color(0xFF243447));
    });
  });
}
