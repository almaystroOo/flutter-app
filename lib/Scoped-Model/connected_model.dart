import 'dart:async';

//import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import '../models/user.dart';
//import 'package:http/http.dart' as http;
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
  Future<bool> addProduct(
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
      'email': authedUser.email,
      'isFavorite': false
    };

    return http
        .post('https://flutter-product-2020.firebaseio.com/products.json',
            body: json.encode(_product))
        .then((http.Response response) {
      print(response.statusCode);
      if (response.statusCode != 200) {
        _isLoading = false;
        _isFetching = false;
        selectedProductId = null;
        notifyListeners();
        return false;
      } else {
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
        print('added ');
        selectedProductId = null;
        _isLoading = false;
        _isFetching = false;
        notifyListeners();
        return true;
      }
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
    if (selectedProductId == null) {
      return null;
    }
    return products
        .firstWhere((Product product) => product.id == selectedProductId);
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

  Future<bool> updateProduct(
    String title,
    String discription,
    // String image,
    double price,
  ) {
    _isFetching = true;
    _isLoading = true;

    notifyListeners();
    Map<String, dynamic> updatedProduct = {
      'title': title,
      'discription': discription,
      'id': selectedProduct.id,
      'image': 'https://cdn.mos.cms.futurecdn.net/4XxfGsFJ9jCbrWtHHceBoa.jpg',
      'price': price,
      'userId': authedUser.id,
      'email': authedUser.email,
      'isFavorite': selectedProduct.isFavorite
    };
    return http
        .put(
            'https://flutter-product-2020.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updatedProduct))
        .then((http.Response response) {
      print('update stat :' + response.statusCode.toString());
      if (response.statusCode != 200) {
        _isFetching = false;
        _isLoading = false;
        selectedProductId = null;
        notifyListeners();
        return false;
      } else {
        print(response.body);
        _isFetching = false;
        _isLoading = false;
        Product updatedProductLocal = Product(
            title: title,
            discription: discription,
            image:
                'https://cdn.mos.cms.futurecdn.net/4XxfGsFJ9jCbrWtHHceBoa.jpg',
            price: price,
            id: selectedProduct.id,
            email: authedUser.email,
            isFavorite: selectedProduct.isFavorite);
        products[selectedProductIndex] = updatedProductLocal;
        selectedProductId = null;
        notifyListeners();
        return true;
        //_products.insert(product);

        // else {
        //   throw (e) {
        //     print(e);
        //   };
        // }
      }
    });
  }

  Future<bool> fetchProducts() {
    _isFetching = true;
    notifyListeners();
    return http
        .get('https://flutter-product-2020.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedList = [];
      print('fetch stat : ' + response.statusCode.toString());
      final Map<String, dynamic> decodedData = json.decode(response.body);
      if (decodedData == null || response.statusCode != 200) {
        print(response.statusCode);
        _isFetching = false;
        notifyListeners();
        return false;
      } else if (response.statusCode == 200) {
        decodedData.forEach((String key, dynamic value) {
          Product fetchedProduct = Product(
              isFavorite: value['isFavorite'],
              title: value['title'],
              discription: value['discription'],
              price: value['price'],
              image: value['image'],
              id: key,
              email: value['email']);
          fetchedList.add(fetchedProduct);
          _isFetching = false;
          print('fetch end ');
          notifyListeners();
        });
        products = fetchedList;
      }
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
        throw (e) {
          print(e);
        };
      }
      selectedProductId = null;
      notifyListeners();
    });
  }

  Future<Null> toggleProductFavoriteStatus() {
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

    Map<String, dynamic> toggledStatus = {
      'title': selectedProduct.title,
      'discription': selectedProduct.discription,
      'image': selectedProduct.image,
      'price': selectedProduct.price,
      'userId': authedUser.id,
      'email': authedUser.email,
      'isFavorite': newStatus,
    };

    _isLoading = true;
    notifyListeners();
    return http
        .put(
            'https://flutter-product-2020.firebaseio.com/products/${selectedProduct.id}.json',
            //products[selectedProductIndex]
            body: json.encode(toggledStatus))
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print(response.body);
        // _isFetching = false;
        _isLoading = false;
        selectedProductId = null;
        notifyListeners();
      } else {
        throw (e) {
          selectedProductId = null;
          print(e);
        };
      }
    });
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
