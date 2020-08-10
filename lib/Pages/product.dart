import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/ui_elements/default_title.dart';
import '.././Scoped-Model/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);
  _showDialogeAlert(BuildContext context, String title, MainModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are you sure you want to delete $title!?"),
            content: Text("This action cannot be undone !"),
            actions: <Widget>[
              Container(
                alignment: Alignment.bottomLeft,
                child: FlatButton(
                  child: Text(
                    'Ignore',
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              FlatButton(
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.black),
                ),
                color: Colors.red,
                onPressed: () {
                  model.deleteProduct();
                  Navigator.of(context).pushNamed('/home');
                  //Navigator.pop(context);
                  //  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //Navigator.pop(context,false);
        return Future.value(true);
      }, //ScopedModelDescendant
      child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                model.allProducts[productIndex].title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              // backgroundColor: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.blueGrey[200],
            body:
                //  Card(
                //   child:
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Card(
                        child: Image.network(
                            model.allProducts[productIndex].image))),
                DefaultTitle(model.allProducts[productIndex].title),
                // Text('Product ' + title + ' page details '),
                Text("discription :" +
                    model.allProducts[productIndex].discription),
                Text("The Price : " +
                    model.allProducts[productIndex].price.toString()),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: () => _showDialogeAlert(
                        context, model.allProducts[productIndex].title, model),
                    child: Text(
                      "Delete",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
