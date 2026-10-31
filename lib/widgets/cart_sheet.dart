import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../core/utils.dart';
import '../state/cart_controller.dart';

/// Painel do carrinho que sobe de baixo (bottom sheet).
class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  /// Método "estático": chamamos CartSheet.show(context) sem criar objeto.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.superficie,
      constraints: const BoxConstraints(maxWidth: 560), // bom na web também
      builder: (_) => const CartSheet(),
    );
  }

  /// Monta a mensagem e abre o WhatsApp da adega com o pedido pronto.
  void _checkout() {
    final b = StringBuffer('Olá, ${Business.name}! Quero fazer um pedido:\n');
    cart.items.forEach((p, qty) {
      b.writeln('- ${qty}x ${p.name} (${formatBRL(p.price * qty)})');
    });
    b.write('Total: ${formatBRL(cart.totalPrice)}');
    openUrl('https://wa.me/${Business.phoneDigits}?text=${Uri.encodeComponent(b.toString())}');
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder redesenha quando o carrinho muda (notifyListeners).
    return ListenableBuilder(
      listenable: cart,
      builder: (context, _) {
        if (cart.isEmpty) {
          return const SizedBox(
            height: 220,
            child: Center(child: Text('Seu carrinho está vazio.\nAdicione bebidas geladas!', textAlign: TextAlign.center)),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seu pedido', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: cart.items.entries.map((e) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(e.key.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(formatBRL(e.key.price * e.value)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => cart.remove(e.key)),
                          Text('${e.value}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => cart.add(e.key)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total'),
                  Text(formatBRL(cart.totalPrice),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.ambar)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text('Enviar pedido pelo WhatsApp'),
                  onPressed: _checkout,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
