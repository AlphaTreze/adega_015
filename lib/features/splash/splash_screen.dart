import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../widgets/adega_logo.dart';
import '../home/home_screen.dart';

/// StatefulWidget = widget COM estado (aqui: o progresso da animação).
/// Ele é dividido em 2 classes: o widget e o seu State.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// SingleTickerProviderStateMixin dá ao State um "relógio" (ticker)
// necessário para animações rodarem a 60 quadros por segundo.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // initState roda UMA vez, quando a tela nasce.
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200), // tempo total do "carregamento"
    )
      ..addStatusListener((status) {
        // Quando a animação termina, vai para a Home.
        if (status == AnimationStatus.completed) _goHome();
      })
      ..forward(); // inicia (valor vai de 0.0 até 1.0)
  }

  void _goHome() {
    if (!mounted) return; // segurança: a tela ainda existe?
    // pushReplacement troca a splash pela home (não dá para "voltar" à splash).
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  // dispose roda quando a tela morre: sempre libere controllers!
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            // Limita a largura: no celular ocupa a tela, na web fica centralizado.
            constraints: const BoxConstraints(maxWidth: 560),
            // AnimatedBuilder redesenha este trecho a cada "tick" da animação.
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_controller.value);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AdegaLogo(large: true),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: CustomPaint(painter: _RoutePainter(t)),
                    ),
                    const SizedBox(height: 24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: t,
                        minHeight: 6,
                        backgroundColor: AppColors.superficie,
                        color: AppColors.ambar,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Gelando as bebidas...',
                        style: TextStyle(color: AppColors.textoSuave)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// CustomPainter = "tela em branco" onde desenhamos com código (como um Canvas).
/// Aqui: desenha a rota e posiciona o entregador ao longo dela.
class _RoutePainter extends CustomPainter {
  final double progress; // 0.0 a 1.0
  _RoutePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // 1) A rota: duas curvas de Bézier encadeadas (formato de "S").
    final route = Path()
      ..moveTo(24, h * 0.8)
      ..cubicTo(w * 0.25, -h * 0.1, w * 0.40, h * 1.1, w * 0.55, h * 0.5)
      ..cubicTo(w * 0.70, -h * 0.1, w * 0.85, h * 0.9, w - 24, h * 0.25);

    // PathMetric "mede" o caminho: permite achar o ponto em qualquer distância.
    final metric = route.computeMetrics().first;
    final length = metric.length;

    // 2) Rota tracejada (o caminho todo, em cor fraca)
    final dashPaint = Paint()
      ..color = AppColors.textoSuave.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (double d = 0; d < length; d += 16) {
      canvas.drawPath(metric.extractPath(d, math.min(d + 8, length)), dashPaint);
    }

    // 3) Trecho já percorrido (dourado)
    final donePaint = Paint()
      ..color = AppColors.ambar
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(metric.extractPath(0, length * progress), donePaint);

    // 4) Origem (adega) e destino (cliente)
    _icon(canvas, Icons.storefront, Offset(24, h * 0.8 + 4), 30, AppColors.texto);
    _icon(canvas, Icons.location_on, Offset(w - 24, h * 0.25 - 10), 36, AppColors.bordo);

    // 5) Entregador: pega o ponto da rota na distância atual
    final tangent = metric.getTangentForOffset(length * progress);
    if (tangent != null) {
      _icon(canvas, Icons.delivery_dining, tangent.position - const Offset(0, 16), 44, AppColors.ambar);
    }
  }

  /// Desenha um ícone do Material no Canvas (ícone é uma fonte de letras!).
  void _icon(Canvas c, IconData icon, Offset center, double size, Color color) {
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(fontSize: size, fontFamily: icon.fontFamily, package: icon.fontPackage, color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, center - Offset(tp.width / 2, tp.height / 2));
  }

  // Só redesenha se o progresso mudou (economiza processamento).
  @override
  bool shouldRepaint(_RoutePainter old) => old.progress != progress;
}
