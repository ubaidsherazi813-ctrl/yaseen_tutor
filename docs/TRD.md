# TRD: Technical Requirements Document

**Project:** Yaseen Tutor (Offline Flutter App)
**Version:** 1.0

---

## 1. Technical Overview

App **offline-first** hai: koi backend server nahi. Sab data phone ke andar SQLite database aur assets mein hota hai. Flutter (Dart) se ek hi code base se Android app banegi.

```
┌─────────────────────────────────────────┐
│               Flutter App               │
│  ┌───────────┐  ┌────────────────────┐  │
│  │    UI     │→ │  State (Provider)  │  │
│  │ (Screens) │  └─────────┬──────────┘  │
│  └───────────┘            ↓             │
│        ┌─────────────────────────────┐  │
│        │  Services / Repositories    │  │
│        │ DB | Audio | Auth | Settings│  │
│        └───────┬──────────┬──────────┘  │
│                ↓          ↓             │
│     SQLite (yaseen.db)  Assets (mp3,    │
│     + SharedPreferences   fonts, images)│
└─────────────────────────────────────────┘
```

## 2. Tech Stack

| Layer | Technology | Wajah |
|---|---|---|
| Framework | Flutter (latest stable) + Dart | Ek code, achhi UI, hot reload |
| State management | `provider` | Beginner-friendly |
| Database | `sqflite` + `path` + `path_provider` | Offline SQLite |
| Audio | `just_audio` | Asset audio, seek, speed, playlist |
| Settings | `shared_preferences` | Theme, font size, last ayat |
| Security | `crypto` (SHA-256) | PIN hashing |
| Charts | `fl_chart` | Dashboard charts |
| Fonts | Bundled TTF (Amiri Quran, Noto Nastaliq Urdu, Poppins) | Offline chalne ke liye |
| Version control | Git + GitHub | Backup aur history |
| Data prep | Python 3 + DB Browser for SQLite | Data import |
| Audio prep | Audacity / ffmpeg | Compress aur trim |

> Package versions `pubspec.yaml` mein `flutter pub add <package>` se latest stable lagao, taake purane version ke masail na aayein.

## 3. System Requirements

**Development machine:** Windows/Mac/Linux, 8 GB RAM (16 GB behtar), 10 GB free storage
**Software:** Flutter SDK, Android Studio (SDK + emulator), VS Code (Flutter + Dart extension), Git, Python 3
**Target device:** Android 7.0+ (minSdk 24), 2 GB RAM

## 4. Architecture

**Pattern:** Layered architecture (UI → Provider → Repository → Database)

- **Presentation:** screens aur widgets
- **State:** Providers (`AuthProvider`, `AyatProvider`, `AudioProvider`, `SettingsProvider`, `ProgressProvider`)
- **Data:** Repositories (`AyatRepository`, `UserRepository`, `ProgressRepository`) jo `DatabaseService` se baat karti hain
- **Core:** theme, constants, utils

### Folder Structure
```
yaseen_app/
├── assets/
│   ├── data/yaseen.db
│   ├── audio/ayat_001.mp3 ... ayat_083.mp3
│   ├── fonts/
│   └── images/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme/ (app_theme.dart, colors.dart)
│   │   ├── constants.dart
│   │   └── utils/ (hash_util.dart, arabic_utils.dart)
│   ├── models/ (ayat.dart, word.dart, segment.dart, user.dart, bookmark.dart)
│   ├── services/ (database_service.dart, audio_service.dart, auth_service.dart)
│   ├── repositories/
│   ├── providers/
│   ├── screens/
│   │   ├── splash/ login/ dashboard/ ayaat/ grammar/
│   │   ├── topics/ quiz/ bookmarks/ settings/
│   └── widgets/ (ayat_card.dart, word_chip.dart, grammar_sheet.dart, mini_player.dart)
└── pubspec.yaml
```

## 5. Database Design (SQLite)

### 5.1 ERD (Mukhtasar)
```
ayaat 1 ──── * words 1 ──── * segments
ayaat 1 ──── * bookmarks * ──── 1 users
ayaat 1 ──── * progress  * ──── 1 users
users 1 ──── * quiz_attempts
```

