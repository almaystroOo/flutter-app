import 'package:flutter/material.dart';
import './product_card.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Scoped-Model/main.dart';

class Products extends StatelessWidget {
  // final String title = 'product details';
  // final String imgUrl = 'assets/bmi.jpg';
  // void _test(int index) => print(products[index]);

  Widget _buildCards(List<Product> products, bool isFavorite, MainModel model) {
    Widget productCard;
    if (products.length > 0) {
      productCard = ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return ProductCard(products[index], index);
        },
      );
    } else {
      productCard = Center(
        child: isFavorite
            ? Text("Please like some products ")
            : Text("Please Add some products "),
      );
    }
    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildCards(
            model.displayedProducts, model.displayFavoriteOnly, model);
      },
    );
  }
}
// return products.length > 0 ?

// (BuildContext context, int index) {
//   return Card(
//     child: Column(
//       children: <Widget>[
//         Image.asset('assets/bmi.jpg'),
//         Text(products[index])
//       ],
//     ),
//   );
//  }

//,

//: Center(child : Text(" add some product"));
//   children: products
//       .map(
//         (element) =>
//       )
//       .toList(),
