import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_interface.dart';

/// Ultra-fast, zero-deadlock user database backed by SharedPreferences.
/// Runs natively and identically on Android, iOS, Web, Windows, and macOS.
class PrefsUserDb implements UserDatabase {
  final SharedPreferences prefs;

  PrefsUserDb(this.prefs);

  List<Map<String, Object?>> _loadTable(String table) {
    final raw = prefs.getString('web_db_$table');
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, Object?>.from(e as Map)).toList();
    } catch (e) {
      debugPrint('PrefsUserDb parse error for $table: $e');
      return [];
    }
  }

  Future<void> _saveTable(String table, List<Map<String, Object?>> data) async {
    try {
      await prefs.setString('web_db_$table', jsonEncode(data));
    } catch (e) {
      debugPrint('PrefsUserDb save error for $table: $e');
    }
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
      final uidStr = row['user_id']?.toString() ?? '';
      final aidStr = row['ayat_id']?.toString() ?? '';
      data.removeWhere((r) =>
          r['user_id']?.toString() == uidStr &&
          r['ayat_id']?.toString() == aidStr);
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

    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      if (where.contains('user_id = ? AND ayat_id = ?') && whereArgs.length >= 2) {
        final uidStr = whereArgs[0]?.toString() ?? '';
        final aidStr = whereArgs[1]?.toString() ?? '';
        data = data
            .where((r) =>
                r['user_id']?.toString() == uidStr &&
                r['ayat_id']?.toString() == aidStr)
            .toList();
      } else if (where.contains('user_id = ?')) {
        final uidStr = whereArgs[0]?.toString() ?? '';
        data = data
            .where((r) => r['user_id']?.toString() == uidStr)
            .toList();
      } else if (where.contains('id = ?')) {
        final idStr = whereArgs[0]?.toString() ?? '';
        data = data.where((r) => r['id']?.toString() == idStr).toList();
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
      if (where != null && whereArgs != null && whereArgs.isNotEmpty && where.contains('id = ?')) {
        final idStr = whereArgs[0]?.toString() ?? '';
        if (r['id']?.toString() == idStr) match = true;
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
    final before = data.length;

    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      if (where.contains('user_id = ? AND ayat_id = ?') && whereArgs.length >= 2) {
        final uidStr = whereArgs[0]?.toString() ?? '';
        final aidStr = whereArgs[1]?.toString() ?? '';
        data.removeWhere((r) =>
            r['user_id']?.toString() == uidStr &&
            r['ayat_id']?.toString() == aidStr);
      } else if (where.contains('user_id = ?')) {
        final uidStr = whereArgs[0]?.toString() ?? '';
        data.removeWhere((r) => r['user_id']?.toString() == uidStr);
      } else if (where.contains('id = ?')) {
        final idStr = whereArgs[0]?.toString() ?? '';
        data.removeWhere((r) => r['id']?.toString() == idStr);
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
