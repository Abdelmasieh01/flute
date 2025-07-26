// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// // Automatic FlutterFlow imports
// import '/backend/schema/structs/index.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/custom_code/widgets/index.dart'; // Imports other custom widgets
// import '/custom_code/actions/index.dart'; // Imports custom actions
// import '/flutter_flow/custom_functions.dart'; // Imports custom functions
// import 'package:flutter/material.dart';
// // Begin custom widget code
// // DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// import 'index.dart'; // Imports other custom widgets

// // Required imports for the tuner functionality
// import 'dart:async';
// import 'package:pitch_detector_dart/pitch_detector.dart';
// import 'package:pitch_detector_dart/pitch_detector_result.dart';
// import 'dart:math' as math; // For pow function

// // Import for web-specific audio handling
// import 'dart:html' as html;
// import 'package:flutter/foundation.dart' show kIsWeb;

// class WebFluteTunerWidget extends StatefulWidget {
//   const WebFluteTunerWidget({
//     Key? key,
//     this.width,
//     this.height,
//   }) : super(key: key);

//   final double? width;
//   final double? height;

//   @override
//   _WebFluteTunerWidgetState createState() => _WebFluteTunerWidgetState();
// }

// class _WebFluteTunerWidgetState extends State<WebFluteTunerWidget> {
//   bool _hasPermission = false;
//   PitchDetector? _pitchDetector;
//   StreamSubscription<PitchDetectorResult>? _pitchSubscription;

//   html.MediaStream? _mediaStream;
//   html.AudioContext? _audioContext;
//   html.AnalyserNode? _analyserNode;
//   Timer? _analysisTimer;

//   String _note = '';
//   String _status = 'Tap to start';
//   double _frequency = 0.0;
//   bool _isRecording = false;

//   // Standard frequencies for common flute notes (A4 = 440 Hz)
//   final Map<String, double> _standardFluteNotes = {
//     'C4': 261.63, 'C#4': 277.18, 'D4': 293.66, 'D#4': 311.13, 'E4': 329.63,
//     'F4': 349.23,
//     'F#4': 369.99, 'G4': 392.00, 'G#4': 415.30, 'A4': 440.00, 'A#4': 466.16,
//     'B4': 493.88,
//     'C5': 523.25, 'C#5': 554.37, 'D5': 587.33, 'D#5': 622.25, 'E5': 659.25,
//     'F5': 698.46,
//     'F#5': 739.99, 'G5': 783.99, 'G#5': 830.61, 'A5': 880.00, 'A#5': 932.33,
//     'B5': 987.77,
//     'C6': 1046.50,
//     // Add more notes as needed
//   };

//   @override
//   void initState() {
//     super.initState();
//     if (kIsWeb) {
//       // Initial permission check can be done here, or implicitly when starting
//     } else {
//       setState(() {
//         _status = 'This widget is intended for web use.';
//       });
//     }
//   }

//   Future<void> _requestPermissionAndInit() async {
//     if (!kIsWeb) return;

//     try {
//       // Request microphone permission
//       _mediaStream = await html.window.navigator.mediaDevices
//           ?.getUserMedia({'audio': true});
//       if (_mediaStream != null) {
//         setState(() {
//           _hasPermission = true;
//           _status = 'Permission granted. Tap to start.';
//         });
//         _initPitchDetectorAndAudioNodes();
//       } else {
//         setState(() {
//           _hasPermission = false;
//           _status = 'Microphone permission denied.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _hasPermission = false;
//         _status = 'Error getting microphone: ${e.toString()}';
//       });
//     }
//   }

//   void _initPitchDetectorAndAudioNodes() {
//     if (_mediaStream == null || !_hasPermission) return;

//     _audioContext = html.AudioContext();
//     _analyserNode = _audioContext!.createAnalyser();
//     _analyserNode!.fftSize = 2048; // Standard FFT size for pitch detection

//     final source = _audioContext!.createMediaStreamSource(_mediaStream!);
//     source.connectNode(_analyserNode!);
//     // Do not connect analyser to destination to avoid feedback (hearing raw mic input)