### 5.2 Schema (SQL)
```sql
CREATE TABLE ayaat (
  id INTEGER PRIMARY KEY,          -- 1..83 (ayat number)
  arabic TEXT NOT NULL,
  urdu TEXT NOT NULL,
  audio_path TEXT NOT NULL,         -- 'assets/audio/ayat_001.mp3'
  topic_id INTEGER
);

CREATE TABLE words (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  ayat_id INTEGER NOT NULL REFERENCES ayaat(id),
  position INTEGER NOT NULL,        -- ayat mein lafz ka number (1 se)
  arabic TEXT NOT NULL,
  meaning_ur TEXT,
  meaning_en TEXT,
  root TEXT,                        -- jad
  UNIQUE (ayat_id, position)
);

-- Corpus ke mutabiq ek lafz kayi tukdon (prefix/stem/suffix) ka ho sakta hai
CREATE TABLE segments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  word_id INTEGER NOT NULL REFERENCES words(id),
  seg_order INTEGER NOT NULL,
  arabic TEXT NOT NULL,
  kind TEXT NOT NULL,               -- 'ism' | 'fil' | 'harf'
  sub_type TEXT,                    -- 'jar','nida','atf','nafi','istifham','shart','tahqeeq','zameer',...
  tense TEXT,                       -- 'madhi','mudare','amr','nahi' (fe'l ke liye)
  i3rab TEXT,                       -- 'marfu','mansub','majroor','majzoom'
  mabni TEXT,                       -- 'mabni' | 'murab'
  gender TEXT,                      -- 'muzakkar' | 'muannas'
  number TEXT,                      -- 'wahid','tasniya','jama'
  person TEXT,                      -- 'ghaib','hazir','mutakallim'
  pronoun_type TEXT,                -- 'muttasil' | 'munfasil'
  note TEXT
);

CREATE TABLE topics (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  start_ayat INTEGER,
  end_ayat INTEGER
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  avatar TEXT,
  pin_hash TEXT NOT NULL,
  salt TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE bookmarks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  ayat_id INTEGER NOT NULL REFERENCES ayaat(id),
  created_at TEXT NOT NULL,
  UNIQUE (user_id, ayat_id)
);

CREATE TABLE progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  ayat_id INTEGER NOT NULL REFERENCES ayaat(id),
  read_at TEXT NOT NULL,
  UNIQUE (user_id, ayat_id)
);

CREATE TABLE quiz_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  score INTEGER NOT NULL,
  total INTEGER NOT NULL,
  taken_at TEXT NOT NULL
);

CREATE INDEX idx_words_ayat ON words(ayat_id);
CREATE INDEX idx_segments_word ON segments(word_id);
```

### 5.3 Prebuilt Database ko app mein lana
Fixed data (ayaat, words, segments, topics) laptop par tayyar karke `assets/data/yaseen.db` mein rakho. User tables bhi usi file mein khali hoti hain.

```dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = join(await getDatabasesPath(), 'yaseen.db');

    if (!await File(dbPath).exists()) {
      await Directory(dirname(dbPath)).create(recursive: true);
      final data = await rootBundle.load('assets/data/yaseen.db');
      await File(dbPath).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        flush: true,
      );
    }
    _db = await openDatabase(dbPath, version: 1);
    return _db!;
  }
}
```

> App update mein naya content aaye to `PRAGMA user_version` se migration karna, warna purani copy hi chalti rahegi.

## 6. Data Pipeline (Laptop par)

1. **Arabic text + Urdu tarjuma:** Tanzil.net se Surah 36 ka Quran text (Uthmani) aur Urdu translation download
2. **Grammar:** Quranic Arabic Corpus ki morphology data se Surah 36 (chapter 36) ke segments nikalo
3. **Python script** se SQLite mein import:
```python
import sqlite3
conn = sqlite3.connect('yaseen.db')
cur = conn.cursor()
# schema (section 5.2) pehle chalao, phir:
# 1) ayaat table mein text + urdu insert
# 2) corpus se words/segments parse karke insert
conn.commit()
```
4. Corpus ke tags (jaise N, V, P, PRON, PN, ADJ, REL, DEM, CONJ, NEG, INTG, COND, VOC, LOC, T...) ko app ki istilahat se **mapping table** ke zariye jodo, jaise:

