final String tableContact = "tbl_contact";
final String tblContactColId = "id";
final String tblContactColName = "name";
final String tblContactColMobile= "mobile";
final String tblContactColEmail = "email";
final String tblContactColAddress = "address";
final String tblContactColCompany = "company";
final String tblContactColDesignation= "designation";
final String tblContactColWebsite = "website";
final String tblContactColFavorite = "favorite";
final String tblContactColImage = "image";

class ContactModel {
  int id;
  String name;
  String mobile;
  String email;
  String address;
  String company;
  String designation;
  String website;
  String image;
  bool favorite;

  ContactModel(
      {required this.name,
        required this.mobile,
        this.id = 0,
        this.email = "",
        this.address = "",
        this.company = "",
        this.designation = "",
        this.website = "",
        this.image = "https://www.kindpng.com/picc/m/21-214439_free-high-quality-person-icon-default-profile-picture.png",
        this.favorite = false
      });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      tblContactColName : name,
      tblContactColMobile : mobile,
      tblContactColEmail : email,
      tblContactColAddress : address,
      tblContactColCompany : company,
      tblContactColDesignation : designation,
      tblContactColImage : image,
      tblContactColWebsite : website,
      tblContactColFavorite : favorite ? 1 : 0,
    };
    if(id > 0) {
      map[tblContactColId] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) => ContactModel(
    id: map[tblContactColId],
    name: map[tblContactColName],
    mobile: map[tblContactColMobile],
    email: map[tblContactColEmail],
    address: map[tblContactColAddress],
    designation: map[tblContactColDesignation],
    company: map[tblContactColCompany],
    website: map[tblContactColWebsite],
    image: map[tblContactColImage],
    favorite: map[tblContactColFavorite] == 1 ? true : false,
  );


  @override
  String toString() {
    return 'ContactModel{id: $id, name: $name, mobile: $mobile, email: $email, address: $address, company: $company, designation: $designation, website: $website, image: $image}';
  }
}