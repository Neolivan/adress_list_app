import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController sController;

  SearchBarCustom(this.sController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: sController,
        decoration: InputDecoration(
          hintText: 'Buscar...',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
