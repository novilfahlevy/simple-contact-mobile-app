import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coba_platform_widget/components/loading_indicator.dart';
import 'package:coba_platform_widget/mixins/contact_validation.dart';

import 'package:coba_platform_widget/screens/view_models/contact_view_model.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({super.key});

  final String title = 'Edit kontak';

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> with ContactValidation {
  final formKey = GlobalKey<FormState>();

  void _editContact(BuildContext context) async {
    final contactViewModel = Provider.of<ContactViewModel>(context, listen: false);

    if (formKey.currentState!.validate()) {
      int id = ModalRoute.of(context)!.settings.arguments as int;

      bool isEditContactSuccess = await contactViewModel.edit(
        id: id,
        name: contactViewModel.inputNameController.text,
        phone: contactViewModel.inputPhoneController.text,
      );

      if (context.mounted) {
        if (isEditContactSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Kontak telah diperbarui.'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal memperbarui kontak.'),
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
                builder: (context, state, child) {
                  return TextFormField(
                    controller: state.inputNameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      enabled: !state.isFetchingContact
                    ),
                    validator: validateInputName,
                  );
                }
              ),
              const SizedBox(height: 15,),
              Consumer<ContactViewModel>(
                builder: (context, state, child) {
                  return TextFormField(
                    controller: state.inputPhoneController,
                    decoration: InputDecoration(
                      labelText: 'Nomor',
                      enabled: !state.isFetchingContact
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
                onPressed: () => _editContact(context),
                child: Consumer<ContactViewModel>(
                  builder: (context, state, child) {
                    if (state.isEditingContact) {
                      return child!;
                    }
                    
                    return const Text('Edit');
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
