// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Word _$$_WordFromJson(Map<String, dynamic> json) => _$_Word(
      id: json['id'] as String?,
      frontName: json['frontName'] as String?,
      backName: json['backName'] as String?,
      tableName: json['tableName'] as String?,
      folderNameId: json['folderNameId'] as String?,
      yesCount: json['yesCount'] as int?,
      noCount: json['noCount'] as int?,
      play: json['play'] as int?,
      time: json['time'] as int?,
      percent: json['percent'] as int?,
      average: json['average'] as int?,
      ok: json['ok'] as String?,
    );

Map<String, dynamic> _$$_WordToJson(_$_Word instance) => <String, dynamic>{
      'id': instance.id,
      'frontName': instance.frontName,
      'backName': instance.backName,
      'tableName': instance.tableName,
      'folderNameId': instance.folderNameId,
      'yesCount': instance.yesCount,
      'noCount': instance.noCount,
      'play': instance.play,
      'time': instance.time,
      'percent': instance.percent,
      'average': instance.average,
      'ok': instance.ok,
    };
