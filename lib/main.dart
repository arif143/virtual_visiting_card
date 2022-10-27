import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_visiting_card/pages/contact_details_page.dart';
import 'package:virtual_visiting_card/pages/contact_list_page.dart';
import 'package:virtual_visiting_card/pages/new_contact_page.dart';
import 'package:virtual_visiting_card/pages/scan_page.dart';
import 'package:virtual_visiting_card/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => ContactProvider()..getAllContacts(),
      child: MyApp()));
}


class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ContactListPage.routeName,
      routes: {
        ContactListPage.routeName : (context) => ContactListPage(),
        ContactDetailsPage.routeName : (context) => ContactDetailsPage(),
        NewContactPage.routeName : (context) => NewContactPage(),
        ScanPage.routeName : (context) => ScanPage(),
      },
    );
  }
}
