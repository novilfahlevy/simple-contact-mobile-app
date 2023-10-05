import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:coba_platform_widget/model/api/urls.dart';
import 'package:coba_platform_widget/model/contact_model.dart';

class ContactAPI {
  Future<List<Contact>> getContacts() async {
    final Dio dio = Dio();
      
    final Response response = await dio.get(Urls.baseUrl + Urls.contactEndpoint);

    dio.close();

    if (response.statusCode == 200) {
      return response.data
        .map<Contact>((contactMap) => Contact.fromMap(contactMap))
        .toList();
    }

    return [];
  }

  Future<Contact?> getContact(int id) async {
    final Dio dio = Dio();
      
    final Response response = await dio.get('${Urls.baseUrl}${Urls.contactEndpoint}/$id');

    dio.close();

    if (response.statusCode == 200) {
      return Contact.fromMap(response.data);
    }

    return null;
  }

  Future<Contact?> addContact(String name, String phone) async {
    final Dio dio = Dio();
      
    final Response response = await dio.post(
      Urls.baseUrl + Urls.contactEndpoint,
      data: {
        'name': name,
        'phone': phone,
      },
    );

    dio.close();
    
    if (response.statusCode == 201) {
      response.data['id'] = Contact.incrementId++;
      return Contact.fromMap(response.data);
    }

    return null;
  }
  
  Future<Contact?> editContact(int id, String name, String phone) async {
    final Dio dio = Dio();

    // Ini untuk soal prioritas 1 nomor 3
    final Response postResponse = await dio.put(
      'https://jsonplaceholder.typicode.com/posts/1',
      data: {
        "id": 1,
        "title": "foo",
        "body": "bar",
        "userId": 1
      },
    );

    debugPrint(postResponse.toString());
      
    final Response response = await dio.put(
      '${Urls.baseUrl}${Urls.contactEndpoint}/$id',
      data: {
        'name': name,
        'phone': phone,
      },
    );

    dio.close();
    
    if (response.statusCode == 200) {
      return Contact.fromMap(response.data);
    }

    return null;
  }

  Future<bool> deleteContact(int id) async {
    final Dio dio = Dio();
      
    await dio.delete('${Urls.baseUrl}${Urls.contactEndpoint}/$id');

    dio.close();

    return true;
  }
}