| Corpus tag | App ki qism |
|---|---|
| N, PN, ADJ | Ism |
| V (PERF/IMPF/IMPV) | Fe'l (madhi/mudare/amr) |
| PRON | Zameer |
| P (jar harf) | Harf-e-Jar |
| VOC | Harf-e-Nida |
| CONJ | Harf-e-Atf |
| NEG | Harf-e-Nafi |
| INTG | Harf-e-Istifham |
| COND | Harf-e-Shart |
| INL | Huroof-e-Muqatta'at |
| GEN/NOM/ACC | Majroor/Marfu/Mansub |

> Mapping se pehle corpus ki tags ki list aur unke matlab website par dekh kar tasdeeq kar lo. Aakhri mapping ustad se verify karwao.

5. **Validation script:** 83 ayaat, har ayat ke words gine, koi khali field na ho
6. Final `yaseen.db` ko assets mein rakho

**License:** Tanzil aur Quranic Arabic Corpus dono ki apni shartein hain (attribution wagera). Unhein parho aur app ke About page mein credits do.

## 7. Audio

- **Source:** EveryAyah.com se ek qaari ki 83 ayaat ke mp3
- **Naming:** `ayat_001.mp3` ... `ayat_083.mp3`
- **Compress:** `ffmpeg -i in.mp3 -b:a 64k -ac 1 out.mp3`
- **Size estimate:** takreeban 10-20 MB (qaari/bitrate par munhasir)
- **Playback:** `just_audio` ki `ConcatenatingAudioSource` se playlist, `currentIndexStream` se highlight

```dart
import 'package:just_audio/just_audio.dart';

class AudioService {
  final player = AudioPlayer();

  Future<void> loadPlaylist() async {
    final sources = List.generate(83, (i) {
      final n = (i + 1).toString().padLeft(3, '0');
      return AudioSource.asset('assets/audio/ayat_$n.mp3');
    });
    await player.setAudioSource(ConcatenatingAudioSource(children: sources));
  }

  Future<void> playAyat(int ayatNumber) async {
    await player.seek(Duration.zero, index: ayatNumber - 1);
    await player.play();
  }
}
```

> `just_audio` ka naya version aapko `ConcatenatingAudioSource` ke bajaye doosri API suggest kare to package ke docs mein latest playlist method dekh lena.

## 8. Authentication (Local)

```dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String generateSalt() {
  final r = Random.secure();
  return base64Url.encode(List<int>.generate(16, (_) => r.nextInt(256)));
}

String hashPin(String pin, String salt) =>
    sha256.convert(utf8.encode('$salt$pin')).toString();

bool verifyPin(String pin, String salt, String storedHash) =>
    hashPin(pin, salt) == storedHash;
```

**Flow:** App open → Splash → agar koi user nahi to Create Profile, warna Login (PIN) → Dashboard. Session ke liye `AuthProvider` mein `currentUser`; `shared_preferences` mein sirf `lastUserId`.

**Limit:** 4-digit PIN brute-force se tor sakta hai (sirf 10,000 combos), isliye yeh privacy-level lock hai, strong security nahi. Report mein yeh ikhtiyat likho.

## 9. State Management

| Provider | Zimmedari |
|---|---|
| AuthProvider | login, logout, create profile, guest |
| AyatProvider | ayaat list, search, bookmarks |
| WordProvider | selected word ki grammar |
| AudioProvider | current ayat, playing state, speed |
| ProgressProvider | read ayaat, streak, chart data |
| SettingsProvider | theme, font size, tarjuma on/off |
| QuizProvider | sawalat generate, score |

## 10. Key Technical Details

