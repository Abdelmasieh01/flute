// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SkillLevelStruct extends BaseStruct {
  SkillLevelStruct({
    String? name,
    String? video,
  })  : _name = name,
        _video = video;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "video" field.
  String? _video;
  String get video => _video ?? '';
  set video(String? val) => _video = val;

  bool hasVideo() => _video != null;

  static SkillLevelStruct fromMap(Map<String, dynamic> data) =>
      SkillLevelStruct(
        name: data['name'] as String?,
        video: data['video'] as String?,
      );

  static SkillLevelStruct? maybeFromMap(dynamic data) => data is Map
      ? SkillLevelStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'video': _video,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'video': serializeParam(
          _video,
          ParamType.String,
        ),
      }.withoutNulls;

  static SkillLevelStruct fromSerializableMap(Map<String, dynamic> data) =>
      SkillLevelStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        video: deserializeParam(
          data['video'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SkillLevelStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SkillLevelStruct &&
        name == other.name &&
        video == other.video;
  }

  @override
  int get hashCode => const ListEquality().hash([name, video]);
}

SkillLevelStruct createSkillLevelStruct({
  String? name,
  String? video,
}) =>
    SkillLevelStruct(
      name: name,
      video: video,
    );
