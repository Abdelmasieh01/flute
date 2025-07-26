// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SkillStruct extends BaseStruct {
  SkillStruct({
    String? name,
    String? note,
    String? description,
    List<SkillLevelStruct>? exercises,
    List<SkillLevelStruct>? examples,
  })  : _name = name,
        _note = note,
        _description = description,
        _exercises = exercises,
        _examples = examples;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "note" field.
  String? _note;
  String get note => _note ?? '';
  set note(String? val) => _note = val;

  bool hasNote() => _note != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "exercises" field.
  List<SkillLevelStruct>? _exercises;
  List<SkillLevelStruct> get exercises => _exercises ?? const [];
  set exercises(List<SkillLevelStruct>? val) => _exercises = val;

  void updateExercises(Function(List<SkillLevelStruct>) updateFn) {
    updateFn(_exercises ??= []);
  }

  bool hasExercises() => _exercises != null;

  // "examples" field.
  List<SkillLevelStruct>? _examples;
  List<SkillLevelStruct> get examples => _examples ?? const [];
  set examples(List<SkillLevelStruct>? val) => _examples = val;

  void updateExamples(Function(List<SkillLevelStruct>) updateFn) {
    updateFn(_examples ??= []);
  }

  bool hasExamples() => _examples != null;

  static SkillStruct fromMap(Map<String, dynamic> data) => SkillStruct(
        name: data['name'] as String?,
        note: data['note'] as String?,
        description: data['description'] as String?,
        exercises: getStructList(
          data['exercises'],
          SkillLevelStruct.fromMap,
        ),
        examples: getStructList(
          data['examples'],
          SkillLevelStruct.fromMap,
        ),
      );

  static SkillStruct? maybeFromMap(dynamic data) =>
      data is Map ? SkillStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'note': _note,
        'description': _description,
        'exercises': _exercises?.map((e) => e.toMap()).toList(),
        'examples': _examples?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'note': serializeParam(
          _note,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'exercises': serializeParam(
          _exercises,
          ParamType.DataStruct,
          isList: true,
        ),
        'examples': serializeParam(
          _examples,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static SkillStruct fromSerializableMap(Map<String, dynamic> data) =>
      SkillStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        note: deserializeParam(
          data['note'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        exercises: deserializeStructParam<SkillLevelStruct>(
          data['exercises'],
          ParamType.DataStruct,
          true,
          structBuilder: SkillLevelStruct.fromSerializableMap,
        ),
        examples: deserializeStructParam<SkillLevelStruct>(
          data['examples'],
          ParamType.DataStruct,
          true,
          structBuilder: SkillLevelStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SkillStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SkillStruct &&
        name == other.name &&
        note == other.note &&
        description == other.description &&
        listEquality.equals(exercises, other.exercises) &&
        listEquality.equals(examples, other.examples);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([name, note, description, exercises, examples]);
}

SkillStruct createSkillStruct({
  String? name,
  String? note,
  String? description,
}) =>
    SkillStruct(
      name: name,
      note: note,
      description: description,
    );
