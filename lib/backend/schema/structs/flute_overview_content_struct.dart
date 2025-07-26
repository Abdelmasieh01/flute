// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FluteOverviewContentStruct extends BaseStruct {
  FluteOverviewContentStruct({
    String? title,
    String? content,
  })  : _title = title,
        _content = content;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  static FluteOverviewContentStruct fromMap(Map<String, dynamic> data) =>
      FluteOverviewContentStruct(
        title: data['title'] as String?,
        content: data['content'] as String?,
      );

  static FluteOverviewContentStruct? maybeFromMap(dynamic data) => data is Map
      ? FluteOverviewContentStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'content': _content,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
      }.withoutNulls;

  static FluteOverviewContentStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      FluteOverviewContentStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'FluteOverviewContentStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FluteOverviewContentStruct &&
        title == other.title &&
        content == other.content;
  }

  @override
  int get hashCode => const ListEquality().hash([title, content]);
}

FluteOverviewContentStruct createFluteOverviewContentStruct({
  String? title,
  String? content,
}) =>
    FluteOverviewContentStruct(
      title: title,
      content: content,
    );
