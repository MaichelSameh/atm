import 'package:atm_app/enum.dart';

class AccountInfo {
  late String _email;
  late String _id;
  late String _name;
  late String _personalIdUrl;
  late String _phoneCode;
  late String _phoneNumber;
  late String _pinCode;
  late String _profileUrl;
  late UserType _type;
  late String _creatorId;
  late DateTime _createdAt;

  AccountInfo({
    required String email,
    required String id,
    required String name,
    required String personalIdUrl,
    required String phoneCode,
    required String phoneNumber,
    required String pinCode,
    required String profileUrl,
    required UserType type,
    required String creatorId,
    required DateTime createdAt,
  }) {
    _email = email;
    _id = id;
    _name = name;
    _personalIdUrl = personalIdUrl;
    _phoneCode = phoneCode;
    _phoneNumber = phoneNumber;
    _pinCode = pinCode;
    _profileUrl = profileUrl;
    _type = type;
    _creatorId = creatorId;
    _createdAt = createdAt;
  }

  AccountInfo.fromMap(Map<dynamic, dynamic> data) {
    _email = data["email"];
    _id = data["id"];
    _name = data["name"];
    _personalIdUrl = data["personalIdUrl"];
    _phoneCode = data["phoneCode"];
    _phoneNumber = data["phoneNumber"];
    _pinCode = data["pinCode"];
    _profileUrl = data["profileUrl"];
    _type =
        UserType.values.firstWhere((element) => element.name == data["type"]);
    _createdAt = data["createdAt"] ?? DateTime.now();
    _creatorId = data["creatorId"] ?? "";
  }

  String get email => _email;
  String get id => _id;
  String get name => _name;
  String get personalIdUrl => _personalIdUrl;
  String get phoneCode => _phoneCode;
  String get phoneNumber => _phoneNumber;
  String get pinCode => _pinCode;
  String get profileUrl => _profileUrl;
  UserType get type => _type;
  String get creatorId => _creatorId;
  DateTime get createdAt => _createdAt;

  Map<dynamic, dynamic> get toMap => {
        "email": email,
        "id": id,
        "name": name,
        "personalIdUrl": personalIdUrl,
        "phoneCode": phoneCode,
        "phoneNumber": phoneNumber,
        "pinCode": pinCode,
        "profileUrl": profileUrl,
        "type": type.name,
        "creatorId": creatorId,
        "createdAt": createdAt,
      };

  @override
  String toString() {
    return 'AccountInfo(_email: $_email, _id: $_id, _name: $_name, _personalIdUrl: $_personalIdUrl, _phoneCode: $_phoneCode, _phoneNumber: $_phoneNumber, _pinCode: $_pinCode, _profileUrl: $_profileUrl, _type: $_type, _creatorId: $_creatorId, _createdAt: $_createdAt)';
  }

  AccountInfo copyWith({
    String? email,
    String? id,
    String? name,
    String? personalIdUrl,
    String? phoneCode,
    String? phoneNumber,
    String? pinCode,
    String? profileUrl,
    UserType? type,
    String? creatorId,
    DateTime? createdAt,
  }) {
    return AccountInfo(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
      personalIdUrl: personalIdUrl ?? this.personalIdUrl,
      phoneCode: phoneCode ?? this.phoneCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pinCode: pinCode ?? this.pinCode,
      profileUrl: profileUrl ?? this.profileUrl,
      type: type ?? this.type,
      creatorId: creatorId ?? this.creatorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
