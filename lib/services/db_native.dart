import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'db_interface.dart';
import 'prefs_user_db.dart';

// Alias WebUserDb to PrefsUserDb for backwards compatibility
typedef WebUserDb = PrefsUserDb;

class DbServiceImpl implements DbServiceBase {
  late PrefsUserDb _user;
  Map<String, dynamic>? _contentJson;

  @override
  UserDatabase get user => _user;

  @override
  Future<void> init(SharedPreferences prefs) async {
    _user = PrefsUserDb(prefs);

    // 1. One-time non-blocking check: if PrefsUserDb has no users yet,
    // try to import from old SQLite db if it exists
    final savedUsersRaw = prefs.getString('web_db_users');
    if (savedUsersRaw == null || savedUsersRaw == '[]') {
      try {
        final dir = await getDatabasesPath();
        final userDbPath = join(dir, 'yaseen_user.db');
        if (await File(userDbPath).exists()) {
          final oldDb = await openDatabase(userDbPath, readOnly: true).timeout(const Duration(milliseconds: 600));
          final oldRows = await oldDb.query('users').timeout(const Duration(milliseconds: 600));
          for (final r in oldRows) {
            await _user.insert('users', r);
          }
          await oldDb.close().timeout(const Duration(milliseconds: 300));
          debugPrint('Successfully migrated ${oldRows.length} users from SQLite to PrefsUserDb');
        }
      } catch (e) {
        debugPrint('Legacy SQLite migration skipped or timed out safely: $e');
      }
    }

    // 2. Load Surah Yaseen content JSON (all 83 ayaat, 727 words, 1213 segments, topics)
    // Instant in-memory loading with 0 disk copy overhead
    try {
      final raw = await rootBundle.loadString('assets/data/yaseen_content.json');
      _contentJson = jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error loading yaseen_content.json: $e');
    }
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
  Future<List<AppUser>> loadUsers() async {
    try {
      return (await _user.query('users', orderBy: 'id'))
          .map(AppUser.fromMap)
          .toList();
    } catch (e) {
      debugPrint('loadUsers error: $e');
      return [];
    }
  }
}

DbServiceBase createDbService() => DbServiceImpl();
