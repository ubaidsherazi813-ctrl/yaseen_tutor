import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt() {
  final r = Random.secure();
  return base64Url.encode(List<int>.generate(16, (_) => r.nextInt(256)));
}

String hashPin(String pin, String salt) =>
    sha256.convert(utf8.encode('$salt$pin')).toString();
