import '/components/icon_card/icon_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for IconCard component.
  late IconCardModel iconCardModel1;
  // Model for IconCard component.
  late IconCardModel iconCardModel2;
  // Model for IconCard component.
  late IconCardModel iconCardModel3;

  @override
  void initState(BuildContext context) {
    iconCardModel1 = createModel(context, () => IconCardModel());
    iconCardModel2 = createModel(context, () => IconCardModel());
    iconCardModel3 = createModel(context, () => IconCardModel());
  }

  @override
  void dispose() {
    iconCardModel1.dispose();
    iconCardModel2.dispose();
    iconCardModel3.dispose();
  }
}
