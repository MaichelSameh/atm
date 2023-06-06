import 'package:atm_app/models/account_info.dart';
import 'package:hive/hive.dart';

class AccountAdaptor extends TypeAdapter<AccountInfo> {
  @override
  final typeId = 0;

  @override
  AccountInfo read(BinaryReader reader) {
    return AccountInfo.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, AccountInfo obj) {
    writer.writeMap(obj.toMap);
  }
}
