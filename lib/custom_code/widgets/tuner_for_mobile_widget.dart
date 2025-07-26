// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flute/flutter_flow/flutter_flow_widgets.dart';

// Custom imports
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:audio_streamer/audio_streamer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';

class TunerForMobileWidget extends StatefulWidget {
  const TunerForMobileWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _TunerForMobileWidgetState createState() => _TunerForMobileWidgetState();
}

class _TunerForMobileWidgetState extends State<TunerForMobileWidget> {
  // كاشف درجة الصوت - يستخدم لتحليل الترددات الصوتية
  final PitchDetector _pitchDetector = PitchDetector();

  // متغيرات حالة التطبيق
  bool _isRecording = false; // هل التطبيق يسجل حالياً؟
  bool _isInitialized = false; // هل تم تهيئة التطبيق بنجاح؟
  bool _isInitializing = false; // هل التطبيق في مرحلة التهيئة؟

  // متغيرات عرض البيانات
  String _detectedNote = '--'; // النغمة المكتشفة
  double _currentFrequency = 0.0; // التردد الحالي بالهرتز
  String _feedbackText = 'اضغط للبدء'; // نص التغذية الراجعة للمستخدم
  Color _feedbackColor = Colors.grey; // لون التغذية الراجعة

  // المؤقتات والاشتراكات
  Timer? _feedbackTimer; // مؤقت للتغذية الراجعة
  Timer? _analysisTimer; // مؤقت لتحليل الصوت
  StreamSubscription<List<double>>? _audioSubscription; // اشتراك في تدفق الصوت

  // متغيرات معالجة الصوت
  final List<double> _audioBuffer = []; // مخزن البيانات الصوتية المؤقت
  int? _sampleRate; // معدل العينات الصوتية

  // إعدادات التحليل الصوتي
  static const int _analysisIntervalMs =
      100; // فترة تحليل الصوت بالميلي ثانية (يمكن تغييرها لتسريع أو إبطاء التحليل)
  static const int _bufferSizeMs = 300; // حجم المخزن المؤقت بالميلي ثانية

  // متغيرات تنعيم النتائج
  double _lastValidFrequency = 0.0; // آخر تردد صالح تم اكتشافه
  DateTime _lastValidFrequencyTime = DateTime.now(); // وقت آخر تردد صالح
  final List<double> _recentFrequencies = []; // قائمة الترددات الأخيرة للتنعيم

  // خريطة النغمات وترددها - تحتوي على النغمات الموسيقية الأساسية
  static const Map<String, double> noteFrequencies = {
    'C4': 261.63,
    'C#4': 277.18,
    'D4': 293.66,
    'D#4': 311.13,
    'E4': 329.63,
    'F4': 349.23,
    'F#4': 369.99,
    'G4': 392.00,
    'G#4': 415.30,
    'A4': 440.00,
    'A#4': 466.16,
    'B4': 493.88,
    'C5': 523.25,
    'C#5': 554.37,
    'D5': 587.33,
    'D#5': 622.25,
    'E5': 659.25,
    'F5': 698.46,
    'F#5': 739.99,
    'G5': 783.99,
    'G#5': 830.61,
    'A5': 880.00,
    'A#5': 932.33,
    'B5': 987.77,
    'C6': 1046.50,
  };

  // الحد الأقصى لتاريخ الترددات المحفوظة للتنعيم
  static const int maxFrequencyHistory = 7;

  @override
  void initState() {
    super.initState();
    _initializeApp(); // بدء تهيئة التطبيق
  }

  /// تهيئة التطبيق وطلب الأذونات اللازمة
  Future<void> _initializeApp() async {
    if (_isInitializing) return;

    setState(() {
      _isInitializing = true;
      _feedbackText = 'جاري التهيئة...';
      _feedbackColor = Colors.orange;
    });

    await _requestPermissions();
  }

  /// طلب أذونات الميكروفون من المستخدم
  Future<void> _requestPermissions() async {
    try {
      final micStatus = await Permission.microphone.request();

      if (micStatus == PermissionStatus.granted) {
        await _initializeAudio();
      } else {
        setState(() {
          _feedbackText = 'تم رفض إذن الميكروفون';
          _feedbackColor = Colors.red;
          _isInitializing = false;
        });
      }
    } catch (e) {
      setState(() {
        _feedbackText = 'خطأ في الأذونات: ${e.toString()}';
        _feedbackColor = Colors.red;
        _isInitializing = false;
      });
    }
  }

  /// تهيئة إعدادات الصوت
  Future<void> _initializeAudio() async {
    try {
      AudioStreamer().sampleRate = 44100; // تحديد معدل العينات الصوتية

      setState(() {
        _isInitialized = true;
        _isInitializing = false;
        _feedbackText = 'جاهز للبدء!';
        _feedbackColor = Colors.green;
      });
    } catch (e) {
      setState(() {
        _isInitialized = false;
        _isInitializing = false;
        _feedbackText = 'فشل في تهيئة الميكروفون';
        _feedbackColor = Colors.red;
      });
    }
  }

