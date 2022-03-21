class ProfileModel {
  String? name;
  num? age;
  String? gender;
  String? country;

  static final profileModel = ProfileModel._internal();
  ProfileModel._internal();

  ProfileModel({this.name, this.age, this.gender, this.country});

  // receiving data from server
  factory ProfileModel.fromMap(map) {
    profileModel.name = map['name'];
    profileModel.age = map['age'];
    profileModel.gender = map['gender'];
    profileModel.country = map['country'];
    return profileModel;
  }

  factory ProfileModel.getModel() => profileModel;

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'name': profileModel.name,
      'age': profileModel.age,
      'gender': profileModel.gender,
      'country': profileModel.country,
    };
  }
}
