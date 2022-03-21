class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  static final userModel = UserModel._internal();
  UserModel._internal();

  UserModel({this.uid, this.email, this.firstName, this.secondName});

  // receiving data from server
  factory UserModel.fromMap(map) {
    userModel.uid = map['uid'];
    userModel.email = map['email'];
    userModel.firstName = map['firstName'];
    userModel.secondName = map['secondName'];
    return userModel;
  }

  factory UserModel.getModel() => userModel;

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': userModel.uid,
      'email': userModel.email,
      'firstName': userModel.firstName,
      'secondName': userModel.secondName,
    };
  }
}
