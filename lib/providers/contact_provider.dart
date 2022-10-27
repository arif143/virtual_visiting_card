import 'package:flutter/foundation.dart';
import 'package:virtual_visiting_card/db/db_helper.dart';
import 'package:virtual_visiting_card/models/contact_model.dart';

class ContactProvider with ChangeNotifier {
  List<ContactModel> _contactList = [];
  List<ContactModel> get contactList => _contactList;

  Future<int> insertContact(ContactModel contactModel) => DBHelper.insertContact(contactModel);

  void getAllContacts() async {
    _contactList = await DBHelper.getAllContacts();
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) => DBHelper.getContactById(id);

  void updateList (ContactModel model) {
    _contactList.add(model);
    notifyListeners();
  }

  void removeItemFromList (ContactModel model) {
    _contactList.remove(model);
    notifyListeners();
  }

  Future<int> deleteContact (int id) {
    return DBHelper.deleteContactById(id);
  }

  void updateContactFavoriteById(int id, int value) {
    DBHelper.updateContactFavoriteById(id, value).then((value) {
      final contact = _contactList.firstWhere((element) => element.id == id);
      final index = _contactList.indexOf(contact);
      _contactList[index].favorite = !_contactList[index].favorite;
      notifyListeners();
    });
  }

}