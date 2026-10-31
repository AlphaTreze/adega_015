import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/utils.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';

/// Card de um produto: imagem, nome, preço e botão de adicionar.
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 150, width: double.infinity, child: _buildImage()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.category,
                      style: const TextStyle(fontSize: 12, color: AppColors.textoSuave)),
                  const SizedBox(height: 2),
                  Text(product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text(formatBRL(product.price),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.ambar)),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                      label: const Text('Adicionar'),
                      onPressed: () {
                        cart.add(product);
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text('${product.name} no carrinho'),
                            duration: const Duration(seconds: 1),
                          ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mostra a imagem do produto. Se o arquivo não for encontrado,
  /// mostra o fundo colorido com ícone (errorBuilder).
  Widget _buildImage() {
    final placeholder = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [product.tone, AppColors.carvao],
        ),
      ),
      child: Center(child: Icon(product.icon, size: 64, color: Colors.white70)),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        if (product.imageAsset != null)
          Image.asset(
            product.imageAsset!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => placeholder,
          )
        else
          placeholder,
        if (product.badge != null)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.ambar, borderRadius: BorderRadius.circular(20)),
              child: Text(product.badge!,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.carvao)),
            ),
          ),
      ],
    );
  }
}