import 'package:flutter/material.dart';
import 'package:souqna_app/Scoped-Model/main.dart';
import './Product_edit.dart';
//import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductList extends StatefulWidget {
  final MainModel model;
  ProductList({Key key, this.model}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
//   final List<Product> products;
// // int indx= products[index]
//   final Function updateProduct;
//   final Function deleteProduct;
  // ProducList(this.products, this.updateProduct, this.deleteProduct);
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  // model = widget.model;
  Widget _pageContent(model) {
    return ListView.builder(
        itemCount: model.allProducts.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allProducts[index].title),
            background: Container(
                color: Colors.red[900],
                child: Center(
                    child: Text('Delete  ${model.allProducts[index].title}'))),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                model.selectedIndex(index);
                model.deleteProduct();
                Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("${model.allProducts[index].title} dismissed")));
              }
              if (direction == DismissDirection.startToEnd) {
                model.selectedIndex(index);
                model.deleteProduct();
                
                Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("${model.allProducts[index].title} dismissed")));
              }

              // Scaffold.of(context).showSnackBar(SnackBar(
              //     content: Text("${products[index]['title']} dismissed")));
            },
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white70.withOpacity(0.7),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(model.allProducts[index].image)),
                        title: Text(model.allProducts[index].title),
                        subtitle: Text(
                            "\$${model.allProducts[index].price.toString()}"),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            model.selectedIndex(index);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return ProductEdit();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      // ListTile(
                      //   //leading: Image.asset(products[index]['image']),
                      //   title: Text(products[index]['title']),
                      //   subtitle: Text(products[index]['discription']),
                      //   trailing: IconButton(
                      //     icon: Icon(Icons.edit),
                      //     onPressed: () {
                      //       Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (BuildContext context) {
                      //           return ProductEdit(
                      //             products: products[index],
                      //             updateProduct: updateProduct,
                      //             productIndex: index,
                      //           );
                      //           //.push(context, '/edit');
                      //         },
                      //       ));
                      //     },
                      //   ),
                      // ),

                      // Image.asset(products[index]['image']),
                    ],
                  ),
                ),
                // Divider(
                //   color: Colors.black,
                //   // Theme.of(context).primaryColor,
                // )
              ],
            ),
          );
        });
  }

  Widget _pageFunc(MainModel model) {
    Widget content;
    if (model.products.length > 0 || !model.isFetching) {
      content = _pageContent(model);
    } else if (model.products.length == 0) {
      content = Center(child: Text("There is no Products !"));
    } else if (model.isFetching) {
      content = Center(
          child: Padding(
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColorDark,
              )));
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          backgroundColor: Colors.blueGrey[200],
          body: model.isLoading
              ? Center(child: CircularProgressIndicator())
              : _pageFunc(model));
    });
  }
}
