// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NoteStruct extends BaseStruct {
  NoteStruct({
    String? name,
    double? frequency,
    String? image,
  })  : _name = name,
        _frequency = frequency,
        _image = image;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "frequency" field.
  double? _frequency;
  double get frequency => _frequency ?? 0.0;
  set frequency(double? val) => _frequency = val;

  void incrementFrequency(double amount) => frequency = frequency + amount;

  bool hasFrequency() => _frequency != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  static NoteStruct fromMap(Map<String, dynamic> data) => NoteStruct(
        name: data['name'] as String?,
        frequency: castToType<double>(data['frequency']),
        image: data['image'] as String?,
      );

  static NoteStruct? maybeFromMap(dynamic data) =>
      data is Map ? NoteStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'frequency': _frequency,
        'image': _image,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'frequency': serializeParam(
          _frequency,
          ParamType.double,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
      }.withoutNulls;

  static NoteStruct fromSerializableMap(Map<String, dynamic> data) =>
      NoteStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        frequency: deserializeParam(
          data['frequency'],
          ParamType.double,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'NoteStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NoteStruct &&
        name == other.name &&
        frequency == other.frequency &&
        image == other.image;
  }

  @override
  int get hashCode => const ListEquality().hash([name, frequency, image]);
}

NoteStruct createNoteStruct({
  String? name,
  double? frequency,
  String? image,
}) =>
    NoteStruct(
      name: name,
      frequency: frequency,
      image: image,
    );
