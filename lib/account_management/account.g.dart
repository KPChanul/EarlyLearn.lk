// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 1;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account()
      .._name = fields[0] as String
      .._email = fields[1] as String
      .._passwordHash = fields[2] as String
      .._loggedIn = fields[3] as int
      .._currentChild = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj._email)
      ..writeByte(2)
      ..write(obj._passwordHash)
      ..writeByte(3)
      ..write(obj._loggedIn)
      ..writeByte(4)
      ..write(obj._currentChild);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
