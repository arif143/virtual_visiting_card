import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_visiting_card/models/contact_model.dart';
import 'package:virtual_visiting_card/pages/contact_list_page.dart';
import 'package:virtual_visiting_card/providers/contact_provider.dart';

class NewContactPage extends StatefulWidget {
  static const String routeName = '/new_contact';

  @override
  State<NewContactPage> createState() => _NewContactPageState();
}

class _NewContactPageState extends State<NewContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _companyController = TextEditingController();
  final _designationController = TextEditingController();
  final _websiteController = TextEditingController();
  late ContactProvider _provider;
  String image = '';
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _provider = Provider
          .of<ContactProvider>(context, listen: false);
      final contact = ModalRoute.of(context)!.settings.arguments as ContactModel;
      image = contact.image;
      _nameController.text = contact.name;
      _mobileController.text = contact.mobile;
      _emailController.text = contact.email;
      _addressController.text = contact.address;
      _companyController.text = contact.company;
      _designationController.text = contact.designation;
      _websiteController.text = contact.website;
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    _designationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveContact,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Contact Name*',
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if(value.length > 30) {
                  return 'Name should be less than 20 character';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.phone,
              controller: _mobileController,
              decoration: InputDecoration(
                labelText: 'Mobile Number*',
              ),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.streetAddress,
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Street Address',
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: 'Company Name',
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _designationController,
              decoration: InputDecoration(
                labelText: 'Designation',
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.url,
              controller: _websiteController,
              decoration: InputDecoration(
                labelText: 'Website',
              ),
              validator: (value) {
                return null;
              },
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  void _saveContact() {
    if(_formKey.currentState!.validate()) {
      final contact = ContactModel(
        name: _nameController.text,
        mobile: _mobileController.text,
        email: _emailController.text,
        address: _addressController.text,
        company: _companyController.text,
        designation: _designationController.text,
        website: _websiteController.text,
        image: image,
      );
      _provider.insertContact(contact). then((rowId) {
            contact.id = rowId;
            _provider.updateList(contact);
            Navigator.popUntil(context, ModalRoute.withName(ContactListPage.routeName));
      }).catchError((error) {
        throw error;
      });

    }
  }
}
