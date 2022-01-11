import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String? title;
  final String? imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title as String),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl
            as String), // NetworkImage get the object not build a new widget
      ),
      trailing: Container(
        // trailing limit the row and without Container, there are unlimit width
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id!);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                      content: Text(
                    'Deleting failed',
                    textAlign: TextAlign.center,
                  ))); //using scaffold as widget tree is updating and flutter is not sure which
                  //widget tree to use
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
