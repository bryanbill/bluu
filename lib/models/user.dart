class User {
  String uid;
  bool public;
  String name;
  String email;
  String username;
  String status;
  bool verified;
  int phone;
  int state;
  String profilePhoto;
  String firebaseToken;

  User({
    this.uid,
    this.public,
    this.name,
    this.phone,
    this.verified,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
    this.firebaseToken,
  });

  Map toMap() {
    var data = Map<String, dynamic>();
    data['uid'] = uid;
    data['public'] = public;
    data['name'] = name;
    data['email'] = email;
    data['verified'] = verified;
    data['username'] = username;
    data["status"] = status;
    data["state"] = state;
    data["phone"] = phone;
    data["profile_photo"] = profilePhoto;
    data['firebaseToken'] = firebaseToken;
    return data;
  }

  // Named constructor
  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.public = mapData['public'];
    this.verified = mapData['verified'];
    this.email = mapData['email'];
    this.username = mapData['username'];
    this.status = mapData['status'];
    this.state = mapData['state'];
    this.phone = mapData['phone'];
    this.profilePhoto = mapData['profile_photo'];
    this.firebaseToken = mapData['firebaseToken'];
  }
}
