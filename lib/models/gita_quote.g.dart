// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gita_quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GitaQuoteAdapter extends TypeAdapter<GitaQuote> {
  @override
  final int typeId = 3;

  @override
  GitaQuote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GitaQuote(
      id: fields[0] as String,
      number: fields[1] as int,
      textDevanagari: fields[2] as String,
      textRoman: fields[3] as String?,
      meaningDevanagari: fields[4] as String?,
      chapterVerse: fields[5] as String?,
      updatedAt: fields[6] as int,
      chapter: fields[7] as int,
      verse: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GitaQuote obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.textDevanagari)
      ..writeByte(3)
      ..write(obj.textRoman)
      ..writeByte(4)
      ..write(obj.meaningDevanagari)
      ..writeByte(5)
      ..write(obj.chapterVerse)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.chapter)
      ..writeByte(8)
      ..write(obj.verse);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitaQuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
