import 'package:flutter/material.dart';

class Product {
  final String title;
  final String discription;
  final double price;
  final String image;
  final bool isFavorite;
  final String id;
  final String email;

  Product(
      {@required this.title,
      @required this.discription,
      @required this.price,
      @required this.image,
      @required this.id,
      @required this.email,
      this.isFavorite = false});
}
