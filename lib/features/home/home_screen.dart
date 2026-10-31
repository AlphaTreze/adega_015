import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../data/products_data.dart';
import '../../state/cart_controller.dart';
import '../../widgets/adega_logo.dart';
import '../../widgets/cart_sheet.dart';
import '../../widgets/footer_section.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_carousel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 600;
    // Em telas muito largas, centraliza o conteúdo com no máx. 1200px.
    final sidePadding = width > 1232 ? (width - 1200) / 2 : 16.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ===== TOPO: logo + "Comprar online" + carrinho =====
          SliverAppBar(
            pinned: true,
            toolbarHeight: 64,
            title: const AdegaLogo(),
            actions: [
              if (isWide)
                FilledButton.icon(
                  onPressed: () => CartSheet.show(context),
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text('Comprar online'),
                ),
              ListenableBuilder(
                listenable: cart,
                builder: (context, _) => IconButton(
                  tooltip: 'Carrinho',
                  onPressed: () => CartSheet.show(context),
                  icon: Badge(
                    isLabelVisible: cart.totalItems > 0,
                    label: Text('${cart.totalItems}'),
                    child: const Icon(Icons.shopping_cart_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ===== BANNER =====
          SliverToBoxAdapter(child: _Hero(sidePadding: sidePadding)),

          // ===== CARROSSEL =====
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding),
            sliver: const SliverToBoxAdapter(child: ProductCarousel()),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 28)),

          // ===== TÍTULO DA VITRINE =====
          SliverPadding(
            padding: EdgeInsets.fromLTRB(sidePadding, 8, sidePadding, 12),
            sliver: const SliverToBoxAdapter(
              child: Text('Ofertas da semana',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            ),
          ),

          // ===== GRID DE PRODUTOS (responsivo) =====
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: sidePadding, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisExtent: 340,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ProductCard(product: products[i]),
                childCount: products.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // ===== RODAPÉ =====
          const SliverToBoxAdapter(child: FooterSection()),
        ],
      ),
    );
  }
}

/// Banner objetivo: título + uma frase.
class _Hero extends StatelessWidget {
  final double sidePadding;
  const _Hero({required this.sidePadding});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.fromLTRB(sidePadding, 8, sidePadding, 20),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: isWide ? 36 : 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.bordo, AppColors.carvao],
          ),
          border: Border.all(color: AppColors.ambar.withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gelado na sua porta.',
              style: TextStyle(
                fontSize: isWide ? 44 : 32,
                height: 1.1,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Peça já seu copão ou drink e receba na comodidade da sua casa.',
              style: TextStyle(
                fontSize: isWide ? 18 : 16,
                color: AppColors.textoSuave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}