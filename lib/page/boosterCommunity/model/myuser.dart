class MyUser {
  final String? uid;
  final bool? verified;

  MyUser({this.uid, this.verified});
}

class CurrentUserInfo {
  final String? uid;
  final String? firstName;
  final String? lastName;
  final String? school;

  CurrentUserInfo({this.uid, this.firstName, this.lastName,  this.school});
}