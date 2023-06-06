import '../enum.dart';

class TransactionInfo {
  late String _id;
  late DateTime _createdAt;
  late double _amount;
  late String _creatorId;
  late TransactionType _type;

  TransactionInfo({
    required String id,
    required DateTime createdAt,
    required double amount,
    required String creatorId,
    required TransactionType type,
  }) {
    _id = id;
    _createdAt = createdAt;
    _amount = amount;
    _creatorId = creatorId;
    _type = type;
  }

  TransactionInfo.fromMap(Map<dynamic, dynamic> data) {
    _id = data["id"];
    _createdAt = data["createdAt"];
    _amount = data["amount"];
    _creatorId = data["creatorId"];
    _type = TransactionType.values
        .firstWhere((element) => element.name == data["type"]);
  }

  String get id => _id;
  DateTime get createdAt => _createdAt;
  double get amount => _amount;
  String get creatorId => _creatorId;
  TransactionType get type => _type;

  Map<dynamic, dynamic> get toMap => {
        "id": id,
        "createdAt": createdAt,
        "amount": amount,
        "creatorId": creatorId,
        "type": type.name,
      };

  @override
  String toString() {
    return 'TransactionInfo(_id: $_id, _createdAt: $_createdAt, _amount: $_amount, _creatorId: $_creatorId, _type: $_type)';
  }
}
