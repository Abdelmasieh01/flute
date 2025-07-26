// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '../../app_state.dart';

Future<void> loadNotesList() async {
  final notes = [
    {"name": "Do3", "frequency": 130.81, "image": "assets/images/fl-1.png"},
    {"name": "Do#3", "frequency": 138.59, "image": "assets/images/fl-8.png"},
    {"name": "Re3", "frequency": 146.83, "image": "assets/images/fl-2.png"},
    {"name": "Mi♭3", "frequency": 155.56, "image": "assets/images/fl-3.png"},
    {"name": "Mi3", "frequency": 164.81, "image": "assets/images/fl-9.png"},
    {"name": "Fa3", "frequency": 174.61, "image": "assets/images/fl-5.png"},
    {"name": "Fa#3", "frequency": 185.0, "image": "assets/images/fl-6.png"},
    {"name": "Sol3", "frequency": 196.0, "image": "assets/images/fl-7.png"},
    // {"name": "La♭3", "frequency": 207.65, "image": "assets/images/fl-1.png"},
    {"name": "La3", "frequency": 220.0, "image": "assets/images/fl-10.png"},
    {"name": "Si♭3", "frequency": 233.08, "image": "assets/images/fl-11.png"},
    {"name": "Si3", "frequency": 246.94, "image": "assets/images/fl-12.png"},
    {"name": "Do4", "frequency": 261.63, "image": "assets/images/fl-1.png"},
    {"name": "Do#4", "frequency": 277.18, "image": "assets/images/fl-8.png"},
    {"name": "Re4", "frequency": 293.66, "image": "assets/images/fl-2.png"},
    {"name": "Mi♭4", "frequency": 311.13, "image": "assets/images/fl-3.png"},
    {"name": "Mi4", "frequency": 329.63, "image": "assets/images/fl-9.png"},
    {"name": "Fa4", "frequency": 349.23, "image": "assets/images/fl-5.png"},
    {"name": "Fa#4", "frequency": 369.99, "image": "assets/images/fl-6.png"},
    {"name": "Sol4", "frequency": 392.0, "image": "assets/images/fl-7.png"},
    {"name": "La♭4", "frequency": 415.3, "image": "assets/images/fl-8.png"},
    {"name": "La4", "frequency": 440.0, "image": "assets/images/fl-2.png"},
    {"name": "Si♭4", "frequency": 466.16, "image": "assets/images/fl-3.png"},
    {"name": "Si4", "frequency": 493.88, "image": "assets/images/fl-9.png"},
    {"name": "Do5", "frequency": 523.25, "image": "assets/images/fl-5.png"},
    {"name": "Do#5", "frequency": 554.37, "image": "assets/images/fl-6.png"},
    {"name": "Re5", "frequency": 587.33, "image": "assets/images/fl-7.png"},
    {"name": "Mi♭5", "frequency": 622.25, "image": "assets/images/fl-3.png"},
    {"name": "Mi5", "frequency": 659.25, "image": "assets/images/fl-9.png"},
    {"name": "Fa5", "frequency": 698.46, "image": "assets/images/fl-5.png"},
    {"name": "Fa#5", "frequency": 739.99, "image": "assets/images/fl-6.png"},
    {"name": "Sol5", "frequency": 783.99, "image": "assets/images/fl-7.png"},
    // {"name": "Sol#5", "frequency": 830.61, "image": "assets/images/fl-1.png"},
    // {"name": "La5", "frequency": 880.0, "image": "assets/images/fl-1.png"},
    // {"name": "Si♭5", "frequency": 932.33, "image": "assets/images/fl-1.png"},
    // {"name": "Si5", "frequency": 987.77, "image": "assets/images/fl-1.png"},
  ];

  final noteStructList = notes
      .map((note) => NoteStruct(
            name: note['name'] as String,
            frequency: note['frequency'] as double,
            image: note['image'] as String,
          ))
      .toList();

  FFAppState().update(() {
    FFAppState().notes = noteStructList;
  });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
