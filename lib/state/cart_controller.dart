import 'package:flutter/foundation.dart';
import '../models/product.dart';

/// Estado do carrinho. ChangeNotifier avisa quem está "ouvindo" sempre que
/// chamamos notifyListeners() -> as telas se redesenham sozinhas.
class CartController extends ChangeNotifier {
  // Mapa: produto -> quantidade
  final Map<Product, int> _items = {};

  Map<Product, int> get items => Map.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  /// Soma todas as quantidades (número exibido na bolinha do carrinho).
  int get totalItems => _items.values.fold(0, (a, b) => a + b);

  double get totalPrice =>
      _items.entries.fold(0.0, (sum, e) => sum + e.key.price * e.value);

  void add(Product p) {
    _items[p] = (_items[p] ?? 0) + 1; // "??" = se for nulo, use 0
    notifyListeners();
  }

  void remove(Product p) {
    final qty = _items[p];
    if (qty == null) return;
    if (qty <= 1) {
      _items.remove(p);
    } else {
      _items[p] = qty - 1;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Uma única instância compartilhada pelo app inteiro.
/// (Simples para aprender. Em apps maiores usa-se Provider/Riverpod.)
final cart = CartController();
