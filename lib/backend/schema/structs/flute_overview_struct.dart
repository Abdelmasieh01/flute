// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FluteOverviewStruct extends BaseStruct {
  FluteOverviewStruct({
    String? title,
    List<FluteOverviewContentStruct>? contents,
  })  : _title = title,
        _contents = contents;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "contents" field.
  List<FluteOverviewContentStruct>? _contents;
  List<FluteOverviewContentStruct> get contents => _contents ?? const [];
  set contents(List<FluteOverviewContentStruct>? val) => _contents = val;

  void updateContents(Function(List<FluteOverviewContentStruct>) updateFn) {
    updateFn(_contents ??= []);
  }

  bool hasContents() => _contents != null;

  static FluteOverviewStruct fromMap(Map<String, dynamic> data) =>
      FluteOverviewStruct(
        title: data['title'] as String?,
        contents: getStructList(
          data['contents'],
          FluteOverviewContentStruct.fromMap,
        ),
      );

  static FluteOverviewStruct? maybeFromMap(dynamic data) => data is Map
      ? FluteOverviewStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'contents': _contents?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'contents': serializeParam(
          _contents,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static FluteOverviewStruct fromSerializableMap(Map<String, dynamic> data) =>
      FluteOverviewStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        contents: deserializeStructParam<FluteOverviewContentStruct>(
          data['contents'],
          ParamType.DataStruct,
          true,
          structBuilder: FluteOverviewContentStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'FluteOverviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is FluteOverviewStruct &&
        title == other.title &&
        listEquality.equals(contents, other.contents);
  }

  @override
  int get hashCode => const ListEquality().hash([title, contents]);
}

FluteOverviewStruct createFluteOverviewStruct({
  String? title,
}) =>
    FluteOverviewStruct(
      title: title,
    );
