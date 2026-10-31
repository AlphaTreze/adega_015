import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/splash/splash_screen.dart';

/// Todo app Dart começa na função main().
/// runApp() recebe o widget "raiz" e o coloca na tela.
void main() => runApp(const AdegaApp());

/// Widget raiz. StatelessWidget = widget sem estado que muda (só descreve a tela).
class AdegaApp extends StatelessWidget {
  const AdegaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura tema, título e qual é a primeira tela (home).
    return MaterialApp(
      title: 'ADEGA 015 ORIGINALES',
      debugShowCheckedModeBanner: false, // remove a faixa "DEBUG"
      theme: AppTheme.dark,
      home: const SplashScreen(), // o app abre pela splash
    );
  }
}