  /// معالج استقبال البيانات الصوتية
  void _onAudio(List<double> buffer) async {
    if (!_isRecording) return;
    _audioBuffer.addAll(buffer); // إضافة البيانات الصوتية للمخزن المؤقت
    _sampleRate ??= await AudioStreamer().actualSampleRate;
  }

  /// معالج أخطاء التسجيل الصوتي
  void _handleError(Object error) {
    setState(() => _isRecording = false);
    setState(() {
      _feedbackText = 'خطأ في التسجيل';
      _feedbackColor = Colors.red;
    });
  }

  /// بدء عملية التسجيل والتحليل الصوتي
  Future<void> _startRecording() async {
    try {
      _cleanupAudioData(); // تنظيف البيانات القديمة

      // الاشتراك في تدفق البيانات الصوتية
      _audioSubscription = AudioStreamer().audioStream.listen(
            _onAudio,
            onError: _handleError,
          );

      // إنشاء مؤقت لتحليل الصوت كل 100 ميلي ثانية
      _analysisTimer = Timer.periodic(
        Duration(milliseconds: _analysisIntervalMs),
        (timer) {
          if (!_isRecording) {
            timer.cancel();
            return;
          }
          _analyzeAudio(); // تحليل البيانات الصوتية
        },
      );

      setState(() {
        _isRecording = true;
        _feedbackText = 'استمع...';
        _feedbackColor = Colors.orange;
      });
    } catch (e) {
      setState(() {
        _feedbackText = 'خطأ في بدء التسجيل';
        _feedbackColor = Colors.red;
        _isRecording = false;
      });
    }
  }

  /// تحليل البيانات الصوتية واكتشاف النغمة
  void _analyzeAudio() async {
    if (!_isRecording || _sampleRate == null || _audioBuffer.isEmpty) {
      return;
    }

    try {
      final bufferSizeSamples = (_sampleRate! * _bufferSizeMs / 1000).round();

      if (_audioBuffer.length < bufferSizeSamples) {
        return;
      }

      // أخذ عينة من البيانات للتحليل
      final samplesToAnalyze = _audioBuffer.take(bufferSizeSamples).toList();
      final samplesToRemove = (bufferSizeSamples * 0.5).round();
      if (_audioBuffer.length >= samplesToRemove) {
        _audioBuffer.removeRange(0, samplesToRemove);
      }

      // تحويل البيانات وتحليلها
      final intBuffer = _convertToInt16Buffer(samplesToAnalyze);
      final detectedPitch =
          await _pitchDetector.getPitchFromIntBuffer(intBuffer);

      // التحقق من صحة النتيجة
      if (detectedPitch.pitched &&
          detectedPitch.pitch > 200 &&
          detectedPitch.pitch < 1200 &&
          !detectedPitch.pitch.isNaN &&
          !detectedPitch.pitch.isInfinite) {
        _lastValidFrequency = detectedPitch.pitch;
        _lastValidFrequencyTime = DateTime.now();
        _addFrequencyToHistory(detectedPitch.pitch);
        final smoothedFrequency = _getSmoothedFrequency();

        if (mounted && smoothedFrequency > 0 && _isRecording) {
          setState(() {
            _currentFrequency = smoothedFrequency;
            _detectedNote = _getClosestNote(smoothedFrequency);
            _updateFeedback();
          });
        }
      } else {
        // إذا لم يتم اكتشاف تردد صالح لفترة طويلة
        final timeSinceLastValid =
            DateTime.now().difference(_lastValidFrequencyTime).inMilliseconds;
        if (timeSinceLastValid > 1000 && _isRecording) {
          if (mounted) {
            setState(() {
              _currentFrequency = 0.0;
              _detectedNote = '--';
              _feedbackText = 'استمع...';
              _feedbackColor = Colors.orange;
            });
          }
        }
      }
    } catch (e) {
      // معالجة الأخطاء بصمت
    }
  }

  /// تحويل البيانات الصوتية إلى تنسيق Int16
  Uint8List _convertToInt16Buffer(List<double> audioData) {
    final samples = <int>[];
    for (double sample in audioData) {
      int intSample = (sample.clamp(-1.0, 1.0) * 32767).round();
      samples.add(intSample & 0xFF);
      samples.add((intSample >> 8) & 0xFF);
    }
    return Uint8List.fromList(samples);
  }

  /// العثور على أقرب نغمة موسيقية للتردد المكتشف
  String _getClosestNote(double frequency) {
    if (frequency <= 0) return '--';

    String closestNote = 'C4';
    double minDifference = double.infinity;

    noteFrequencies.forEach((note, freq) {
      double difference = (frequency - freq).abs();
      if (difference < minDifference) {
        minDifference = difference;
        closestNote = note;
      }
    });

    return closestNote;
  }

  /// حساب الفرق بالسنت بين التردد المكتشف والنغمة المستهدفة
  double _getCentsDifference() {
    if (_detectedNote == '--' || _currentFrequency <= 0) return 0.0;
    final targetFreq = noteFrequencies[_detectedNote]!;
    return 1200 * (math.log(_currentFrequency / targetFreq) / math.log(2));
  }