//     _pitchDetector = PitchDetector(
//         sampleRate: _audioContext!.sampleRate.toDouble(),
//         sampleSize: _analyserNode!
//             .frequencyBinCount); // sampleSize for PitchDetector is fftSize/2

//     _pitchSubscription = _pitchDetector!.onDetect.listen((result) {
//       if (mounted && result.pitched) {
//         final detectedNote = PitchConverter.hertzToNearestNote(result.pitch);
//         setState(() {
//           _frequency = result.pitch;
//           _note = detectedNote;
//           _status = _getTuningStatus(detectedNote, result.pitch);
//         });
//       }
//     });
//   }

//   void _processAudio() {
//     if (_analyserNode == null || _pitchDetector == null || !_isRecording)
//       return;

//     final bufferLength =
//         _analyserNode!.frequencyBinCount; // This is fftSize / 2
//     final dataArray = html.Float32List(bufferLength);
//     _analyserNode!.getFloatTimeDomainData(dataArray);

//     // Convert Float32List to List<double> for pitch_detector_dart
//     final List<double> audioSamples = dataArray.toList().cast<double>();
//     _pitchDetector!.add(audioSamples);
//   }

//   Future<void> _startRecording() async {
//     if (!kIsWeb) {
//       setState(() => _status = "Web only widget.");
//       return;
//     }
//     if (!_hasPermission) {
//       await _requestPermissionAndInit();
//       // If permission is now granted, _initPitchDetectorAndAudioNodes would have been called.
//       // We might need another check here or rely on the user tapping again if init wasn't immediate.
//       if (!_hasPermission) {
//         setState(() => _status = "Permission required to start.");
//         return;
//       }
//     }

//     // Ensure audio context and nodes are ready
//     if (_audioContext == null ||
//         _analyserNode == null ||
//         _pitchDetector == null) {
//       _initPitchDetectorAndAudioNodes(); // Attempt to re-initialize
//       if (_audioContext == null) {
//         // Still not initialized
//         setState(() => _status = "Audio context failed. Try refreshing.");
//         return;
//       }
//     }

//     // Resume AudioContext if it was suspended (common browser behavior)
//     if (_audioContext?.state == 'suspended') {
//       await _audioContext?.resume();
//     }

//     _analysisTimer?.cancel();
//     _analysisTimer = Timer.periodic(Duration(milliseconds: 100), (Timer t) {
//       _processAudio();
//     });

//     setState(() {
//       _status = 'Listening...';
//       _isRecording = true;
//     });
//   }

//   Future<void> _stopRecording() async {
//     _analysisTimer?.cancel();
//     _analysisTimer = null;

//     // Stop media tracks to turn off microphone indicator
//     _mediaStream?.getAudioTracks().forEach((track) => track.stop());
//     _mediaStream = null; // Release the stream

//     // Close audio context
//     await _audioContext?.close();
//     _audioContext = null;
//     _analyserNode = null;

//     _pitchSubscription?.cancel();
//     _pitchDetector?.dispose(); // Dispose pitch detector
//     _pitchDetector = null;

//     if (mounted) {
//       setState(() {
//         _status = 'Tap to start';
//         _note = '';
//         _frequency = 0.0;
//         _isRecording = false;
//         _hasPermission =
//             false; // Reset permission status to require re-request for next start
//       });
//     }
//   }

//   String _getTuningStatus(String detectedNoteName, double currentFrequency) {
//     if (detectedNoteName.isEmpty) return '...';

//     double targetFrequency = 0;
//     String closestStandardNoteKey = '';
//     double minDifference = double.infinity;

//     // Find the closest note in our reference map
//     _standardFluteNotes.forEach((noteKey, freq) {
//       double difference = (freq - currentFrequency).abs();
//       if (difference < minDifference) {
//         minDifference = difference;
//         targetFrequency = freq;
//         closestStandardNoteKey = noteKey;
//       }
//     });

//     // If the detected note name (e.g. "A4") is in our map, prioritize its frequency
//     // This handles cases where PitchConverter's nearest note might be slightly off
//     // from our defined standard, but we still want to compare against our standard for that note.
//     if (_standardFluteNotes.containsKey(detectedNoteName)) {
//       targetFrequency = _standardFluteNotes[detectedNoteName]!;
//     } else if (closestStandardNoteKey.isNotEmpty) {
//       // If detectedNoteName is not in map, use the absolutely closest one found
//       // (targetFrequency is already set from the loop)
//     } else {
//       // Fallback if no note is found (should be rare if _standardFluteNotes is comprehensive enough)
//       return "Note not in reference";
//     }

