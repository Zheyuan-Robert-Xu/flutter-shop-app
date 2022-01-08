import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //runs before build is executed
    // TODO: implement didChangeDependencies
    if (_isInit) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        //lick the + button at the user product screen it displays
        //this issue type 'Null' is not a subtype of type 'String' in type cast
        final productId = ModalRoute.of(context)!.settings.arguments
            as String; //read the arguments by ModalRoute.of(context)
        if (productId != null) {
          _editedProduct =
              Provider.of<Products>(context, listen: false).findById(productId);
          _initValues = {
            'title': _editedProduct.title as String,
            'description': _editedProduct.description as String,
            'price': _editedProduct.price.toString(),
            // 'imageUrl': _editedProduct.imageUrl as String,
            'imageUrl':
                '', //for the imageUrl and controller cannot be used at the same time
          };
          _imageUrlController.text = _editedProduct.imageUrl!;
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // free up memory and avoid memory leak
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    // do not have a preview if do not a valid URL
    // if lose focus, like click other fields
    if (_imageUrlController.text.isEmpty ||
            (!_imageUrlController.text.startsWith('http') &&
                !_imageUrlController.text.startsWith('https'))
        // (!_imageUrlController.text.endsWith('.png') &&
        //     !_imageUrlController.text.endsWith('.jpg') &&
        //     !_imageUrlController.text.endsWith('.jpeg'))
        ) {
      return;
    }

    setState(() {});
  }

  void _saveForm() {
    final isValid = _form.currentState!
        .validate(); //trigger all the validators return true if raise no errors
    if (!isValid) {
      //cancels the function execution or stops the function execution
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      //existing _editedProduct
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id as String, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form, //using key to pass value between widgets
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                      _priceFocusNode); //when this form is submitted, it automatically moves to the price form
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  }
                  return null; // means raise no error
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: value,
                      description: _editedProduct.description,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ), // TextFormField does not have onchange
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(
                      _descriptionFocusNode); //when this form is submitted, it automatically moves to the price form
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null; // means raise no error
                },
                onSaved: (value) {
                  // value is the input value
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null; // means raise no error
                },
                onSaved: (value) {
                  _editedProduct = Product(
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                      title: _editedProduct.title,
                      description: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment
                    .end, //make the Url inputer to the bottom of the line
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    //TextFormField take as much width as possible and Row has no constraints, which will raise errors
                    child: TextFormField(
                      // initialValue: _initValues['imageUrl'],// cannot use both controller and initialvalue
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller:
                          _imageUrlController, // get the value before submitting the value
                      // onEditingComplete: () {
                      //   setState(() {});
                      // },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter an valid URL.';
                        }
                        // if (!value.endsWith('.png') &&
                        //     !value.endsWith('.jpg') &&
                        //     !value.endsWith('.jpeg')) {
                        //   return 'Please enter an valid image URL.';
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: value);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
