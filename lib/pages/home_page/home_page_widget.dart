import 'package:url_launcher/url_launcher.dart';

import '/components/icon_card/icon_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().notes.length == 0) {
        await actions.loadNotesList();
        return;
      } else {
        await actions.loadNotesList();
        return;
      }
    });

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
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: GridView(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    16.0,
                    0,
                    16.0,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.0,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context
                            .pushNamed(FluteOverviewMainPageWidget.routeName);
                      },
                      child: wrapWithModel(
                        model: _model.iconCardModel1,
                        updateCallback: () => safeSetState(() {}),
                        child: IconCardWidget(
                          text: 'آلة الناي',
                          icon: FaIcon(
                            FontAwesomeIcons.wandMagic,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(SkillsMainPageWidget.routeName);
                      },
                      child: wrapWithModel(
                        model: _model.iconCardModel2,
                        updateCallback: () => safeSetState(() {}),
                        child: IconCardWidget(
                          text: 'المهارات',
                          icon: FaIcon(
                            FontAwesomeIcons.graduationCap,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(TunerPageWidget.routeName);
                      },
                      child: wrapWithModel(
                        model: _model.iconCardModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: IconCardWidget(
                          text: 'تيونر',
                          icon: FaIcon(
                            FontAwesomeIcons.gaugeHigh,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16))),
                            builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading:
                                          FaIcon(FontAwesomeIcons.facebook),
                                      title: Text("Facebbok"),
                                      onTap: () => _launchUrl(
                                          "https://www.facebook.com/share/1AsNd8z8Th/"),
                                    ),
                                    ListTile(
                                      leading:
                                          FaIcon(FontAwesomeIcons.instagram),
                                      title: Text("Instagram"),
                                      onTap: () => _launchUrl(
                                          "https://www.instagram.com/f_lamei"),
                                    ),
                                    ListTile(
                                      leading:
                                          FaIcon(FontAwesomeIcons.whatsapp),
                                      title: Text("WhatsApp"),
                                      onTap: () => _launchUrl(
                                          "https://wa.me/201202754313"),
                                    ),
                                  ],
                                ));
                      },
                      child: wrapWithModel(
                        model: _model.iconCardModel3,
                        updateCallback: () => safeSetState(() {}),
                        child: IconCardWidget(
                          text: 'الدعم الفني',
                          icon: FaIcon(
                            FontAwesomeIcons.headphones,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _launchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}