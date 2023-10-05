import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coba_platform_widget/screens/contacts_screen.dart';
import 'package:coba_platform_widget/screens/add_contact_screen.dart';
import 'package:coba_platform_widget/screens/edit_contact_screen.dart';

import 'package:coba_platform_widget/screens/view_models/contact_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContactViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ContactApp',
      // theme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: const Color(0xff6200EE)
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SafeArea(child: HomeScreen()),
        '/add-contact': (_) => const SafeArea(child: AddContactScreen()),
        '/edit-contact': (_) => const SafeArea(child: EditContactScreen()),
      },
    );
  }
}

