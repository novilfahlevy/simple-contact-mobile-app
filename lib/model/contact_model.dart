class Contact {
  static int incrementId = 5;

  final int id;
  String name;
  String phone;

  Contact({ required this.id, required this.name, required this.phone });

  factory Contact.fromMap(Map<String, dynamic> contact) => Contact(
    id: contact['id'],
    name: contact['name'],
    phone: contact['phone']
  );
}