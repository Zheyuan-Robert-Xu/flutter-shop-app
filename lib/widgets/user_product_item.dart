import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String? title;
  final String? imageUrl;

  UserProductItem(this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {},
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
