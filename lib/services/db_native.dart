import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/models.dart';
import 'db_interface.dart';
import 'db_web.dart';

class SqfliteUserDb implements UserDatabase {
  final Database db;
  SqfliteUserDb(this.db);

  @override
  Future<int> insert(String table, Map<String, Object?> values) =>
      db.insert(table, values);

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) =>
      db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      db.update(table, values, where: where, whereArgs: whereArgs);

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      db.delete(table, where: where, whereArgs: whereArgs);
}

class DbServiceImpl implements DbServiceBase {
  static const contentVersion = 2; // Incremented for full 83 ayaat update

  Database? _content;
  UserDatabase? _user;
  Map<String, dynamic>? _fallbackJson;

  @override
  UserDatabase get user => _user!;

  @override
  Future<void> init(SharedPreferences prefs) async {
    // Pre-initialize user fallback in case SQLite fails
    _user = WebUserDb(prefs);

    try {
      final dir = await getDatabasesPath();
      final contentPath = join(dir, 'yaseen_content.db');
      final installed = prefs.getInt('content_version') ?? 0;

      if (installed != contentVersion || !await File(contentPath).exists()) {
        await Directory(dir).create(recursive: true);
        final data = await rootBundle.load('assets/data/yaseen.db');
        await File(contentPath).writeAsBytes(
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          flush: true,
        );
        await prefs.setInt('content_version', contentVersion);
      }
      _content = await openDatabase(contentPath);

      final userDb = await openDatabase(
        join(dir, 'yaseen_user.db'),
        version: 2,
        onCreate: (db, v) async {
          await db.execute('''CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL,
            email TEXT, avatar TEXT, pin_hash TEXT NOT NULL, salt TEXT NOT NULL)''');
          await db.execute('''CREATE TABLE bookmarks(
            user_id INTEGER NOT NULL, ayat_id INTEGER NOT NULL,
            PRIMARY KEY(user_id, ayat_id))''');
          await db.execute('''CREATE TABLE progress(
            id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL,
            ayat_id INTEGER NOT NULL, read_at TEXT NOT NULL)''');
          await db.execute('''CREATE TABLE quiz_attempts(
            id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER NOT NULL,
            score INTEGER NOT NULL, total INTEGER NOT NULL, taken_at TEXT NOT NULL)''');
        },
        onUpgrade: (db, oldV, newV) async {
          if (oldV < 2) {
            try {
              await db.execute('ALTER TABLE users ADD COLUMN email TEXT');
            } catch (_) {}
          }
        },
      );
      _user = SqfliteUserDb(userDb);
    } catch (e) {
      debugPrint('SQLite init error on device, using resilient JSON fallback: $e');
    }
  }

  Future<Map<String, dynamic>> _getJson() async {
    if (_fallbackJson != null) return _fallbackJson!;
    final raw = await rootBundle.loadString('assets/data/yaseen_content.json');
    _fallbackJson = jsonDecode(raw) as Map<String, dynamic>;
    return _fallbackJson!;
  }

  @override
  Future<List<Ayat>> loadAyaat() async {
    if (_content != null) {
      try {
        final ayaat = (await _content!.query('ayaat', orderBy: 'id'))
            .map(Ayat.fromMap)
            .toList();
        final byId = {for (final a in ayaat) a.id: a};

        final wordRows =
            await _content!.query('words', orderBy: 'ayat_id, position');
        final wordById = <int, Word>{};
        for (final r in wordRows) {
          final w = Word.fromMap(r);
          wordById[w.id] = w;
          byId[r['ayat_id'] as int]?.words.add(w);
        }

        final segRows =
            await _content!.query('segments', orderBy: 'word_id, seg_order');
        for (final r in segRows) {
          wordById[r['word_id'] as int]?.segments.add(Segment.fromMap(r));
        }
        return ayaat;
      } catch (e) {
        debugPrint('SQLite loadAyaat failed, falling back to JSON: $e');
      }
    }

    // Fallback to JSON
    final json = await _getJson();
    final rawAyaat = (json['ayaat'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    final ayaat = rawAyaat.map(Ayat.fromMap).toList();
    final byId = {for (final a in ayaat) a.id: a};

    final rawWords = (json['words'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    final wordById = <int, Word>{};
    for (final r in rawWords) {
      final w = Word.fromMap(r);
      wordById[w.id] = w;
      byId[r['ayat_id'] as int]?.words.add(w);
    }

    final rawSegments = (json['segments'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    for (final r in rawSegments) {
      wordById[r['word_id'] as int]?.segments.add(Segment.fromMap(r));
    }
    return ayaat;
  }

  @override
  Future<List<Topic>> loadTopics() async {
    if (_content != null) {
      try {
        return (await _content!.query('topics', orderBy: 'id'))
            .map(Topic.fromMap)
            .toList();
      } catch (e) {
        debugPrint('SQLite loadTopics failed, falling back to JSON: $e');
      }
    }

    final json = await _getJson();
    final rawTopics = (json['topics'] as List? ?? [])
        .map((e) => Map<String, Object?>.from(e as Map))
        .toList();
    return rawTopics.map(Topic.fromMap).toList();
  }

  @override
  Future<List<AppUser>> loadUsers() async {
    return (await _user!.query('users', orderBy: 'id'))
        .map(AppUser.fromMap)
        .toList();
  }
}

DbServiceBase createDbService() => DbServiceImpl();
