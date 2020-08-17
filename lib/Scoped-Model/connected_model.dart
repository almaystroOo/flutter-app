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
  String selectedProductId;
  User authedUser;
  String id;
  bool _isFetching = false;
  bool _isLoading = false;

  //add product method
  Future<Null> addProduct(
    String title,
    String discription,
    String image,
    double price,
  ) {
    _isFetching = true;
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
      selectedProductId = null;
      _isLoading = false;
      _isFetching = false;
      notifyListeners();
    });
  }
}

// product model here >>>
class ProductsModel extends ConnectedModel {
  //final List<Product> products = [];
  // int selectedProductIndex;
  bool _showFavorites = false;
  String image = 'https://cdn.mos.cms.futurecdn.net/4XxfGsFJ9jCbrWtHHceBoa.jpg';
  List<Product> get allProducts => List.from(products);
  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    } else {
      return List.from(products);
    }
  }

  String get selectedProductsId => selectedProductId;

  Product get selectedProduct {
    if (selectedProductsId == null) {
      return null;
    }
    return products
        .firstWhere((Product product) => product.id == selectedProductsId);
  }

  bool get displayFavoriteOnly {
    return _showFavorites;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get isFetching {
    return _isFetching;
  }

  int get selectedProductIndex {
    return products
        .indexWhere((Product product) => product.id == selectedProductsId);
  }

  void updateProduct(
    String title,
    String discription,
    //String image,
    double price,
  ) {
    _isFetching = true;
    _isLoading = true;

    notifyListeners();
    Map<String, dynamic> updatedProduct = {
      'title': title,
      'discription': discription,
      'id': selectedProduct.id,
      'image': image,
      'price': price,
      'userId': authedUser.id,
      'email': authedUser.email
    };
    http
        .put(
            'https://flutter-product-2020.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updatedProduct))
        .then((http.Response response) {
      if (response.statusCode == 200) {
        _isFetching = false;
        _isLoading = false;
      } else {
        throw (e) {};
      }

      notifyListeners();
    });
    Product updatedProductLocal = Product(
      title: title,
      discription: discription,
      image: image,
      price: price,
      id: selectedProduct.id,
      email: authedUser.email,
    );
    products[selectedProductIndex] = updatedProductLocal;
    id = null;
    notifyListeners();

    //_products.insert(product);
  }

  Future<void> fetchProducts() {
    _isFetching = true;
    notifyListeners();
    return http
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
        _isFetching = false;
        notifyListeners();
      });
      products = fetchedList;
    });
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    http
        .delete(
      'https://flutter-product-2020.firebaseio.com/products/${selectedProduct.id}.json',
      //body: json.encode(updatedProduct)
    )
        .then((http.Response response) {
      if (response.statusCode == 200) {
        _isFetching = false;
        _isLoading = false;
        notifyListeners();
      } else {
        throw (e) {};
      }

      notifyListeners();
    });
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

  void selectedId(String id) {
    selectedProductId = id;
    // notifyListeners();
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
