import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_visiting_card/models/contact_model.dart';
import 'package:virtual_visiting_card/pages/contact_details_page.dart';
import 'package:virtual_visiting_card/providers/contact_provider.dart';

class ContactItem extends StatefulWidget {
  final ContactModel contactModel;
  ContactItem(this.contactModel);

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
      ),
      confirmDismiss: showConfirmationDialog,
      onDismissed: (_) {
        Provider
            .of<ContactProvider>(context, listen: false)
            .deleteContact(widget.contactModel.id).then((value) {
              context.read<ContactProvider>().removeItemFromList(widget.contactModel);
        });
      },
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, ContactDetailsPage.routeName, arguments: [widget.contactModel.id, widget.contactModel.name]);
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            title: Text(widget.contactModel.name),
            subtitle: Text(widget.contactModel.mobile),
            trailing: Consumer<ContactProvider>(
              builder: (context, provider, _) =>IconButton(
                icon: Icon(widget.contactModel.favorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  final value = widget.contactModel.favorite ? 0 : 1;
                  provider
                      .updateContactFavoriteById(widget.contactModel.id, value);
                },
              ),
            )),
      ),
    );
  }

  Future<bool?> showConfirmationDialog(DismissDirection direction){
   return showDialog(
       context: context,
       builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
         content: const Text('Sure to delete this contact?'),
         actions: [
           TextButton(
               child: const Text('CANCLE'),
             onPressed: () {
                 Navigator.pop(context, false);
             },
           ),
           ElevatedButton(
             child: const Text('Yes'),
             onPressed: () {
               Navigator.pop(context, true);
             },
           ),
         ],
       ));
  }
}
