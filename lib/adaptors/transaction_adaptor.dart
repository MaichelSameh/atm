import 'package:atm_app/models/transaction_info.dart';
import 'package:hive/hive.dart';

class TransactionAdaptor extends TypeAdapter<TransactionInfo> {
  @override
  final typeId = 1;

  @override
  TransactionInfo read(BinaryReader reader) {
    return TransactionInfo.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, TransactionInfo obj) {
    writer.writeMap(obj.toMap);
  }
}
