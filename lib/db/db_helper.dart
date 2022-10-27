import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import 'package:virtual_visiting_card/models/contact_model.dart';

class DBHelper {
  static final String _createTableContact = '''create table $tableContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColCompany text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text
  $tblContactColFavorite integer)''';
  static Future<Database> open() async {
    final rootPath = await getDatabasesPath();
    final dbPath = Path.join(rootPath, 'contact_db');
    return openDatabase(dbPath, version: 2, onCreate: (db, version) async {
      await db.execute(_createTableContact);
    }, onUpgrade: (db, oldVersion, newVersion) async{
      if (oldVersion == 1) {
        db.execute('alter table $tableContact add column $tblContactColFavorite integer not null default 0');
      }
    });
  }

  static Future<int> insertContact(ContactModel contactModel) async {
    final db = await open();
    return db.insert(tableContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAllContacts() async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tableContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  static Future<ContactModel> getContactById(int id) async {
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> deleteContactById(int id) async {
    final db = await open();
    return db.delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  static Future<int> updateContactFavoriteById(int id, int value) async {
    final db = await open();
    return db.update(tableContact, {tblContactColFavorite : value}, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}