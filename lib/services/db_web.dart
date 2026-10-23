import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'db_interface.dart';
import 'prefs_user_db.dart';

// Alias WebUserDb to PrefsUserDb for compatibility
typedef WebUserDb = PrefsUserDb;

class DbServiceImpl implements DbServiceBase {
  late PrefsUserDb _user;
  Map<String, dynamic>? _contentJson;

  @override
  UserDatabase get user => _user;

  @override
  Future<void> init(SharedPreferences prefs) async {
    _user = PrefsUserDb(prefs);
    final raw =
        await rootBundle.loadString('assets/data/yaseen_content.json');
    _contentJson = jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  Future<List<Ayat>> loadAyaat() async {
    final rawAyaat = (_contentJson?['ayaat'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    final ayaat = rawAyaat.map(Ayat.fromMap).toList();
    final byId = {for (final a in ayaat) a.id: a};

    final rawWords = (_contentJson?['words'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    final wordById = <int, Word>{};
    for (final r in rawWords) {
      final w = Word.fromMap(r);
      wordById[w.id] = w;
      byId[r['ayat_id'] as int]?.words.add(w);
    }

    final rawSegments = (_contentJson?['segments'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    for (final r in rawSegments) {
      wordById[r['word_id'] as int]?.segments.add(Segment.fromMap(r));
    }

    return ayaat;
  }

  @override
  Future<List<Topic>> loadTopics() async {
    final rawTopics = (_contentJson?['topics'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    return rawTopics.map(Topic.fromMap).toList();
  }

  @override
  Future<List<AppUser>> loadUsers() async =>
      (await _user.query('users', orderBy: 'id'))
          .map(AppUser.fromMap)
          .toList();
}

DbServiceBase createDbService() => DbServiceImpl();
