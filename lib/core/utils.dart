import 'package:url_launcher/url_launcher.dart';

/// Converte 12.5 em "R$ 12,50".
String formatBRL(double value) =>
    'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

/// Abre um link fora do app (navegador, WhatsApp, discador, Maps).
/// "Future/async/await" = a ação demora, então esperamos sem travar a tela.
Future<void> openUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}
