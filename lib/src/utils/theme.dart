import 'package:flutter/material.dart';

TextTheme createTextTheme(BuildContext context) {
  final textStyle = TextStyle(
    fontFamily: 'Source Han Serif',
  );

  final textTheme = Theme.of(context).textTheme;
  return textTheme.merge(TextTheme(
    displayLarge: textStyle,
    displayMedium: textStyle,
    displaySmall: textStyle,
    headlineLarge: textStyle,
    headlineMedium: textStyle,
    headlineSmall: textStyle,
    titleLarge: textStyle,
    titleMedium: textStyle,
    titleSmall: textStyle,
  ));
}

ThemeData addTapTargetMarginOnDesktop(ThemeData data) => data.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );

ThemeData removeTapTargetMarginOnMobile(ThemeData data) => data.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
