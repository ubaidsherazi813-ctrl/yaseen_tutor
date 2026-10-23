class Segment {
  final int id;
  final String arabic;
  final String kind; // ism | fil | harf | zameer
  final bool isStem;
  final String? label, tense, i3rab, mabni, gender, number, person, pronType, note;

  Segment({
    required this.id,
    required this.arabic,
    required this.kind,
    required this.isStem,
    this.label,
    this.tense,
    this.i3rab,
    this.mabni,
    this.gender,
    this.number,
    this.person,
    this.pronType,
    this.note,
  });

  factory Segment.fromMap(Map<String, Object?> m) => Segment(
        id: m['id'] as int,
        arabic: m['arabic'] as String,
        kind: m['kind'] as String,
        isStem: (m['is_stem'] as int? ?? 0) == 1,
        label: m['label'] as String?,
        tense: m['tense'] as String?,
        i3rab: m['i3rab'] as String?,
        mabni: m['mabni'] as String?,
        gender: m['gender'] as String?,
        number: m['number'] as String?,
        person: m['person'] as String?,
        pronType: m['pron_type'] as String?,
        note: m['note'] as String?,
      );
}

class Word {
  final int id, position;
  final String arabic;
  final String? meaning, root;
  final List<Segment> segments = [];

  Word({
    required this.id,
    required this.position,
    required this.arabic,
    this.meaning,
    this.root,
  });

  factory Word.fromMap(Map<String, Object?> m) => Word(
        id: m['id'] as int,
        position: m['position'] as int,
        arabic: m['arabic'] as String,
        meaning: m['meaning'] as String?,
        root: m['root'] as String?,
      );

  /// Chip ka rang is lafz ke "stem" tukde ki qism se tay hota hai.
  Segment? get mainSegment {
    if (segments.isEmpty) return null;
    for (final s in segments) {
      if (s.isStem) return s;
    }
    return segments.first;
  }
}

class Ayat {
  final int id;
  final String arabic, urdu;
  final List<Word> words = [];

  Ayat({required this.id, required this.arabic, required this.urdu});

  factory Ayat.fromMap(Map<String, Object?> m) => Ayat(
        id: m['id'] as int,
        arabic: m['arabic'] as String,
        urdu: m['urdu'] as String,
      );

  String get audioAsset =>
      'assets/audio/ayat_${id.toString().padLeft(3, '0')}.mp3';
}

class Topic {
  final int id, startAyat, endAyat;
  final String title;
  final String? description;
  Topic({
    required this.id,
    required this.title,
    this.description,
    required this.startAyat,
    required this.endAyat,
  });

  factory Topic.fromMap(Map<String, Object?> m) => Topic(
        id: m['id'] as int,
        title: m['title'] as String,
        description: m['description'] as String?,
        startAyat: m['start_ayat'] as int,
        endAyat: m['end_ayat'] as int,
      );
}

class AppUser {
  final int id; // 0 = guest
  final String name, email, avatar, pinHash, salt;
  AppUser({
    required this.id,
    required this.name,
    this.email = '',
    required this.avatar,
    required this.pinHash,
    required this.salt,
  });

  bool get isGuest => id == 0;
  String get passwordHash => pinHash;

  factory AppUser.fromMap(Map<String, Object?> m) => AppUser(
        id: m['id'] as int,
        name: m['name'] as String,
        email: (m['email'] as String?) ?? '',
        avatar: (m['avatar'] as String?) ?? '👦',
        pinHash: (m['pin_hash'] ?? m['password_hash'] ?? '') as String,
        salt: (m['salt'] ?? '') as String,
      );

  static AppUser guest() =>
      AppUser(id: 0, name: 'Mehmaan', email: 'guest@yaseen.app', avatar: '👤', pinHash: '', salt: '');
}
