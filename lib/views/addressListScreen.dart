import 'package:adress_list_app/components/listItem.dart';
import 'package:adress_list_app/components/searchBarCustom.dart';
import 'package:adress_list_app/db/database_helper.dart';
import 'package:adress_list_app/models/address.dart';
import 'package:adress_list_app/views/addEditAddressScreen.dart';
import 'package:flutter/material.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Future<List<Address>> _addressList;
  String _searchQuery = "";
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshAddressList();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _refreshAddressList() {
    setState(() {
      _addressList = DatabaseHelper().getAddresses();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Address> _filterAddresses(List<Address> addresses) {
    if (_searchQuery.isEmpty) {
      return addresses;
    } else {
      return addresses.where((address) {
        return address.street
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            address.city.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            address.state.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            address.zipCode.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Endereços',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SearchBarCustom(_searchController),
          Expanded(
            child: FutureBuilder<List<Address>>(
              future: _addressList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum endereço encontrado.'));
                } else {
                  var filteredAddresses = _filterAddresses(snapshot.data!);
                  return ListView.builder(
                    itemCount: filteredAddresses.length,
                    itemBuilder: (context, index) {
                      final address = filteredAddresses[index];
                      return ListItem(address, _refreshAddressList, context);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) =>
                    AddEditAddressScreen(onSave: _refreshAddressList)),
          );
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
