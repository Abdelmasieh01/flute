import 'dart:io';
import 'dart:convert';
import 'package:flute/flutter_flow/flutter_flow_theme.dart';
import 'package:flute/flutter_flow/nav/nav.dart';
import 'package:flute/pages/home_page/home_page_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  static String routeName = 'LockPage';
  static String routePath = '/lockpage';

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final _keyController = TextEditingController();
  String _deviceId = '';
  final _secretKey = 'f=)f+ce3b87_lg6-uk+ym5*0(=!+rk_qm)5rp#kwmfe67mk#8k';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initDeviceId();
  }

  Future<String> _getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      return 'geIyn1HhrI'; // fixed key for web testing
    }

    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;
      return info.id ?? 'geIyn1HhrI';
    } else if (Platform.isIOS) {
      var info = await deviceInfo.iosInfo;
      return info.identifierForVendor ?? 'geIyn1HhrI';
    } else {
      return 'geIyn1HhrI';
    }
  }

  Future<void> _initDeviceId() async {
    String id = await _getDeviceId();

    setState(() {
      _deviceId = id;
      _loading = false;
    });
  }

  bool _verifyKey(String enteredKey) {
    final parts = enteredKey.split(':');
    if (parts.length != 2) return false;

    final expiry = parts[0];
    final sig = parts[1];

    // Check expiry
    final now = DateTime.now();
    final expDate = DateTime.tryParse(expiry);
    if (expDate == null || now.isAfter(expDate)) return false;

    // Validation
    final data = '$_deviceId|$expiry';
    final hmacSha256 = Hmac(sha256, utf8.encode(_secretKey));
    final digest = hmacSha256.convert(utf8.encode(data)).toString();

    return sig == digest;
  }

  void _unlock() async {
    final enteredKey = _keyController.text.trim();
    if (_verifyKey(enteredKey)) {
      final prefs = await SharedPreferences.getInstance();

      final parts = enteredKey.split(':');
      if (parts.isNotEmpty) {
        await prefs.setBool('activated', true);
        await prefs.setString('expiryDate', parts[0]);
        final expiryDate = DateTime.tryParse(parts[0]);
        AppStateNotifier.instance.setActivated(true, expiry: expiryDate);
      }
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('الشفرة غير صحيحة'),
          content: const Text(
              'لقد قمت بإدخال شفرة تفعيل غير صحيحة او منتهية الصلاحية. من فضلك تواصل مع مسؤول البرنامج لأخذ شفرة صالحة.'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسنًا'))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Device ID:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SelectableText(
                          _deviceId,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _keyController,
                          decoration: const InputDecoration(
                            labelText: 'أدخل شفرة التفعيل',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _unlock,
                          child: const Text('تفعيل'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
