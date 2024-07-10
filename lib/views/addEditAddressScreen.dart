import 'package:adress_list_app/db/database_helper.dart';
import 'package:adress_list_app/models/address.dart';
import 'package:flutter/material.dart';

class AddEditAddressScreen extends StatefulWidget {
  final Address? address;
  final VoidCallback onSave;

  AddEditAddressScreen({this.address, required this.onSave});

  @override
  _AddEditAddressScreenState createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!.street;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipCodeController.text = widget.address!.zipCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.address == null ? 'Adicionar Endereço' : 'Editar Endereço'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Rua'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a rua';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Cidade'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a cidade';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o estado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipCodeController,
                decoration: InputDecoration(labelText: 'CEP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CEP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Address newAddress = Address(
                      id: widget.address?.id,
                      street: _streetController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      zipCode: _zipCodeController.text,
                    );
                    if (widget.address == null) {
                      DatabaseHelper().insertAddress(newAddress).then((_) {
                        widget.onSave();
                        Navigator.of(context).pop();
                      });
                    } else {
                      DatabaseHelper().updateAddress(newAddress).then((_) {
                        widget.onSave();
                        Navigator.of(context).pop();
                      });
                    }
                  }
                },
                child: Text(widget.address == null ? 'Salvar' : 'Atualizar',
                    style: TextStyle(fontSize: 20)),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll<Color>(Colors.black),
                    foregroundColor:
                        WidgetStatePropertyAll<Color>(Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
