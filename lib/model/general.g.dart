// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GeneralAdapter extends TypeAdapter<General> {
  @override
  final int typeId = 1;

  @override
  General read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return General()
      ..showGuide = fields[0] as bool
      ..showChangelog = fields[1] as bool
      ..setConfiguration = fields[2] as int
      ..locale = fields[3] as String
      ..darkMode = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, General obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.showGuide)
      ..writeByte(1)
      ..write(obj.showChangelog)
      ..writeByte(2)
      ..write(obj.setConfiguration)
      ..writeByte(3)
      ..write(obj.locale)
      ..writeByte(4)
      ..write(obj.darkMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
