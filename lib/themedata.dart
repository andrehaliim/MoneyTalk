import 'package:flutter/material.dart';

import 'color_scheme.dart';

ThemeData themeData = ThemeData(
  useMaterial3: true,
  colorScheme: moneyTalkColorScheme,
  scaffoldBackgroundColor: moneyTalkColorScheme.surface,
  iconTheme: IconThemeData(
    color: moneyTalkColorScheme.primary,
    size: 25,
  ),
);