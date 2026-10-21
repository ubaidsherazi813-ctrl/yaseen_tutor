import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'db_interface.dart';

class WebUserDb implements UserDatabase {
  final SharedPreferences prefs;
  WebUserDb(this.prefs);

  List<Map<String, Object?>> _loadTable(String table) {
    final raw = prefs.getString('web_db_$table');
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, Object?>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveTable(String table, List<Map<String, Object?>> data) async {
    await prefs.setString('web_db_$table', jsonEncode(data));
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final data = _loadTable(table);
    final row = Map<String, Object?>.from(values);

    if (table == 'users' || table == 'progress' || table == 'quiz_attempts') {
      int maxId = 0;
      for (final r in data) {
        final id = r['id'];
        if (id is int && id > maxId) maxId = id;
      }
      row['id'] = maxId + 1;
    }

    // For bookmarks, primary key is (user_id, ayat_id)
    if (table == 'bookmarks') {
      data.removeWhere((r) =>
          r['user_id'] == row['user_id'] && r['ayat_id'] == row['ayat_id']);
    }

    data.add(row);
    await _saveTable(table, data);
    return (row['id'] as int?) ?? 1;
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    var data = _loadTable(table);

    if (where != null && whereArgs != null) {
      if (where.contains('user_id = ? AND ayat_id = ?')) {
        final uid = whereArgs[0];
        final aid = whereArgs[1];
        data = data
            .where((r) => r['user_id'] == uid && r['ayat_id'] == aid)
            .toList();
      } else if (where.contains('user_id = ?')) {
        final uid = whereArgs[0];
        data = data.where((r) => r['user_id'] == uid).toList();
      } else if (where.contains('id = ?')) {
        final id = whereArgs[0];
        data = data.where((r) => r['id'] == id).toList();
      }
    }

    if (orderBy != null) {
      if (orderBy.contains('id DESC')) {
        data.sort((a, b) =>
            ((b['id'] as int?) ?? 0).compareTo((a['id'] as int?) ?? 0));
      } else if (orderBy.contains('id')) {
        data.sort((a, b) =>
            ((a['id'] as int?) ?? 0).compareTo((b['id'] as int?) ?? 0));
      } else if (orderBy.contains('read_at')) {
        data.sort((a, b) => ((a['read_at'] as String?) ?? '')
            .compareTo((b['read_at'] as String?) ?? ''));
      }
    }

    return data;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final data = _loadTable(table);
    int count = 0;

    for (var i = 0; i < data.length; i++) {
      final r = data[i];
      bool match = false;
      if (where != null && whereArgs != null && where.contains('id = ?')) {
        if (r['id'] == whereArgs[0]) match = true;
      }
      if (match) {
        data[i] = {...r, ...values};
        count++;
      }
    }

    if (count > 0) {
      await _saveTable(table, data);
    }
    return count;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final data = _loadTable(table);
    int before = data.length;

    if (where != null && whereArgs != null) {
      if (where.contains('user_id = ? AND ayat_id = ?')) {
        final uid = whereArgs[0];
        final aid = whereArgs[1];
        data.removeWhere(
            (r) => r['user_id'] == uid && r['ayat_id'] == aid);
      } else if (where.contains('user_id = ?')) {
        final uid = whereArgs[0];
        data.removeWhere((r) => r['user_id'] == uid);
      } else if (where.contains('id = ?')) {
        final id = whereArgs[0];
        data.removeWhere((r) => r['id'] == id);
      }
    } else {
      data.clear();
    }

    final removed = before - data.length;
    if (removed > 0) {
      await _saveTable(table, data);
    }
    return removed;
  }
}

class DbServiceImpl implements DbServiceBase {
  late WebUserDb _user;
  Map<String, dynamic>? _contentJson;

  @override
  UserDatabase get user => _user;

  @override
  Future<void> init(SharedPreferences prefs) async {
    _user = WebUserDb(prefs);
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
