// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as double,
      fields[6] as double?,
      fields[7] as double?,
      fields[8] as bool?,
      (fields[9] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.tovarId)
      ..writeByte(1)
      ..write(obj.tovar)
      ..writeByte(2)
      ..write(obj.yedIzm)
      ..writeByte(3)
      ..write(obj.kategoriyaid)
      ..writeByte(4)
      ..write(obj.foto)
      ..writeByte(5)
      ..write(obj.ostatka)
      ..writeByte(6)
      ..write(obj.sena)
      ..writeByte(7)
      ..write(obj.optom_narx)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.barcode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      json['tovarId'] as String,
      json['tovar'] as String,
      json['yedIzm'] as String,
      json['kategoriyaid'] as String,
      json['foto'] as String,
      (json['ostatka'] as num).toDouble(),
      (json['sena'] as num?)?.toDouble(),
      (json['optom_narx'] as num?)?.toDouble(),
      json['type'] as bool?,
      (json['barcode'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'tovarId': instance.tovarId,
      'tovar': instance.tovar,
      'yedIzm': instance.yedIzm,
      'kategoriyaid': instance.kategoriyaid,
      'foto': instance.foto,
      'ostatka': instance.ostatka,
      'sena': instance.sena,
      'optom_narx': instance.optom_narx,
      'type': instance.type,
      'barcode': instance.barcode,
    };
