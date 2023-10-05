import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coba_platform_widget/components/loading_indicator.dart';
import 'package:coba_platform_widget/screens/view_models/contact_view_model.dart';

import 'package:coba_platform_widget/mixins/contact_validation.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  final String title = 'Tambah kontak';

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> with ContactValidation {
  final formKey = GlobalKey<FormState>();

  void _addContact(BuildContext context) async {
    final ContactViewModel contactViewModel = Provider.of<ContactViewModel>(context, listen: false);

    if (formKey.currentState!.validate()) {
      final bool isAddingContactSuccess = await contactViewModel.add(
        name: contactViewModel.inputNameController.text,
        phone: contactViewModel.inputPhoneController.text,
      );

      if (context.mounted) {
        if (isAddingContactSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Kontak telah ditambahkan.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal menambah kontak.'),
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<ContactViewModel>(
                builder: (context, state, _) {
                  return TextFormField(
                    controller: state.inputNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama'
                    ),
                    validator: validateInputName,
                  );
                }
              ),
              const SizedBox(height: 15,),
              Consumer<ContactViewModel>(
                builder: (context, state, _) {
                  return TextFormField(
                    controller: state.inputPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Nomor'
                    ),
                    validator: validateInputPhone,
                  );
                }
              ),
              const SizedBox(height: 15,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6750A4),
                ),
                onPressed: () => _addContact(context),
                child: Consumer<ContactViewModel>(
                  builder: (context, state, child) {
                    if (state.isAddingContact) {
                      return child!;
                    }
                    return const Text('Tambah');
                  },
                  child: const LoadingIndicator(size: 15,),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
