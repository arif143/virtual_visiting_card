import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_visiting_card/models/contact_model.dart';
import 'package:virtual_visiting_card/pages/new_contact_page.dart';
import 'package:virtual_visiting_card/utils/constants.dart';

final selectedLines = [];

class ScanPage extends StatefulWidget {
  static const String routeName = '/scan';

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? _imagePath;
  ImageSource _imageSource = ImageSource.camera;
  String name = "", mobile = "", email = "", address = "", company = "", designation = "", website = "", image = "";
  var _lines = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Visiting Card'),
        actions: [
          TextButton(
              child: const Text('Next', style: TextStyle(color: Colors.white),),
            onPressed: _imagePath == null? null : _createContactModelFromScannedValues,
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: _imagePath == null ?
              Image.asset('images/placeholder.png', width: double.infinity, height: 180, fit: BoxFit.fill,) :
              Image.file(File(_imagePath!), width: double.infinity, height: 180, fit: BoxFit.fill,),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             TextButton.icon(
               icon: Icon(Icons.camera),
                 label: const Text('Capture Image'),
               onPressed: () {
                 _imageSource = ImageSource.camera;
                 _takePhoto();
               },
             ),
              TextButton.icon(
                icon: Icon(Icons.photo),
                label: const Text('Select from gallery'),
                onPressed: () {
                  _imageSource = ImageSource.gallery;
                  _takePhoto();
                },
              ),
            ],
          ),
          Column(
            children: _lines.map((e) => LineItem(e)).toList(),
          ),
          if (_imagePath != null) Wrap(
            children: [
              createPropertyButton(ContactProperties.name),
              createPropertyButton(ContactProperties.mobile),
              createPropertyButton(ContactProperties.email),
              createPropertyButton(ContactProperties.address),
              createPropertyButton(ContactProperties.company),
              createPropertyButton(ContactProperties.designation),
              createPropertyButton(ContactProperties.website),
            ],
          ),
        ],
      ),
    );
  }

  Widget createPropertyButton(String name) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(onPressed: () {
        _getPropertyValue(name);
      }, child: Text(name)),
    );
  }

  void _takePhoto() async {
    final imageFile = await ImagePicker().pickImage(source: _imageSource);
    if(imageFile != null) {
      setState(() {
        _imagePath = imageFile.path;
      });
      image = _imagePath!;
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textRecognizer.processImage(InputImage.fromFile(File(_imagePath !)));
      final tempList = <String>[];
      for (var block in recognizedText.blocks) {
        for (var line in block.lines) {
          tempList.add(line.text);
        }
      }
      setState(() {
        _lines = tempList;
      });
    }
  }

  void _getPropertyValue(String name) {
    final mergedText = selectedLines.join(' ');
    switch (name) {
      case ContactProperties.name:
        this.name = mergedText;
        break;
      case ContactProperties.mobile:
        mobile = mergedText;
        break;
      case ContactProperties.email:
        email = mergedText;
        break;
      case ContactProperties.address:
        address = mergedText;
        break;
      case ContactProperties.company:
        company = mergedText;
        break;
      case ContactProperties.designation:
        designation = mergedText;
        break;
      case ContactProperties.website:
        website = mergedText;
        break;
    }
    selectedLines.clear();
  }

  void _createContactModelFromScannedValues() {
    final contact = ContactModel(
      name: name,
      mobile: mobile,
      email: email,
      address: address,
      company: company,
      designation: designation,
      website: website,
      image: image,
    );
    Navigator.pushNamed(context, NewContactPage.routeName, arguments: contact);
  }
}


class LineItem extends StatefulWidget {
  final String line;
  LineItem(this.line);

  @override
  State<LineItem> createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
     title: Text(widget.line),
      trailing: Checkbox(
        value: _isChecked,
        onChanged: (value) {
          setState(() {
            _isChecked = value!;
          });
          value! ? selectedLines.add(widget.line) : selectedLines.remove(widget.line);
        },
      ),
    );
  }
}

