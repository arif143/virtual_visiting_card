import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:virtual_visiting_card/models/contact_model.dart';
import 'package:virtual_visiting_card/providers/contact_provider.dart';

class ContactDetailsPage extends StatelessWidget {
  static const String routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final argList = ModalRoute.of(context)!.settings.arguments as List;
    final id = argList[0];
    final name = argList[1];
    return Scaffold(
      appBar: AppBar (title: Text(name),
      ),
      body: Center(
        child: Consumer<ContactProvider>(
          builder: (context, provider, _) =>FutureBuilder<ContactModel>(
            future: provider.getContactById(id),
            builder: (context, snapshot) {
             if (snapshot.hasData){
               final contact = snapshot.data;
               return buildDetailsListBody(contact, context);
             }
             if(snapshot.hasError) {
               return const Text('Failed to fetch data');
             }
             return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Widget buildDetailsListBody(ContactModel? contact, BuildContext context) {
    return ListView(
               padding: const EdgeInsets.all(12),
               children: [
                 Image.file(
                   File(contact!.image),
                   width: double.infinity,
                   height: 250,
                   fit: BoxFit.cover,),
                 ListTile(
                  title: Text(contact.mobile),
                   trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                     children: [
                       IconButton(onPressed: () {
                         _callContact(contact.mobile, context);
                       }, icon: Icon(Icons.call)),
                       IconButton(onPressed: () {
                         _smsContact(contact.mobile, context);
                       }, icon: Icon(Icons.sms)),
                     ],
                   ),
                 ),
                 ListTile(
                   title: Text(contact.email),
                   trailing: IconButton(onPressed: () {
                     _mailContact(contact.email, context);
                   }, icon: Icon(Icons.email)),
                 ),
                 ListTile(
                   title: Text(contact.address),
                   trailing: IconButton(onPressed: () {
                   }, icon: Icon(Icons.map)),
                 ),
                 ListTile(
                   title: Text(contact.website),
                   trailing: IconButton(onPressed: () {}, icon: Icon(Icons.web)),
                 ),
               ],
             );
  }

  void _callContact(String mobile, BuildContext context) async {
    final uri = 'tel:$mobile';
    if (await canLaunchUrlString(uri)) {
      await launchUrlString(uri);
    } else {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
           content: Text('could not launch Application')));
      throw 'could not launch Application';
    }
  }

  void _mailContact(String email, BuildContext context) async {
    final uri = 'mailto:email?subject=News&body=New%20plugin';
    if (await canLaunchUrlString(uri)) {
    await launchUrlString(uri);
    } else {
    ScaffoldMessenger
        .of(context)
        .showSnackBar(SnackBar(
          content: Text('could not launch Application')));
    throw 'could not launch Application';
    }
  }

  void _smsContact(String mobile, BuildContext context) async {
    final uri = 'sms:$mobile';
    if (await canLaunchUrlString(uri)) {
      await launchUrlString(uri);
    } else {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(SnackBar(
            content: Text('could not launch Application')));
      throw 'could not launch Application';
    }
  }

}
