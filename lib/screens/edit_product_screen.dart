import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/editProduct";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _editedProduct =
      Product(imageUrl: "", description: "", title: "", price: 0, id: "");

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Title cannot be null";
                    }
                    if (value.isEmpty) {
                      return "Title cannot be empty";
                    }
                    // if no error found, return null that means validation passed
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      title: value == null ? "" : value,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Price cannot be null";
                    }
                    if (value.isEmpty) {
                      return "Price cannot be empty";
                    }
                    // if no error found, return null that means validation passed
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                      title: _editedProduct.title,
                      price: double.parse(value == null ? "0" : value),
                      id: _editedProduct.id,
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value == null) {
                      return "Description cannot be null";
                    }
                    if (value.isEmpty) {
                      return "Description cannot be empty";
                    }
                    // if no error found, return null that means validation passed
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      imageUrl: _editedProduct.imageUrl,
                      description: value == null ? "" : value,
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      id: _editedProduct.id,
                    );
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        focusNode: _imageUrlFocusNode,
                        decoration: InputDecoration(
                          labelText: "Image URL",
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onFieldSubmitted: (_) => _saveForm(),
                        validator: (value) {
                          if (value == null) {
                            return "URL cannot be null";
                          }
                          if (value.isEmpty) {
                            return "URL cannot be empty";
                          }
                          // if no error found, return null that means validation passed
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            imageUrl: value == null ? "" : value,
                            description: _editedProduct.description,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            id: _editedProduct.id,
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
