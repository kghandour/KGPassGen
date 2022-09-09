// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigurationAdapter extends TypeAdapter<Configuration> {
  @override
  final int typeId = 0;

  @override
  Configuration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Configuration()
      ..name = fields[0] as String
      ..createdDate = fields[1] as DateTime
      ..editDate = fields[2] as DateTime
      ..hashingAlgorithm = fields[3] as bool
      ..hashingFunction = fields[4] as bool
      ..pwLength = fields[5] as int
      ..validateInputpw = fields[6] as bool
      ..stripSubDomain = fields[7] as bool;
  }

  @override
  void write(BinaryWriter writer, Configuration obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.editDate)
      ..writeByte(3)
      ..write(obj.hashingAlgorithm)
      ..writeByte(4)
      ..write(obj.hashingFunction)
      ..writeByte(5)
      ..write(obj.pwLength)
      ..writeByte(6)
      ..write(obj.validateInputpw)
      ..writeByte(7)
      ..write(obj.stripSubDomain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigurationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
