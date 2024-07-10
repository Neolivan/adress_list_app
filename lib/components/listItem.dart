import 'package:adress_list_app/db/database_helper.dart';
import 'package:adress_list_app/models/address.dart';
import 'package:adress_list_app/views/addEditAddressScreen.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Address address;
  final void Function() callBackOnSave;
  final BuildContext context;

  ListItem(this.address, this.callBackOnSave, this.context);

  void _confirmDelete(Address address) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text('Você tem certeza que deseja excluir este endereço?'),
          actions: [
            TextButton(
              child: Text('Cancelar',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Excluir',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                DatabaseHelper().deleteAddress(address.id!).then((_) {
                  callBackOnSave();
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(address.street),
        subtitle: Text('${address.city}, ${address.state} ${address.zipCode}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.blue[400],
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddEditAddressScreen(
                      address: address,
                      onSave: callBackOnSave,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red[800],
              onPressed: () => _confirmDelete(address),
            ),
          ],
        ),
      ),
    );
  }
}
