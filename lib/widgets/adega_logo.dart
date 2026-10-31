import 'package:flutter/material.dart';
import '../core/theme.dart';

/// Logo da marca (logo_adega.png, com fundo transparente).
/// large = true  -> splash: logo maior + texto "ADEGA 015 ORIGINALES" abaixo
/// large = false -> barra do topo: só o logo pequeno
class AdegaLogo extends StatelessWidget {
  final bool large;
  const AdegaLogo({super.key, this.large = false});

  static const String _path = 'assets/images/logo_adega.png';

  @override
  Widget build(BuildContext context) {
    // PNG com transparência: nenhum filtro é necessário.
    // Só definimos a altura; a largura acompanha e a proporção é mantida.
    final logo = Image.asset(
      _path,
      height: large ? 155 : 44,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      // Plano B se a imagem não for encontrada:
      errorBuilder: (_, __, ___) => Text(
        '015',
        style: TextStyle(
          fontSize: large ? 84 : 24,
          fontWeight: FontWeight.w900,
          color: AppColors.ambar,
        ),
      ),
    );

    // Barra do topo: só o logo.
    if (!large) return logo;

    // Splash: logo + texto embaixo.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(height: 14),
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'ADEGA 015 ORIGINALES',
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 6,
              fontWeight: FontWeight.w800,
              color: AppColors.texto,
            ),
          ),
        ),
      ],
    );
  }
}