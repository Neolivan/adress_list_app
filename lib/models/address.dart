//Classe Address com define seus respctivos parametros
class Address {
  int? id;
  String street;
  String city;
  String state;
  String zipCode;

//Construtor da classe
  Address(
      {this.id,
      required this.street,
      required this.city,
      required this.state,
      required this.zipCode});

  // Convert Address to Map, metodos usados para tratamento dos dados da base
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
    };
  }

  // Convert Map to Address, metodos usados para tratamento dos dados da base
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      street: map['street'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zipCode'],
    );
  }
}
