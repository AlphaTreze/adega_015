import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';

/// Rodapé: mapa, telefone e delivery.
/// No desktop ficam lado a lado (Row); no celular, um embaixo do outro (Column).
class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.superficie,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // LayoutBuilder entrega a largura disponível -> base da responsividade.
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth > 800;
                final blocks = [_mapBlock(), _phoneBlock(), _deliveryBlock()];
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: blocks
                        .map((b) => Expanded(child: Padding(padding: const EdgeInsets.all(10), child: b)))
                        .toList(),
                  );
                }
                return Column(
                  children: blocks
                      .map((b) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: b))
                      .toList(),
                );
              }),
              const Divider(height: 40),
              const Text('© 2026 ${Business.name}. Beba com moderação. Venda proibida para menores de 18 anos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textoSuave)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(IconData icon, String text) => Row(children: [
        Icon(icon, color: AppColors.ambar, size: 20),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ]);

  Widget _mapBlock() {
    // Endereço convertido para o formato de link (espaços e acentos codificados).
    final query = Uri.encodeComponent(Business.address);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _title(Icons.place, 'Onde estamos'),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 130,
          color: AppColors.carvao,
          child: GridPaper(
            color: Colors.white12,
            interval: 40,
            divisions: 1,
            subdivisions: 1,
            child: const Center(child: Icon(Icons.location_on, size: 48, color: AppColors.ambar)),
          ),
        ),
      ),
      const SizedBox(height: 8),
      const Text(Business.address, style: TextStyle(color: AppColors.textoSuave)),
      TextButton.icon(
        onPressed: () => openUrl('https://www.google.com/maps/search/?api=1&query=$query'),
        icon: const Icon(Icons.map, size: 18),
        label: const Text('Abrir no Google Maps'),
      ),
    ]);
  }

  Widget _phoneBlock() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _title(Icons.phone, 'Telefone'),
        const SizedBox(height: 12),
        const Text(Business.phoneDisplay, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text(Business.hours, style: TextStyle(color: AppColors.textoSuave)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          OutlinedButton.icon(
            onPressed: () => openUrl('tel:+${Business.phoneDigits}'),
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Ligar'),
          ),
          OutlinedButton.icon(
            onPressed: () => openUrl('https://wa.me/${Business.phoneDigits}'),
            icon: const Icon(Icons.chat, size: 18),
            label: const Text('WhatsApp'),
          ),
        ]),
      ]);

  Widget _deliveryBlock() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _title(Icons.delivery_dining, 'Delivery'),
        const SizedBox(height: 12),
        const Text(Business.deliveryInfo, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        const Text('Pague na entrega: Pix, cartão ou dinheiro.', style: TextStyle(color: AppColors.textoSuave)),
      ]);
}
