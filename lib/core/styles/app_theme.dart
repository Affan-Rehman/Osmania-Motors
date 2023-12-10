import 'package:flutter/material.dart';
import 'package:motors_app/core/styles/styles.dart';

/// All custom application theme
class AppTheme {
  final ThemeData _themeLight = ThemeData(fontFamily: 'SFProDisplay');

  ThemeData get themeLight => _themeLight.copyWith(
        scaffoldBackgroundColor:
            Colors.white, // Set scaffold background to white

        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white, // Set app bar background to white
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:
              Colors.white, // Set bottom navigation bar background to white
        ),

        dialogTheme: DialogTheme(
          backgroundColor: Colors.white, // Set dialog background to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Set elevated button background to white
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),

        // Add other customizations if needed
      );
}
