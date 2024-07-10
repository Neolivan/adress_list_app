import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/address.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  //Verifica se a base de dados existe caso sim, retorna os registros, caso não chama a função que inicia a base de dados.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  //Função para iniciar a base de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'address_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE addresses(id INTEGER PRIMARY KEY AUTOINCREMENT, street TEXT, city TEXT, state TEXT, zipCode TEXT)',
        );
      },
    );
  }

  //função para buscar a base de dados completa
  Future<List<Address>> getAddresses() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('addresses');
    return List.generate(maps.length, (i) {
      return Address.fromMap(maps[i]);
    });
  }

  //Função para inserir um endereço
  Future<int> insertAddress(Address address) async {
    Database db = await database;
    return await db.insert('addresses', address.toMap());
  }

  //Função para atualizar um registro
  Future<int> updateAddress(Address address) async {
    Database db = await database;
    return await db.update(
      'addresses',
      address.toMap(),
      where: 'id = ?',
      whereArgs: [address.id],
    );
  }

  //Função para excluir um registro
  Future<int> deleteAddress(int id) async {
    Database db = await database;
    return await db.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }
}
