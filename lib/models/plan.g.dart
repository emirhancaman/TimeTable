// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlanAdapter extends TypeAdapter<Plan> {
  @override
  final int typeId = 0;

  @override
  Plan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plan(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String?,
      createdAt: fields[3] as DateTime,
      dueDate: fields[4] as DateTime?,
      isCompleted: fields[5] as bool,
      category: fields[6] as String,
      subCategory: fields[9] as String?,
      priority: fields[7] as int,
      emoji: fields[10] as String,
      isFavorite: fields[11] as bool,
      planType: fields[12] == null ? PlanType.oneTime : fields[12] as PlanType,
      repeatDays: (fields[13] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Plan obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.isCompleted)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.priority)
      ..writeByte(9)
      ..write(obj.subCategory)
      ..writeByte(10)
      ..write(obj.emoji)
      ..writeByte(11)
      ..write(obj.isFavorite)
      ..writeByte(12)
      ..write(obj.planType)
      ..writeByte(13)
      ..write(obj.repeatDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlanTypeAdapter extends TypeAdapter<PlanType> {
  @override
  final int typeId = 2;

  @override
  PlanType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlanType.oneTime;
      case 1:
        return PlanType.weekly;
      case 2:
        return PlanType.selectedDays;
      default:
        return PlanType.oneTime;
    }
  }

  @override
  void write(BinaryWriter writer, PlanType obj) {
    switch (obj) {
      case PlanType.oneTime:
        writer.writeByte(0);
        break;
      case PlanType.weekly:
        writer.writeByte(1);
        break;
      case PlanType.selectedDays:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