  /// إيقاف التسجيل وتنظيف الموارد
  Future<void> _stopRecording() async {
    try {
      setState(() => _isRecording = false);
      _analysisTimer?.cancel();
      _analysisTimer = null;
      _feedbackTimer?.cancel();
      _feedbackTimer = null;
      await _audioSubscription?.cancel();
      _audioSubscription = null;
      _cleanupAudioData();

      setState(() {
        _feedbackText = 'تم إيقاف التسجيل';
        _feedbackColor = Colors.grey;
        _currentFrequency = 0.0;
        _detectedNote = '--';
      });
    } catch (e) {
      // معالجة الأخطاء
    }
  }

  /// تنظيف البيانات الصوتية والمتغيرات
  void _cleanupAudioData() {
    _audioBuffer.clear();
    _recentFrequencies.clear();
    _lastValidFrequency = 0.0;
    _lastValidFrequencyTime = DateTime.now();
  }

  /// إضافة تردد جديد لتاريخ الترددات للتنعيم
  void _addFrequencyToHistory(double frequency) {
    if (frequency > 0 && !frequency.isNaN && !frequency.isInfinite) {
      _recentFrequencies.add(frequency);
      if (_recentFrequencies.length > maxFrequencyHistory) {
        _recentFrequencies.removeAt(0);
      }
    }
  }

  /// حساب التردد المنعم باستخدام الوسيط
  double _getSmoothedFrequency() {
    if (_recentFrequencies.isEmpty) return 0.0;

    List<double> validFreqs = _recentFrequencies
        .where((f) => f > 0 && !f.isNaN && !f.isInfinite)
        .toList();

    if (validFreqs.isEmpty) return 0.0;

    validFreqs.sort();
    if (validFreqs.length % 2 == 0) {
      return (validFreqs[validFreqs.length ~/ 2 - 1] +
              validFreqs[validFreqs.length ~/ 2]) /
          2;
    } else {
      return validFreqs[validFreqs.length ~/ 2];
    }
  }

  /// تحديث نص ولون التغذية الراجعة حسب دقة الضبط
  void _updateFeedback() {
    if (_currentFrequency <= 0 || _detectedNote == '--') {
      _feedbackText = 'استمع...';
      _feedbackColor = Colors.orange;
      return;
    }

    final cents = _getCentsDifference();

    if (cents.abs() <= 10) {
      _feedbackText = '🎯 ممتاز!';
      _feedbackColor = Colors.green;
    } else if (cents > 10) {
      _feedbackText = '📉 عالي';
      _feedbackColor = Colors.red;
    } else {
      _feedbackText = '📈 منخفض';
      _feedbackColor = Colors.blue;
    }
  }

  /// تبديل حالة التسجيل (بدء/إيقاف)
  void _toggleRecording() async {
    if (!_isInitialized) {
      if (!_isInitializing) {
        await _initializeApp();
      }
      return;
    }

    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: EdgeInsets.all(12), // تقليل المساحة الداخلية
      child: Column(
        children: [
          // صف يحتوي على النغمة المكتشفة والبعد عن النغمة - بنفس الحجم
          Expanded(
            flex: 3, // 3/7 من المساحة المتاحة
            child: Row(
              children: [
                // Container الأول - النغمة المكتشفة
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(right: 6), // تقليل المسافة
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // عنوان القسم
                        Text(
                          'النغمة المكتشفة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6), // تقليل المسافة
                        // النغمة المكتشفة
                        Text(
                          _detectedNote,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _detectedNote != '--'
                                ? Colors.green[700]
                                : Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 2), // تقليل المسافة
                        // التردد بالهرتز
                        Text(
                          '${_currentFrequency.toStringAsFixed(2)} Hz',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Container الثاني - البعد عن النغمة
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(left: 6), // تقليل المسافة
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // عنوان القسم
                        Text(
                          'البعد عن النغمة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6), // تقليل المسافة
                        // قيمة البعد بالسنت
                        Text(
                          '${_getCentsDifference().toStringAsFixed(0)} Cent',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getCentsDifference().abs() <= 10
                                ? Colors.green[700]
                                : Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12), // تقليل المسافة

          // Container التغذية الراجعة
          Expanded(
            flex: 2, // 2/7 من المساحة المتاحة
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _feedbackText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _feedbackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: 12), // تقليل المسافة

          // زر البدء/الإيقاف
          Expanded(
            flex: 2, // 2/7 من المساحة المتاحة
            child: Container(
              width: double.infinity,
              child: FFButtonWidget(
                onPressed: _isInitializing ? null : _toggleRecording,
                text: _isInitializing
                    ? 'جاري التحميل...'
                    : (_isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل'),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: double.infinity, // استخدام كامل المساحة المتاحة
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  color: _isRecording
                      ? Colors.red[600]
                      : (_isInitializing ? Colors.grey : Colors.green[600]),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                  elevation: 4,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // تنظيف جميع الموارد عند إغلاق الواجهة
    _feedbackTimer?.cancel();
    _analysisTimer?.cancel();
    _audioSubscription?.cancel();
    super.dispose();
  }
}
