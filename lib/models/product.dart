import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final IconData icon; // usado se a imagem falhar
  final Color tone;
  final String? imageAsset; // caminho da imagem dentro do app
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.icon,
    required this.tone,
    this.imageAsset,
    this.badge,
  });
}