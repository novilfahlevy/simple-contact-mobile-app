import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coba_platform_widget/components/contact_item.dart';
import 'package:coba_platform_widget/components/loading_indicator.dart';

import 'package:coba_platform_widget/screens/view_models/contact_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Provider
      .of<ContactViewModel>(context, listen: false)
      .getContacts();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak anda'),
      ),
      body: Consumer<ContactViewModel>(
        builder: (context, state, loadingIndicator) {
          if (state.isFetchingContact) {
            return loadingIndicator!;
          } else {
            if (state.contacts.isNotEmpty) {
              return ListView.separated(
                itemCount: state.contacts.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) =>
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: index == 0 ? 20 : 10,
                      bottom: index == (state.contacts.length - 1) ? 20 : 10
                    ),
                    child: ContactItem(
                      id: state.contacts[index].id,
                      name: state.contacts[index].name,
                      phone: state.contacts[index].phone,
                    )
                  ),
              );
            } else {
              return const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 80,
                    ),
                    SizedBox(height: 10,),
                    Text('Belum ada kontak', style: TextStyle(fontSize: 16),)
                  ],
                ),
              );
            }
          }
        },
        child: const Center(child: LoadingIndicator(size: 30, color: Colors.blue))
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          shape: const CircleBorder()
        ),
        onPressed: () => Navigator.pushNamed(
          context,
          '/add-contact',
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}