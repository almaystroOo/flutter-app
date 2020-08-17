//import 'dart:ffi';

import 'package:flutter/material.dart';
//import 'package:souqna_app/widgets/products/Products.dart';
//import './Product_list.dart';
import '../models/product.dart';
import '.././Scoped-Model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductEdit extends StatefulWidget {
  // final Product products;
  // final Function updateProduct;
  // final Function addProduct;
  // final int productIndex;
  // ProductEdit(
  //     {this.addProduct, this.updateProduct, this.products, this.productIndex});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductEditState();
  }
}

class _ProductEditState extends State<ProductEdit> {
  // String title;
  // String discriptionValue;
  // double price = 0.0;
  final Map<String, dynamic> _formData = {
    'title': '',
    'discription': '',
    'price': 0,
  };
  final GlobalKey<FormState> _createForm = GlobalKey<FormState>();

  Widget _buildTitleField(Product products) {
    return TextFormField(
      //controller: _ageController,
      initialValue: products == null ? '' : products.title,
      validator: (String value) {
        if (value.isEmpty) {
          return 'required';
        }
      },
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        labelText: "Product title :",
        hintText: "Enter the product title  ",
        icon: new Icon(Icons.view_headline),
        labelStyle: TextStyle(
          decorationColor: Colors.blueGrey,
        ),
      ),
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDiscriptionField(Product products) {
    return TextFormField(
//controller: _ageController,
      initialValue: products == null ? '' : products.discription,
      validator: (String value) {
        if (!value.isNotEmpty) {
          return 'required';
        }
      },
      onSaved: (String value) {
        _formData['discription'] = value;
      },
      keyboardType: TextInputType.text,
      decoration: new InputDecoration(
        labelText: "Product discription  :",
        hintText: "Enter product discription  ",
        icon: new Icon(Icons.assignment),
        labelStyle: TextStyle(
          decorationColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildPriceField(Product products) {
    return TextFormField(
      //controller: _ageController,
      initialValue: products == null ? '' : products.price.toString(),
      validator: (String value) {
        if (!value.isNotEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'required only in numbers';
        }
      },

      onSaved: (value) {
        _formData['price'] = double.parse(value);
      },
      keyboardType: TextInputType.numberWithOptions(),
      decoration: new InputDecoration(
        labelText: "Product price :",
        hintText: "Enter the prouduct price  ",
        icon: new Icon(Icons.confirmation_number),
        labelStyle: TextStyle(
          decorationColor: Colors.blueGrey,
        ),
      ),
    );
  }

  // Widget _createButton() {
  //   return RaisedButton(
  //     color: Theme.of(context).accentColor,
  //     onPressed: _submitform,
  //     child: Text("Create"),
  //   );
  // }
//      Widget _updateButton(addProduct, updateProduct) {
//        return ScopedModelDescendant(builder: (context, child, model) {
// return

//      });}
  Widget _updateButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                color: Theme.of(context).accentColor,
                onPressed: () => _submitform(
                    model.addProduct,
                    model.updateProduct,
                    model.selectedId,
                    model.selectedProductIndex),
                child: model.selectedProduct == null
                    ? Text("Create")
                    : Text("Update"),
              );
      },
    );
  }

  // void _submitform(Function addProduct, Function updateProduct) {
  //   if (!_createForm.currentState.validate()) {
  //     return;
  //   }
  //   _createForm.currentState.save();
  //   if (widget.products == null) {
  //     addProduct(Product(
  //         title: _formData['title'],
  //         discription: _formData['discription'],
  //         image: _formData['image'],
  //         price: _formData['price']));
  //     // );
  //   } else {
  //     updateProduct(
  //         widget.productIndex,
  //         Product(
  //             title: _formData['title'],
  //             discription: _formData['discription'],
  //             image: _formData['image'],
  //             price: _formData['price']));
  //     //     );
  //   }

  //   Navigator.pushReplacementNamed(context, '/products');
  // }
  void _submitform(
      Function addProduct, Function updateProduct, Function selectedId,
      [int selectedProductIndex]) {
    if (!_createForm.currentState.validate()) {
      return;
    }
    _createForm.currentState.save();
    if (selectedProductIndex == -1) {
      addProduct(_formData['title'], _formData['discription'],
              _formData['image'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, '/hom')
              .then((_) => selectedId(null)));
      // Navigator.pushReplacementNamed(context, '/hom');
    } else {
      print(_formData);
      updateProduct(
              _formData['title'], _formData['discription'], _formData['price'])
          .then((_) => Navigator.pushReplacementNamed(context, '/hom')
              .then((_) => selectedId(null)));
      // Navigator.pushReplacementNamed(context, '/edit');
    }

    //of(context).pop(MaterialPageRoute(
    //   builder: (BuildContext context){
    //     return ProducList(products, updateProduct)});
  }

  _pageContent(BuildContext context, Product product) {
    final double width = MediaQuery.of(context).size.width;
    final double targetWidth = width > 550.0 ? 500 : width * 0.98;
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Container(
        width: targetWidth,
        margin: EdgeInsets.only(left: 5.0),
        child: Form(
          key: _createForm,
          child: ListView(
            shrinkWrap: true,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitleField(product),
              _buildDiscriptionField(product),
              _buildPriceField(product),
              SizedBox(
                height: 10.0,
                //width: 2.0,
              ),
              _updateButton(),
              // ScopedModelDescendant(
              //   builder: (BuildContext context, Widget child, MainModel model) {
              //     return model.isLoading
              //        ? Center(child: CircularProgressIndicator())
              //         : ;
              //   },
              // )

              // TextField(
              //   onChanged: (String value)=>{
              //  setState((){
              //      title=value;
              //  })
              //   },
              // ),
              //  Text(title),
              //   Text(price.toString()),//Center(
              //     child: RaisedButton(
              //   child: Text("Save"),
              //   onPressed: () {
              //     showBottomSheet(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return Center(child: Text(" thie bottom view space "));
              //         });
              //   },
              // )),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      final Widget pageContent = _pageContent(context, model.selectedProduct);
      return model.selectedProductIndex == -1
          ? pageContent
          : WillPopScope(
              onWillPop: () {
                model.selectedId(null);
                Navigator.pushReplacementNamed(context, '/admin');
              },
              child: Scaffold(
                  appBar: new AppBar(
                    title: Text(
                      "Product Edit",
                      // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Colors.blueGrey[200],
                  body: pageContent),
            );
    });
  }
}
