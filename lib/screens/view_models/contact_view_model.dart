import 'package:flutter/material.dart';
import 'package:coba_platform_widget/model/contact_model.dart';
import 'package:coba_platform_widget/model/api/contact_api.dart';

class ContactViewModel with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  Contact? _contact;
  Contact? get contact => _contact;

  final TextEditingController inputNameController = TextEditingController();
  final TextEditingController inputPhoneController = TextEditingController();

  bool isAddingContact = false;
  bool isEditingContact = false;
  bool isFetchingContact = true;
  int? deletingContactId;

  Future<void> getContacts() async {
    try {
      final ContactAPI api = ContactAPI();
      final List<Contact> contacts = await api.getContacts();
      
      _contacts = contacts;
      isFetchingContact = false;
      
      notifyListeners();
    } on Exception catch (e) {
      // TODO
      debugPrint(e.toString());
    }
  }

  Future<void> getContact(int id) async {
    isFetchingContact = true;
    notifyListeners();

    try {
      final ContactAPI api = ContactAPI();
      final Contact? contact = await api.getContact(id);
      
      if (contact != null) {
        _contact = contact;
      }
    } on Exception catch (e) {
      // TODO
      debugPrint(e.toString());

      _contact = _contacts.firstWhere((contact) => contact.id == id);
    }

    inputNameController.text = (_contact!).name;
    inputPhoneController.text = (_contact!).phone;

    isFetchingContact = false;
    notifyListeners();
  }

  Future<bool> add({
    required String name,
    required String phone,
  }) async {
    isAddingContact = true;
    notifyListeners();

    bool isAddContactSuccess = false;

    try {
      final ContactAPI api = ContactAPI();
      final Contact? contact = await api.addContact(name, phone);

      if (contact != null) {
        isAddContactSuccess = true;
        _contacts.add(contact);

        inputNameController.clear();
        inputPhoneController.clear();
      }
    } on Exception catch (e) {
      // TODO
      debugPrint(e.toString());
    }

    isAddingContact = false;
    notifyListeners();

    return isAddContactSuccess;
  }

  Future<bool> edit({
    required int id,
    required String name,
    required String phone,
  }) async {
    isEditingContact = true;
    notifyListeners();

    bool isEditContactSuccess = false;

    try {
      final ContactAPI api = ContactAPI();
      await api.editContact(id, name, phone);
    } on Exception catch (e) {
      // TODO
      debugPrint(e.toString());
    } finally {
      int index = _contacts.indexWhere((element) => element.id == id);
      _contacts[index].name = name;
      _contacts[index].phone = phone;

      isEditContactSuccess = true;

      inputNameController.clear();
      inputPhoneController.clear();
    }

    isEditingContact = false;
    notifyListeners();

    return isEditContactSuccess;
  }

  Future<bool> delete(final int id) async {
    deletingContactId = id;
    notifyListeners();

    try {
      final ContactAPI api = ContactAPI();
      await api.deleteContact(deletingContactId!);
    } on Exception catch (e) {
      // TODO
      debugPrint(e.toString());
    } finally {
      contacts.removeWhere((Contact contact) => contact.id == deletingContactId);
      deletingContactId = null;
      
      notifyListeners();
    }

    return true;
  }
}