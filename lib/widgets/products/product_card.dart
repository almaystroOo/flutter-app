import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/default_title.dart';
import './address_tag.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../Scoped-Model/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productindex;
  final String address = " Sudan,Khartoum - Kalakla  ";
  ProductCard(this.product, this.productindex);
  Widget _buildImage() {
    return Image.network(product.image);
  }

  void _buildDetails(BuildContext context) {
    Navigator.pushNamed<bool>(context, '/product/' + productindex.toString());
  }

  // Widget _buildFav(BuildContext context, bool isFavorite) {}
  Widget _bulidTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: DefaultTitle(product.title),
        ),
        SizedBox(
          width: 15.0,
        ),
        PriceTag(product.price),
      ],
    );
  }

  Widget _buildButtonBar(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Theme.of(context).accentColor,
          onPressed: () => _buildDetails(context),
          child: Text('Details'),
        ),
        ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
          return IconButton(
              icon: Icon(model.allProducts[productindex].isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.selectedIndex(productindex);
                model.toggleProductFavoriteStatus();
              }
              //   _buildFav(context, model.allProducts[productindex].isFavorite),
              );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: <Widget>[
          _buildImage(),
          SizedBox(
            height: 10.0,
          ),
          _bulidTitleAndPrice(),
          AddressTag(address),
          Text(product.email),
          Text(product.id),
          _buildButtonBar(context),
        ],
      ),
    );
  }
}
