import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/pin_util.dart';
import '../models/models.dart';
import '../services/db_service.dart';

class AppState extends ChangeNotifier {
  final DbService db = DbService();
  late SharedPreferences prefs;

  // ---- Content ----
  List<Ayat> ayaat = [];
  List<Topic> topics = [];

  // ---- Auth ----
  List<AppUser> users = [];
  AppUser? user;
  int _failed = 0;
  DateTime? _lockedUntil;

  // ---- User data ----
  Set<int> bookmarks = {};
  List<Map<String, Object?>> reads = [];
  List<Map<String, Object?>> quizzes = [];

  // ---- Settings ----
  ThemeMode themeMode = ThemeMode.system;
  double arabicSize = 28;
  double urduSize = 17;
  bool showTranslation = true;
  bool showMeaning = true;

  // ---- Navigation helper ----
  int tab = 0;
  int? jumpAyat;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await db.init(prefs);
    ayaat = await db.loadAyaat();
    topics = await db.loadTopics();
    users = await db.loadUsers();

    themeMode = ThemeMode.values[prefs.getInt('theme') ?? 0];
    arabicSize = prefs.getDouble('arabic_size') ?? 28;
    urduSize = prefs.getDouble('urdu_size') ?? 17;
    showTranslation = prefs.getBool('show_tr') ?? true;
    showMeaning = prefs.getBool('show_meaning') ?? true;
  }

  // ================= AUTH =================
  AppUser? get lastUser {
    final id = prefs.getInt('last_user');
    for (final u in users) {
      if (u.id == id) return u;
    }
    return users.isEmpty ? null : users.first;
  }

  int get lockSecondsLeft {
    if (_lockedUntil == null) return 0;
    final s = _lockedUntil!.difference(DateTime.now()).inSeconds;
    return s > 0 ? s : 0;
  }

  Future<AppUser> registerWithEmail({
    required String name,
    required String email,
    required String password,
    String? avatar,
  }) async {
    final salt = generateSalt();
    final chosenAvatar = avatar ?? '👦';
    final cleanEmail = email.trim().toLowerCase();

    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      id = await db.user.insert('users', {
        'name': name.trim(),
        'email': cleanEmail,
        'avatar': chosenAvatar,
        'pin_hash': hashPin(password, salt),
        'salt': salt,
      });
    } catch (e) {
      debugPrint('db.user.insert error: $e, trying without email column');
      try {
        id = await db.user.insert('users', {
          'name': name.trim(),
          'avatar': chosenAvatar,
          'pin_hash': hashPin(password, salt),
          'salt': salt,
        });
      } catch (_) {}
    }

    try {
      users = await db.loadUsers();
    } catch (e) {
      debugPrint('db.loadUsers error: $e');
    }

    // Safely look up the created user
    AppUser? newUser;
    for (final u in users) {
      if (u.id == id || (cleanEmail.isNotEmpty && u.email.toLowerCase() == cleanEmail) || u.name == name.trim()) {
        newUser = u;
        break;
      }
    }

    // If not found in list for any reason, construct it directly so it NEVER throws
    newUser ??= AppUser(
      id: id > 0 ? id : 1,
      name: name.trim(),
      email: cleanEmail,
      avatar: chosenAvatar,
      pinHash: hashPin(password, salt),
      salt: salt,
    );

    user = newUser;
    await prefs.setInt('last_user', newUser.id);
    try {
      await _loadUserData();
    } catch (_) {}
    tab = 0;
    notifyListeners();
    return newUser;
  }

  Future<String?> loginWithEmail(String email, String password) async {
    final cleanEmail = email.trim().toLowerCase();
    try {
      final matched = users.where((u) {
        final ue = u.email.trim().toLowerCase();
        return ue.isNotEmpty && ue == cleanEmail;
      }).toList();

      if (matched.isEmpty) {
        // Also check by name if username was entered instead of email
        final byName = users.where((u) => u.name.trim().toLowerCase() == cleanEmail).toList();
        if (byName.isNotEmpty) {
          final u = byName.first;
          if (hashPin(password, u.salt) == u.passwordHash) {
            user = u;
            await prefs.setInt('last_user', u.id);
            try {
              await _loadUserData();
            } catch (_) {}
            tab = 0;
            notifyListeners();
            return null;
          }
        }
        return 'Yeh email registered nahi hai. Baraye meherbani pehle Sign Up karein.';
      }

      final u = matched.first;
      if (hashPin(password, u.salt) != u.passwordHash) {
        return 'Ghalat Password! Baraye meherbani dobara check karein.';
      }

      user = u;
      await prefs.setInt('last_user', u.id);
      try {
        await _loadUserData();
      } catch (_) {}
      tab = 0;
      notifyListeners();
      return null;
    } catch (e) {
      return 'Login error: $e';
    }
  }

  Future<AppUser> loginWithGoogle({
    required String name,
    required String email,
    String? avatar,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim().isEmpty ? 'Google User' : name.trim();
    final chosenAvatar = avatar ?? '👦';

    // 1. Check if user already exists
    AppUser? matched;
    for (final u in users) {
      if (u.email.trim().toLowerCase() == cleanEmail && cleanEmail.isNotEmpty) {
        matched = u;
        break;
      }
    }

    if (matched != null) {
      user = matched;
      await prefs.setInt('last_user', matched.id);
      try {
        await _loadUserData();
      } catch (_) {}
      tab = 0;
      notifyListeners();
      return matched;
    }

    // 2. Register new user profile with Google credentials
    final salt = generateSalt();
    final authSecret = 'google_${DateTime.now().millisecondsSinceEpoch}';

    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    try {
      id = await db.user.insert('users', {
        'name': cleanName,
        'email': cleanEmail,
        'avatar': chosenAvatar,
        'pin_hash': hashPin(authSecret, salt),
        'salt': salt,
      });
    } catch (e) {
      debugPrint('Google user insert fallback: $e');
      try {
        id = await db.user.insert('users', {
          'name': cleanName,
          'avatar': chosenAvatar,
          'pin_hash': hashPin(authSecret, salt),
          'salt': salt,
        });
      } catch (_) {}
    }

    try {
      users = await db.loadUsers();
    } catch (_) {}

    AppUser? newUser;
    for (final u in users) {
      if (u.id == id || (cleanEmail.isNotEmpty && u.email.trim().toLowerCase() == cleanEmail)) {
        newUser = u;
        break;
      }
    }

    newUser ??= AppUser(
      id: id > 0 ? id : 1,
      name: cleanName,
      email: cleanEmail,
      avatar: chosenAvatar,
      pinHash: hashPin(authSecret, salt),
      salt: salt,
    );

    user = newUser;
    await prefs.setInt('last_user', newUser.id);
    try {
      await _loadUserData();
    } catch (_) {}
    tab = 0;
    notifyListeners();
    return newUser;
  }

  Future<AppUser> createUser(String name, String avatar, String pin) async {
    final salt = generateSalt();
    final id = await db.user.insert('users', {
      'name': name.trim(),
      'email': '${name.trim().toLowerCase()}@yaseen.app',
      'avatar': avatar,
      'pin_hash': hashPin(pin, salt),
      'salt': salt,
    });
    users = await db.loadUsers();
    notifyListeners();
    return users.firstWhere((u) => u.id == id);
  }

  /// true = login ho gaya. false = galat PIN ya lock.
  Future<bool> login(AppUser u, String pin) async {
    if (lockSecondsLeft > 0) return false;
    if (hashPin(pin, u.salt) != u.pinHash) {
      _failed++;
      if (_failed >= 5) {
        _failed = 0;
        _lockedUntil = DateTime.now().add(const Duration(seconds: 30));
      }
      notifyListeners();
      return false;
    }
    _failed = 0;
    user = u;
    await prefs.setInt('last_user', u.id);
    await _loadUserData();
    tab = 0;
    notifyListeners();
    return true;
  }

  Future<void> loginAsGuest() async {
    user = AppUser.guest();
    await _loadUserData();
    tab = 0;
    notifyListeners();
  }

  void logout() {
    user = null;
    tab = 0;
    notifyListeners();
  }

  Future<bool> changePin(String oldPin, String newPin) async {
    final u = user;
    if (u == null || u.isGuest || hashPin(oldPin, u.salt) != u.pinHash) return false;
    final salt = generateSalt();
    await db.user.update(
      'users',
      {'pin_hash': hashPin(newPin, salt), 'salt': salt},
      where: 'id = ?',
      whereArgs: [u.id],
    );
    users = await db.loadUsers();
    user = users.firstWhere((x) => x.id == u.id);
    notifyListeners();
    return true;
  }

  Future<void> updateAvatar(String newAvatar) async {
    final u = user;
    if (u == null || u.isGuest) return;
    await db.user.update(
      'users',
      {'avatar': newAvatar},
      where: 'id = ?',
      whereArgs: [u.id],
    );
    users = await db.loadUsers();
    user = users.firstWhere((x) => x.id == u.id);
    notifyListeners();
  }

  Future<void> deleteCurrentUser() async {
    final u = user;
    if (u == null) return;
    for (final t in ['bookmarks', 'progress', 'quiz_attempts']) {
      await db.user.delete(t, where: 'user_id = ?', whereArgs: [u.id]);
    }
    await db.user.delete('users', where: 'id = ?', whereArgs: [u.id]);
    users = await db.loadUsers();
    logout();
  }

  Future<void> _loadUserData() async {
    final uid = user?.id ?? 0;
    final b = await db.user.query('bookmarks', where: 'user_id = ?', whereArgs: [uid]);
    bookmarks = b.map((r) => r['ayat_id'] as int).toSet();
    reads = await db.user.query('progress',
        where: 'user_id = ?', whereArgs: [uid], orderBy: 'read_at');
    quizzes = await db.user.query('quiz_attempts',
        where: 'user_id = ?', whereArgs: [uid], orderBy: 'id DESC');
  }

  // ================= BOOKMARKS =================
  bool isBookmarked(int ayatId) => bookmarks.contains(ayatId);

  Future<void> toggleBookmark(int ayatId) async {
    final uid = user?.id ?? 0;
    if (bookmarks.contains(ayatId)) {
      bookmarks.remove(ayatId);
      await db.user.delete('bookmarks',
          where: 'user_id = ? AND ayat_id = ?', whereArgs: [uid, ayatId]);
    } else {
      bookmarks.add(ayatId);
      await db.user.insert('bookmarks', {'user_id': uid, 'ayat_id': ayatId});
    }
    notifyListeners();
  }

  // ================= PROGRESS =================
  Set<int> get readIds => reads.map((r) => r['ayat_id'] as int).toSet();
  bool isRead(int ayatId) => readIds.contains(ayatId);

  static String _day(DateTime d) => d.toIso8601String().substring(0, 10);

  Future<void> markRead(int ayatId) async {
    final uid = user?.id ?? 0;
    final today = _day(DateTime.now());
    final already = reads.any((r) =>
        r['ayat_id'] == ayatId && (r['read_at'] as String).startsWith(today));
    if (already) return;
    final Map<String, Object?> row = {
      'user_id': uid,
      'ayat_id': ayatId,
      'read_at': DateTime.now().toIso8601String(),
    };
    await db.user.insert('progress', row);
    reads.add(row);
    notifyListeners();
  }

  Future<void> toggleRead(int ayatId) async {
    if (isRead(ayatId)) {
      final uid = user?.id ?? 0;
      await db.user.delete('progress',
          where: 'user_id = ? AND ayat_id = ?', whereArgs: [uid, ayatId]);
      reads.removeWhere((r) => r['ayat_id'] == ayatId);
      notifyListeners();
    } else {
      await markRead(ayatId);
    }
  }

  /// Pehli ayat jo abhi tak nahi parhi (Continue button ke liye).
  int get continueAyat {
    final done = readIds;
    for (final a in ayaat) {
      if (!done.contains(a.id)) return a.id;
    }
    return ayaat.isEmpty ? 1 : ayaat.first.id;
  }

  int get streak {
    final days = reads.map((r) => (r['read_at'] as String).substring(0, 10)).toSet();
    var d = DateTime.now();
    if (!days.contains(_day(d))) d = d.subtract(const Duration(days: 1));
    var count = 0;
    while (days.contains(_day(d))) {
      count++;
      d = d.subtract(const Duration(days: 1));
    }
    return count;
  }

  /// Pichle 7 din ki activity (purana -> naya), aakhri entry aaj ki.
  List<int> get weekly {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = _day(now.subtract(Duration(days: 6 - i)));
      return reads.where((r) => (r['read_at'] as String).startsWith(day)).length;
    });
  }

  // ================= QUIZ =================
  Future<void> saveQuiz(int score, int total) async {
    final uid = user?.id ?? 0;
    await db.user.insert('quiz_attempts', {
      'user_id': uid,
      'score': score,
      'total': total,
      'taken_at': DateTime.now().toIso8601String(),
    });
    quizzes = await db.user.query('quiz_attempts',
        where: 'user_id = ?', whereArgs: [uid], orderBy: 'id DESC');
    notifyListeners();
  }

  // ================= SETTINGS =================
  void setThemeMode(ThemeMode m) {
    themeMode = m;
    prefs.setInt('theme', m.index);
    notifyListeners();
  }

  void setArabicSize(double v) {
    arabicSize = v;
    prefs.setDouble('arabic_size', v);
    notifyListeners();
  }

  void setUrduSize(double v) {
    urduSize = v;
    prefs.setDouble('urdu_size', v);
    notifyListeners();
  }

  void setShowTranslation(bool v) {
    showTranslation = v;
    prefs.setBool('show_tr', v);
    notifyListeners();
  }

  void setShowMeaning(bool v) {
    showMeaning = v;
    prefs.setBool('show_meaning', v);
    notifyListeners();
  }

  // ================= NAVIGATION =================
  void goTab(int i, {int? ayat}) {
    tab = i;
    jumpAyat = ayat;
    notifyListeners();
  }
}
