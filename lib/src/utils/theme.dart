import 'package:flutter/material.dart';

ThemeData addTapTargetMarginOnDesktop(ThemeData data) => data.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );

ThemeData removeTapTargetMarginOnMobile(ThemeData data) => data.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
