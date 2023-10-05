import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:coba_platform_widget/components/loading_indicator.dart';
import 'package:coba_platform_widget/screens/view_models/contact_view_model.dart';

class ContactItem extends StatefulWidget {
  const ContactItem({
    super.key,
    required this.id,
    required this.name,
    required this.phone,
  });

  final int id;
  final String name;
  final String phone;

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  String _getFirstLetterName() {
    return widget.name.split(' ').first[0];
  }

  void _goToEditContactScreen() {
    Provider
      .of<ContactViewModel>(context, listen: false)
      .getContact(widget.id);

    Navigator.pushNamed(
      context,
      '/edit-contact',
      arguments: widget.id
    );
  }

  void _confirmDeleteContact(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
        AlertDialog(
          content: const Text('Apakah anda yakin ingin menghapus kontak ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')
            ),
            TextButton(
              onPressed: _deleteContact,
              child: const Text('Iya')
            ),
          ],
        ),
    );
  }

  void _deleteContact() async {
    final contactViewModel = Provider.of<ContactViewModel>(context, listen: false);

    Navigator.pop(context);

    bool isDeleteContactSuccess = await contactViewModel.delete(widget.id);

    if (context.mounted) {
      if (isDeleteContactSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Kontak telah dihapus.'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Gagal menghapus kontak.'),
          ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Center(
            child: Text(
              _getFirstLetterName(),
              style: const TextStyle(fontSize: 16, color: Colors.white)
            )
          ),
        ),
        const SizedBox(width: 20,),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                    const SizedBox(height: 5,),
                    Text(widget.phone, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),),
                  ],
                )
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _goToEditContactScreen,
                    icon: const Icon(Icons.edit)
                  ),
                  IconButton(
                    onPressed: () => _confirmDeleteContact(context),
                    icon: Consumer<ContactViewModel>(
                      builder: (context, state, loadingIndicator) {
                        if (state.deletingContactId != null && state.deletingContactId == widget.id) {
                          return loadingIndicator!;
                        }
                        return const Icon(Icons.delete);
                      },
                      child: const LoadingIndicator(color: Colors.blue)
                    )
                  ),
                ],
              )
            ],
          )
        )
      ],
    );
  }
}