### 10.1 Arabic Text Rendering
- Quran ke liye bane font (Amiri Quran) use karo taake harakat/tashkeel sahi nazar aayein
- `Text` mein `textDirection: TextDirection.rtl`
- Line height 1.8-2.2 rakho warna harakat kat sakti hain
- Har lafz ko tap-able banane ke liye `Wrap` mein `InkWell` + `Text` ka `WordChip` (RTL), ya `Text.rich` mein `TextSpan` + `TapGestureRecognizer`
- Alag alag device par test karo

### 10.2 Word Chip Colors
```dart
Color kindColor(String kind, String? subType) {
  if (subType == 'zameer') return const Color(0xFFE58A1F);
  switch (kind) {
    case 'ism': return const Color(0xFF1E6FD9);
    case 'fil': return const Color(0xFF1E9E5A);
    case 'harf': return const Color(0xFFD64545);
    default: return Colors.grey;
  }
}
```
Sirf rang par bharosa na karo: chip ke neeche chhota label (Ism/Fe'l/Harf) bhi dikhao, taake rang na pehchanne wale users ko bhi samajh aaye.

### 10.3 Queries
```sql
-- Ek ayat ke words
SELECT * FROM words WHERE ayat_id = ? ORDER BY position;

-- Ek lafz ki grammar
SELECT * FROM segments WHERE word_id = ? ORDER BY seg_order;

-- Progress count
SELECT COUNT(*) FROM progress WHERE user_id = ?;
```
Performance ke liye ayat screen par ek hi baar mein ek ayat ke words load karo, poori surat ke nahi.

### 10.4 Streak Logic
`progress.read_at` ki dates se ginti: agar aaj ya kal koi ayat parhi gayi to streak chalti rahti hai, warna 0.

### 10.5 Quiz Generation
`segments` se random lafz uthao, sahi `kind` ke saath 2 galat options (doosri aqsam) do. Sawalat app chalte waqt generate hote hain, alag data ki zaroorat nahi.

## 11. Android Configuration

- `android/app/build.gradle`: `minSdkVersion 24`
- App ka naam aur icon: `AndroidManifest.xml` aur `flutter_launcher_icons`
- Internet permission ki zaroorat nahi (offline app); iska matlab privacy bhi behtar
- Release signing:
```bash
keytool -genkey -v -keystore ~/yaseen-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias yaseen
```
`android/key.properties` banao aur `build.gradle` mein signingConfig jodo. Keystore file aur password **kabhi GitHub par mat daalo**.

## 12. Build aur Size Optimization

```bash
flutter build apk --release --split-per-abi
```
- Fonts: sirf zaroori weights rakho
- Audio: 64 kbps mono
- Images: WebP/SVG
- `--split-per-abi` se alag chhoti APKs banti hain

## 13. Testing Strategy

| Type | Kaise |
|---|---|
| Unit tests | `hashPin`, mapping functions, streak logic |
| Widget tests | Login screen, ayat card, grammar sheet |
| Data validation | Script: 83 ayaat, words khali na hon, tarjuma match |
| Manual | Har ayat ka audio sahi ayat par chale |
| Offline | Airplane mode mein pura app |
| Devices | Kam az kam 2 real phones + 1 emulator, alag screen size |
| Theme | Light aur Dark dono |
| Content | Ustad ka final review |

Commands: `flutter test`, `flutter analyze`.

## 14. Security aur Privacy

- Koi network call nahi, koi analytics nahi
- PIN salt + SHA-256 hash
- Database app ki private storage mein
- Keystore secret rakhna
- Quran text ko tabdeel na karna (integrity check: data import ke baad source se compare)

## 15. Risks (Technical)

| Risk | Hal |
|---|---|
| Corpus tags ko sahi mapping dena | Pehle mapping table banao, ustad se verify |
| Arabic font rendering | Quran font + multiple device test |
| Audio ka size | Compression |
| Audio aur ayat ka mismatch | Naming convention aur test checklist |
| Database update ka masla | `user_version` + migration |

## 16. Definition of Done

- `flutter analyze` mein koi error nahi
- Sab P0 features chalte hain
- Offline test pass
- Data verified
- Release APK signed aur install test pass
