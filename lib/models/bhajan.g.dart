// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bhajan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BhajanAdapter extends TypeAdapter<Bhajan> {
  @override
  final int typeId = 0;

  @override
  Bhajan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bhajan(
      id: fields[0] as String,
      number: fields[1] as int,
      titleDevanagari: fields[2] as String,
      titleRoman: fields[3] as String,
      lyricsDevanagari: fields[4] as String,
      lyricsRoman: fields[5] as String,
      category: fields[6] as String,
      keywords: (fields[7] as List).cast<String>(),
      firstLineDevanagari: fields[8] as String,
      firstLineRoman: fields[9] as String,
      sourceBook: fields[10] as String?,
      sourceAuthor: fields[11] as String?,
      sourcePublisher: fields[12] as String?,
      sourceYear: fields[13] as String?,
      sourcePage: fields[14] as int?,
      updatedAt: fields[15] as int,
      meaningDevanagari: fields[16] as String?,
      youtubeUrl: fields[17] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Bhajan obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.titleDevanagari)
      ..writeByte(3)
      ..write(obj.titleRoman)
      ..writeByte(4)
      ..write(obj.lyricsDevanagari)
      ..writeByte(5)
      ..write(obj.lyricsRoman)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.keywords)
      ..writeByte(8)
      ..write(obj.firstLineDevanagari)
      ..writeByte(9)
      ..write(obj.firstLineRoman)
      ..writeByte(10)
      ..write(obj.sourceBook)
      ..writeByte(11)
      ..write(obj.sourceAuthor)
      ..writeByte(12)
      ..write(obj.sourcePublisher)
      ..writeByte(13)
      ..write(obj.sourceYear)
      ..writeByte(14)
      ..write(obj.sourcePage)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.meaningDevanagari)
      ..writeByte(17)
      ..write(obj.youtubeUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BhajanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