//     if (targetFrequency == 0) return "Note not in reference";

//     // Tolerance in cents. 10 cents is a common threshold.
//     // Cents = 1200 * log2(f2/f1)
//     // So, f2/f1 = 2^(cents/1200)
//     // We check if currentFrequency is within targetFrequency * 2^(+/-cents/1200)
//     double centsTolerance = 10.0; // +/- 10 cents
//     double lowerBound = targetFrequency * math.pow(2, -centsTolerance / 1200);
//     double upperBound = targetFrequency * math.pow(2, centsTolerance / 1200);

//     if (currentFrequency >= lowerBound && currentFrequency <= upperBound) {
//       return 'In Tune';
//     } else if (currentFrequency > upperBound) {
//       return 'Sharp';
//     } else {
//       return 'Flat';
//     }
//   }

//   @override
//   void dispose() {
//     _stopRecording(); // Ensure all resources are released
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!kIsWeb) {
//       return Container(
//         width: widget.width ?? double.infinity,
//         height: widget.height ?? 300,
//         alignment: Alignment.center,
//         child: Text(
//           'This tuner widget is designed for Web.',
//           style: FlutterFlowTheme.of(context).bodyMedium,
//         ),
//       );
//     }

//     return Container(
//       width: widget.width ?? double.infinity,
//       height: widget.height ?? 300,
//       padding: EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: FlutterFlowTheme.of(context).secondaryBackground,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 4,
//             color: Color(0x33000000),
//             offset: Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Flute Tuner (Web)',
//             style: FlutterFlowTheme.of(context).headlineMedium,
//           ),
//           if (!_hasPermission && !_isRecording)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Text(
//                 _status, // Shows permission status or "Tap to start"
//                 style: FlutterFlowTheme.of(context).bodyMedium.override(
//                       fontFamily: 'Readex Pro',
//                       color: FlutterFlowTheme.of(context).error,
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//             ),

//           // Always show the note display area if permission has been granted at least once or is recording
//           if (_hasPermission || _isRecording)
//             Column(
//               children: [
//                 Text(
//                   _note.isNotEmpty ? _note : '--',
//                   style: FlutterFlowTheme.of(context).displayLarge.override(
//                         fontFamily: 'Outfit',
//                         fontSize: 64,
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 Text(
//                   '${_frequency.toStringAsFixed(2)} Hz',
//                   style: FlutterFlowTheme.of(context).bodyLarge,
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   _isRecording
//                       ? _status
//                       : (_hasPermission
//                           ? 'Tap to start'
//                           : 'Request Permission'),
//                   style: FlutterFlowTheme.of(context).titleMedium.override(
//                         fontFamily: 'Readex Pro',
//                         color: _status == 'In Tune'
//                             ? Colors.green
//                             : (_status == 'Sharp' || _status == 'Flat'
//                                 ? Colors.orange
//                                 : FlutterFlowTheme.of(context).primaryText),
//                       ),
//                 ),
//               ],
//             ),

//           ElevatedButton(
//             onPressed: () {
//               if (_isRecording) {
//                 _stopRecording();
//               } else {
//                 if (_hasPermission) {
//                   _startRecording();
//                 } else {
//                   _requestPermissionAndInit(); // This will request permission and then user might need to tap again
//                 }
//               }
//             },
//             child: Text(
//               _isRecording
//                   ? 'Stop Tuning'
//                   : (_hasPermission ? 'Start Tuning' : 'Enable Mic & Start'),
//               style: FlutterFlowTheme.of(context).titleSmall.override(
//                     fontFamily: 'Readex Pro',
//                     color: Colors.white,
//                   ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _isRecording
//                   ? FlutterFlowTheme.of(context).error
//                   : FlutterFlowTheme.of(context).primary,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               textStyle: FlutterFlowTheme.of(context).titleSmall,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// // DO NOT REMOVE OR MODIFY THE CODE BELOW!
// // End custom widget code
