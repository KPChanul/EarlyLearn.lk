// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildAdapter extends TypeAdapter<Child> {
  @override
  final int typeId = 0;

  @override
  Child read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Child(
      fields[0] as String,
      fields[1] as DateTime,
      (fields[2] as Map).cast<int, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Child obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj._dob)
      ..writeByte(2)
      ..write(obj._stages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
