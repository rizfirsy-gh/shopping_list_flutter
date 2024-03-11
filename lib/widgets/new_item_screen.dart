import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';

import '../models/grocery_item.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  var _titleState = '';
  var _quantityState = 1;
  var _categoryState = categories[Categories.vegetables]!;

  void _saveState() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.of(context).pop(
        GroceryItem(
            id: DateTime.now().toString(),
            name: _titleState,
            quantity: _quantityState,
            category: _categoryState),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new item")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Title")),
                maxLength: 50,
                autofocus: true,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 3 ||
                      value.trim().length > 50) {
                    return "Gaboleh kosong anjay";
                  }
                  return null;
                },
                onChanged: (value) {
                  _titleState = value;
                },
                initialValue: _titleState,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(label: Text("Quantity")),
                      initialValue: _quantityState.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be valid positif number.";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _quantityState = int.parse(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _categoryState,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(width: 24),
                                  Text(category.value.title)
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          _categoryState = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: _saveState,
                    child: const Text('Add'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
