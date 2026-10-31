import 'package:flutter/material.dart';
import '../models/product.dart';

/// Cada produto aponta para uma imagem em assets/images/.
/// Ajuste nomes e preços para combinar com cada foto.
const List<Product> products = [
  Product(id: '1', name: 'Copão 01', category: 'Copões', price: 24.90, icon: Icons.local_bar, tone: Color(0xFF2F6F73), imageAsset: 'assets/images/copao_01.png', badge: 'Mais vendido'),
  Product(id: '2', name: 'Copão 02', category: 'Copões', price: 22.90, icon: Icons.local_bar, tone: Color(0xFF6B8E23), imageAsset: 'assets/images/copao_02.png'),
  Product(id: '3', name: 'Copão 03', category: 'Copões', price: 29.90, icon: Icons.local_bar, tone: Color(0xFF8A5A2B), imageAsset: 'assets/images/copao_03.png', badge: 'Premium'),
  Product(id: '4', name: 'Copão 04', category: 'Copões', price: 27.90, icon: Icons.local_bar, tone: Color(0xFFA63D2F), imageAsset: 'assets/images/copao_04.png'),
  Product(id: '5', name: 'Copão 05', category: 'Copões', price: 26.90, icon: Icons.bolt, tone: Color(0xFF3B5BA5), imageAsset: 'assets/images/copao_05.png'),
  Product(id: '6', name: 'Copão 06', category: 'Copões', price: 19.90, icon: Icons.sports_bar, tone: Color(0xFFB8741A), imageAsset: 'assets/images/copao_06.png', badge: 'Combo'),
  Product(id: '7', name: 'GELO SABORIZADO (CADA)', category: 'Copões', price: 6.50, icon: Icons.local_bar, tone: Color(0xFF2E7D4F), imageAsset: 'assets/images/copao_07.png'),
];