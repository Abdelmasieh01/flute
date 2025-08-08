import 'package:flute/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AudioRecordPage extends StatefulWidget {
  const AudioRecordPage({super.key, required this.index});
  final int index;

  static String routeName = 'AudioRecordPage';
  static String routePath = '/audioRecordPage';
  
  @override
  _AudioRecordPageState createState() => _AudioRecordPageState();
}

class _AudioRecordPageState extends State<AudioRecordPage> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _filePath;
  bool _isSaved = false;



  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    // no storage permission on the web
    if (!kIsWeb) await Permission.storage.request();
  }

Future<void> _startRecording() async {
  if (!await _recorder.hasPermission()) return;

  // Compute a non-null file path for non-web platforms
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    _filePath =
        '${dir.path}/rec_${DateTime.now().microsecondsSinceEpoch}.m4a';
  }

  // Call .start() WITHOUT path on web, WITH a non-null path on others
  if (kIsWeb) {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      ),
      path: '',
    );
  } else {
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
      ),
      path: _filePath!,  // non-nullable here
    );                                   // :contentReference[oaicite:0]{index=0}
  }

  setState(() {
    _isRecording = true;
    _isSaved = false;
  });
}


  Future<void> _stopRecording() async {
    final result = await _recorder.stop();  // on web this is a Blob URL
    // if web, store that URL so you could download/play if needed
    if (kIsWeb && result != null) _filePath = result;
    setState(() => _isRecording = false);
  }

  void _saveRecording() {
    if (_filePath == null) return;
    setState(() => _isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التسجيل!')),
    );
  }

  Future<void> _shareFile() async {
    if (!_isSaved || _filePath == null) return;
    final params = ShareParams(
      text: 
          'تسجيل لتمرين: ${FFAppState().skills.elementAt(widget.index).name}',
      files: [XFile(_filePath!)]
    );

    await SharePlus.instance.share(params);
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // centers both vertically & horizontally
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min, // wrap content
                children: [
                  FaIcon(
                    _isRecording
                        ? FontAwesomeIcons.microphone
                        : FontAwesomeIcons.microphoneSlash,
                    size: 80,
                    color: _isRecording ? Colors.red : Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  _buildButton(
                    icon: _isRecording ? Icons.stop : Icons.fiber_manual_record,
                    label: _isRecording ? 'إيقاف التسجيل' : 'بدء التسجيل',
                    onPressed: () async {
                      if (_isRecording) {
                        await _stopRecording();
                      } else {
                        await _startRecording();
                      }
                    },
                    color: _isRecording ? Colors.red : Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    icon: Icons.save,
                    label: 'حفظ التسجيل',
                    onPressed:
                        (!_isRecording && _filePath != null) ? _saveRecording : null,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    icon: Icons.share,
                    label: 'مشاركة الملف',
                    onPressed: _isSaved ? _shareFile : null,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16),
        elevation: 2,
      ),
    );
  }
}
