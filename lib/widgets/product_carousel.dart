import 'dart:async';
import 'dart:ui' show PointerDeviceKind;
import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/utils.dart';
import '../data/products_data.dart';
import '../models/product.dart';

/// Carrossel com as imagens dos produtos (copao_01 a copao_06).
/// - Celular: 1 imagem por vez (arraste com o dedo)
/// - Web/desktop: 3 imagens por vez (setas ou arrastar com o mouse)
/// - Passa sozinho a cada 4 segundos
class ProductCarousel extends StatelessWidget {
  const ProductCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder entrega a largura disponível -> define quantas imagens aparecem.
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final fraction = w > 900 ? 0.33 : (w > 600 ? 0.5 : 0.85);
      final height = w > 900 ? 300.0 : 240.0;
      // A key força recriar o carrossel quando a quantidade por tela muda.
      return _CarouselView(key: ValueKey(fraction), fraction: fraction, height: height);
    });
  }
}

class _CarouselView extends StatefulWidget {
  final double fraction; // fatia da largura que cada imagem ocupa
  final double height;
  const _CarouselView({super.key, required this.fraction, required this.height});

  @override
  State<_CarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<_CarouselView> {
  // Só os produtos que têm imagem
  late final List<Product> _items =
      products.where((p) => p.imageAsset != null).toList();
  late final PageController _controller;
  late int _page;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Começamos "no meio" de um número grande para poder voltar e avançar
    // sem fim (efeito de carrossel infinito).
    _page = _items.length * 1000;
    _controller = PageController(
      viewportFraction: widget.fraction,
      initialPage: _page,
    );
    // Timer: a cada 4 segundos vai para a próxima imagem.
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => _go(_page + 1));
  }

  void _go(int page) {
    if (!_controller.hasClients) return;
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // Sempre cancele timers e controllers ao sair da tela.
  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    final current = _page % _items.length;

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Na web o mouse não arrasta por padrão; aqui liberamos.
              ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                ),
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) =>
                      _Slide(product: _items[i % _items.length]),
                ),
              ),
              Positioned(
                left: 8,
                top: 0,
                bottom: 0,
                child: Center(child: _Arrow(icon: Icons.chevron_left, onTap: () => _go(_page - 1))),
              ),
              Positioned(
                right: 8,
                top: 0,
                bottom: 0,
                child: Center(child: _Arrow(icon: Icons.chevron_right, onTap: () => _go(_page + 1))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Bolinhas indicando a imagem atual
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (i) {
            final active = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? AppColors.ambar : AppColors.textoSuave.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

/// Uma imagem do carrossel com nome e preço sobre um degradê escuro.
class _Slide extends StatelessWidget {
  final Product product;
  const _Slide({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              product.imageAsset!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: product.tone,
                child: Center(child: Icon(product.icon, size: 64, color: Colors.white70)),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    Text(formatBRL(product.price),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.ambar)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botão redondo de seta (anterior / próximo).
class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Arrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        iconSize: 26,
      ),
    );
  }
}