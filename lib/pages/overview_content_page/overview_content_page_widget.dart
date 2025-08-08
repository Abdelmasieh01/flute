import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'overview_content_page_model.dart';
export 'overview_content_page_model.dart';

class OverviewContentPageWidget extends StatefulWidget {
  const OverviewContentPageWidget({
    super.key,
    required this.index,
  });

  final int? index;

  static String routeName = 'OverviewContentPage';
  static String routePath = '/overviewContentPage';

  @override
  State<OverviewContentPageWidget> createState() =>
      _OverviewContentPageWidgetState();
}

class _OverviewContentPageWidgetState extends State<OverviewContentPageWidget> {
  late OverviewContentPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OverviewContentPageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/flute.jpg',
              ).image,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8.0, 16.0, 8.0, 16.0),
            child: SafeArea(
              child: Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Builder(
                    builder: (context) {
                      final contentList = FFAppState()
                              .fluteOverviewLessons
                              .elementAtOrNull(widget.index!)
                              ?.contents
                              .toList() ??
                          [];

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount:
                            contentList.length + 1, // +1 for the title at top
                        separatorBuilder: (_, __) => SizedBox(height: 16.0),
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .backgroundTransparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    FFAppState()
                                        .fluteOverviewLessons
                                        .elementAtOrNull(widget.index!)
                                        ?.title,
                                    'Title',
                                  ),
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineLarge,
                                ),
                              ),
                            );
                          }

                          final content = contentList[index - 1];
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .backgroundTransparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content.title,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    content.content,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
