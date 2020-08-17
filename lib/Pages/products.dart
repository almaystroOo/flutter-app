import 'package:flutter/material.dart';
import 'package:souqna_app/Scoped-Model/main.dart';
import '../widgets/products/products.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';

//ProductsPage(this.products, this.addProduct);
class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage({Key key, this.model}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            //leading: ,
            title: Text("Chose from Menue"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("mange products "),
            onTap: () => Navigator.pushReplacementNamed(context, '/admin'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: _drawer(context),
        appBar: AppBar(
          title: Text(
            "Product List",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                    icon: model.displayFavoriteOnly
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    color: Colors.red,
                    onPressed: () {
                      model.toggleDispalyMode();
                    });
              },
            )
          ],
        ),
        backgroundColor: Colors.blueGrey[200],
        body: Column(
          children: [
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                Widget pageContent;
                Widget _pageProssing() {
                  if (model.products.length > 0 || !model.isFetching) {
                    pageContent = Products();
                  } else if (model.products.length == 0 && !model.isFetching) {
                    pageContent = Center(
                        child:
                            Text('There is no products , please add some !'));
                  } else if (model.isFetching) {
                    pageContent = Center(
                        child: Padding(
                            padding: EdgeInsets.all(50),
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                            )));
                  }
                  return RefreshIndicator(
                      child: pageContent, onRefresh: model.fetchProducts);
                }

                return model.isLoading
                    ? Center(
                        child: Padding(
                            padding: EdgeInsets.all(50),
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                            )))
                    : Expanded(child: _pageProssing());
              },
            ),
          ],
        )
        //ListView(children : [ ProductManger('food tester')],),

        );
  }
}
