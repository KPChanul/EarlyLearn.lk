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
    
    // Create with dummy password (will be overridden)
    final account = Account(
      name: fields[0] as String? ?? '',
      email: fields[1] as String? ?? '',
      password: 'dummy',  // Placeholder, will be replaced
      loggedIn: fields[3] as int? ?? 0,
      currentChild: fields[4] as String? ?? '',
    );
    
    // Override passwordHash with the stored hashed value (don't re-hash)
    account.passwordHash = fields[2] as String? ?? '';
    
    return account;
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.loggedIn)
      ..writeByte(4)
      ..write(obj.currentChild);
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
