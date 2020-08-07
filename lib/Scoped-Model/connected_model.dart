import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import './Products.dart';
// import './user_model.dart';

class ConnectedModel extends Model {
  List<Product> products = [];
  int selectedProductIndex;
  User authedUser;
  String id;
  bool _isLoading = false;

  //add product method
  Future<Null> addProduct(
    String title,
    String discription,
    String image,
    double price,
  ) {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> _product = {
      'title': title,
      'discription': discription,
      'image': 'https://cdn.mos.cms.futurecdn.net/4XxfGsFJ9jCbrWtHHceBoa.jpg',
      'price': price,
      'email': authedUser.email
    };

    return http
        .post('https://flutter-product-2020.firebaseio.com/products.json',
            body: json.encode(_product))
        .then((http.Response response) {
      Map<String, dynamic> responseData = json.decode(response.body);
      id = responseData['name'];
      Product productData = Product(
        title: title,
        discription: discription,
        image: image,
        price: price,
        id: responseData['name'],
        email: authedUser.email,
      );
      products.add(productData);
      selectedProductIndex = null;
      _isLoading = false;
      notifyListeners();
    });
  }
}

// product model here >>>
class ProductsModel extends ConnectedModel {
  //final List<Product> products = [];
  // int selectedProductIndex;
  bool _showFavorites = false;

  List<Product> get allProducts => List.from(products);
  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    } else {
      return List.from(products);
    }
  }

  int get selectedProductsIndexId => selectedProductIndex;

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  bool get displayFavoriteOnly {
    return _showFavorites;
  }

  bool get isLoading {
    return _isLoading;
  }

  void updateProduct(
    String title,
    String discription,
    String image,
    double price,
  ) {
    Product updatedProduct = Product(
      title: title,
      discription: discription,
      image: image,
      price: price,
      id: id,
      email: authedUser.email,
    );
    products[selectedProductIndex] = updatedProduct;
    id = null;
    notifyListeners();

    //_products.insert(product);
  }

  void fetchProducts() {
    _isLoading = true;
    notifyListeners();
    http
        .get('https://flutter-product-2020.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedList = [];
      final Map<String, dynamic> decodedData = json.decode(response.body);
      decodedData.forEach((String key, dynamic value) {
        Product fetchedProduct = Product(
            title: value['title'],
            discription: value['discription'],
            price: value['price'],
            image: value['image'],
            id: key,
            email: value['email']);
        fetchedList.add(fetchedProduct);
        _isLoading = false;
        notifyListeners();
      });
      products = fetchedList;
    });
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
  }

  void toggleProductFavoriteStatus() {
    final currentStatus = selectedProduct.isFavorite;
    final newStatus = !currentStatus;
    products[selectedProductIndex] = Product(
        title: selectedProduct.title,
        discription: selectedProduct.discription,
        image: selectedProduct.image,
        price: selectedProduct.price,
        id: selectedProduct.id,
        email: selectedProduct.email,
        isFavorite: newStatus);

    notifyListeners();
  }

  void toggleDispalyMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectedIndex(int index) {
    selectedProductIndex = index;
  }
}

// user model here down >>
class UserModel extends ConnectedModel {
  // User authedUser;

  void logIn(String email, String password) {
    authedUser = User(id: null, email: email, password: password);
    print(authedUser);
  }
}
