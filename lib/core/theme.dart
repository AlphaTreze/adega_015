import 'package:flutter/material.dart';

/// Paleta da marca em um só lugar. Mudou a cor? Muda aqui e o app todo muda.
/// Cores em Flutter: Color(0xAARRGGBB) -> AA = opacidade (FF = 100%).
class AppColors {
  static const carvao = Color(0xFF17110F); // fundo principal
  static const superficie = Color(0xFF261B18); // cards e rodapé
  static const bordo = Color(0xFF7A1530); // vinho
  static const ambar = Color(0xFFF0A81C); // dourado de destaque
  static const texto = Color(0xFFF5EDE3);
  static const textoSuave = Color(0xFFB9A99B);
}

class AppTheme {
  /// "get" = propriedade calculada. Usamos assim: AppTheme.dark
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.carvao,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.ambar,
          onPrimary: AppColors.carvao,
          secondary: Color.fromARGB(255, 95, 28, 46),
          surface: AppColors.superficie,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.carvao,
          surfaceTintColor: Colors.transparent,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      );
}
