# Implementation Plan: 0 se 100 tak

**Project:** Yaseen Tutor (Offline Flutter App)
**Muddat:** 8 hafte (aap apne time ke hisaab se kam/zyada kar sakte hain)
**Rule:** Pehle P0 features, phir P1, phir P2.

---

## Phase 0: Tayyari (Din 1-3)

### Tools install
1. **Flutter SDK:** flutter.dev se download, `PATH` mein add karo
2. **Android Studio:** Android SDK aur emulator ke liye
3. **VS Code** + Flutter extension + Dart extension
4. **Git** aur GitHub account
5. **Python 3** (data import ke liye)
6. **DB Browser for SQLite** (database dekhne ke liye)
7. **Audacity ya ffmpeg** (audio compress)

```bash
flutter doctor          # sab tick hone chahiye (Android licenses: flutter doctor --android-licenses)
```

### Project banao
```bash
flutter create yaseen_app
cd yaseen_app
git init
git add . && git commit -m "Initial Flutter project"
flutter run             # default app chalni chahiye
```

### Documents
- `docs/` folder mein PRD.md, TRD.md, UI-UX.md, Implementationplan.md rakho
- GitHub par private repo banao

**Deliverable:** Default Flutter app emulator/phone par chal rahi ho.

---

## Phase 1: Data Tayyar Karna (Hafta 1)

> Yeh sab se zaroori phase hai. App ka dil yahi data hai.

### Step 1.1: Sources download
- **Quran text (Uthmani) + Urdu tarjuma:** Tanzil.net se Surah 36
- **Grammar/morphology:** Quranic Arabic Corpus (corpus.quran.com) se Surah 36
- **Audio:** EveryAyah.com se qaari ke 83 mp3
- Har source ki **license/terms** parho aur credits note karo

### Step 1.2: Database banao
1. DB Browser for SQLite mein `yaseen.db` banao
2. TRD.md ke section 5.2 ki SQL script chalao (tables: ayaat, words, segments, topics, users, bookmarks, progress, quiz_attempts)

### Step 1.3: Python se import
```python
import sqlite3

conn = sqlite3.connect('yaseen.db')
cur = conn.cursor()

# 1) Ayaat import (text file ki har line: ayat_number|arabic|urdu)
# cur.execute("INSERT INTO ayaat (id, arabic, urdu, audio_path) VALUES (?,?,?,?)", (...))

# 2) Corpus se words/segments parse karke insert karo
# mapping: corpus tag -> app ki qism (TRD.md section 6)

conn.commit()
conn.close()
```
Data file ki asal shakal download ke baad dekh kar parsing likhna; agar script mein masla ho to file ka sample mujhe bhej do, main parsing likh dunga.

### Step 1.4: Topics table
5 topics aur unki ayat ranges khud tay karo aur ustad se confirm karo:
risalat ki tasdeeq, basti walon ka qissa, tauheed ki nishaniyan, qayamat aur akhirat, shaitan ki dushmani.

### Step 1.5: Validation
```sql
SELECT COUNT(*) FROM ayaat;                 -- 83 hona chahiye
SELECT id FROM ayaat WHERE urdu = '' OR arabic = '';   -- koi nahi
SELECT a.id FROM ayaat a LEFT JOIN words w ON w.ayat_id = a.id
GROUP BY a.id HAVING COUNT(w.id) = 0;       -- koi nahi
```

### Step 1.6: Audio
```bash
# compress aur naming
ffmpeg -i 036001.mp3 -b:a 64k -ac 1 ayat_001.mp3
```
(Naam EveryAyah ki file ke hisaab se badlo.) Ek loop script se 83 files convert aur rename karo.

### Step 1.7: Ustad review
Data ka printout/screenshot ustad ko dikhao: Arabic text, tarjuma aur kuch grammar entries. Unki correction database mein lagao.

**Deliverable:** `yaseen.db` (verified), 83 audio files.

---

## Phase 2: Project Setup (Hafta 2, pehle 2 din)

### Step 2.1: Packages
```bash
flutter pub add provider sqflite path path_provider just_audio shared_preferences crypto fl_chart
```

### Step 2.2: Assets aur fonts
```
assets/data/yaseen.db
assets/audio/ayat_001.mp3 ... ayat_083.mp3
assets/fonts/AmiriQuran-Regular.ttf
assets/fonts/NotoNastaliqUrdu-Regular.ttf
assets/fonts/Poppins-Regular.ttf, Poppins-Medium.ttf, Poppins-SemiBold.ttf
```
`pubspec.yaml`:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/data/
    - assets/audio/
    - assets/images/
  fonts:
    - family: AmiriQuran
      fonts:
        - asset: assets/fonts/AmiriQuran-Regular.ttf
    - family: NotoNastaliq
      fonts:
        - asset: assets/fonts/NotoNastaliqUrdu-Regular.ttf
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
```
YAML mein indentation (spaces) bilkul sahi rakho.

### Step 2.3: Folder structure
TRD.md section 4 ke mutabiq `lib/` ke andar `core/ models/ services/ repositories/ providers/ screens/ widgets/` folders banao.

### Step 2.4: Theme
UI-UX.md section 12 ka theme code `core/theme/app_theme.dart` mein rakho. `main.dart` mein `theme`, `darkTheme`, `themeMode` lagao.

**Deliverable:** Khali app jo theme aur fonts ke saath chalti hai.

---

## Phase 3: Data Layer (Hafta 2, baqi din)

### Step 3.1: Models
`Ayat`, `Word`, `Segment`, `AppUser`, `Bookmark` classes, har ek mein `fromMap(Map<String, Object?>)`.

```dart
class Ayat {
  final int id;
  final String arabic;
  final String urdu;
  final String audioPath;
  Ayat({required this.id, required this.arabic, required this.urdu, required this.audioPath});

  factory Ayat.fromMap(Map<String, Object?> m) => Ayat(
        id: m['id'] as int,
        arabic: m['arabic'] as String,
        urdu: m['urdu'] as String,
        audioPath: m['audio_path'] as String,
      );
}
```

### Step 3.2: DatabaseService
TRD.md section 5.3 ka code (assets se DB copy karke open karna).

### Step 3.3: Repositories
- `AyatRepository`: `getAllAyaat()`, `getAyat(id)`, `getWords(ayatId)`, `getSegments(wordId)`
- `UserRepository`: `createUser()`, `getUsers()`, `verifyPin()`, `deleteUser()`
- `ProgressRepository`: `markRead()`, `readCount()`, `weeklyCounts()`, `streak()`
- `BookmarkRepository`: `toggle()`, `getAll()`

### Step 3.4: Test
Chhoti test screen banao jo 83 ayaat ka count aur pehli ayat ke words console mein print kare.

**Deliverable:** Database se data sahi parha ja raha ho.

---

## Phase 4: Login aur Navigation (Hafta 3)

### Step 4.1: Auth logic
TRD.md section 8 ka `hashPin/verifyPin`. `AuthProvider`: `createProfile`, `login`, `logout`, `continueAsGuest`.

### Step 4.2: Screens
1. **Splash:** 2 second, phir check: users hain? Haan → Login, nahi → Create Profile
2. **Create Profile:** naam, avatar, PIN, confirm PIN (validation: 4 digits, dono match)
3. **Login:** PIN keypad (UI-UX.md 6.2), galat PIN par shake aur attempts counter

### Step 4.3: Main shell
`BottomNavigationBar` (Home, Ayaat, Grammar, Quiz, Profile) aur `IndexedStack` taake tab ki state na jaye.

**Test:** profile banao, app band karo, dobara kholo, PIN se login ho. Galat PIN reject ho.

**Deliverable:** Login se Dashboard tak ka flow.

---

## Phase 5: Ayaat aur Grammar (Hafta 3-4)

### Step 5.1: Ayaat list
`ListView.builder` mein `AyatCard`. Arabic RTL, Urdu RTL, number badge, play, bookmark.

### Step 5.2: Ayat Detail
Navigator se ayat detail kholo. `AyatProvider` se words load karo.

### Step 5.3: WordChip
```dart
class WordChip extends StatelessWidget {
  final Word word;
  final Color color;
  final VoidCallback onTap;
  const WordChip({super.key, required this.word, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: 3)),
        ),
        child: Text(
          word.arabic,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 26, height: 2.0),
        ),
      ),
    );
  }
}
```
Chips ko `Wrap(textDirection: TextDirection.rtl, ...)` mein rakho.

### Step 5.4: Grammar bottom sheet
`showModalBottomSheet` ya `DraggableScrollableSheet`. `getSegments(wordId)` se tukde laa kar:
- Har tukde ka card: Arabic, qism (Ism/Fe'l/Harf), sub-type, i'rab, jins/adad, zameer ki qism
- Neeche "Pichla/Agla lafz" buttons
- Jo field null ho woh dikhana hi nahi

### Step 5.5: Mapping labels
`core/constants.dart` mein database ki values ko display text mein badlo:
```dart
const kindLabel = {'ism': 'Ism', 'fil': "Fe'l", 'harf': 'Harf'};
const i3rabLabel = {'marfu': 'Marfu', 'mansub': 'Mansub', 'majroor': 'Majroor'};
const pronounLabel = {'muttasil': 'Muttasil', 'munfasil': 'Munfasil'};
```

### Step 5.6: Progress
Ayat detail khulne par `markRead(ayatId)`.

**Test:** 5-10 alag ayaat ke lafz tap karke grammar ustad ya Corpus website se milao.

**Deliverable:** Poora word-by-word grammar feature.

---

## Phase 6: Audio (Hafta 5)

### Step 6.1: AudioService
TRD.md section 7 ka code (`just_audio` playlist).

### Step 6.2: AudioProvider
`currentIndexStream` aur `playerStateStream` sun kar `currentAyat` aur `isPlaying` update karo.

### Step 6.3: UI
- Ayat card aur detail screen par play/pause
- Chalti ayat par gold border
- `ScrollController`/`scrollable_positioned_list` se auto-scroll
- **MiniPlayer** (bottom nav ke upar) aur full player sheet
- Repeat modes aur speed (`player.setSpeed`)

### Step 6.4: App lifecycle
App background mein jaye to audio rok do ya rakho (baad wala sirf tab karo jab background audio ki alag setup karo). Class project ke liye rokna kaafi hai.

**Test:** Har 83 ayat ki audio sahi ayat par chale. Next/previous theek ho.

**Deliverable:** Mukammal offline audio player.

---

## Phase 7: Dashboard, Bookmarks, Search, Settings (Hafta 5-6)

1. **Dashboard:** greeting, ProgressRing (`readCount/83`), Continue button, streak, weekly chart (`fl_chart` BarChart), bookmarks list
2. **Bookmarks:** toggle button, bookmarks screen, swipe-to-delete + undo
3. **Search:** ayat number se jump (`ScrollController` ya Navigator)
4. **Settings:** theme, font sizes, tarjuma/word-meaning toggles, speed (sab `shared_preferences` mein save), PIN change, profile delete
5. **Mauzoobaat:** topics list, tap se related ayaat
6. **Grammar Guide:** istilahat ki expandable list (TRD/PRD ki list ke mutabiq), misalein apni database ki ayaat se
7. **About screen:** credits aur sources

**Deliverable:** Tamam P0 + P1 screens.

---

## Phase 8: Quiz (Hafta 6)

1. **Question generator:** `segments` se random lafz, sahi `kind`, aur galat options
2. **Screen:** 10 sawal, progress bar, instant feedback
3. **Result:** score, `quiz_attempts` mein save
4. **Dashboard:** best/last score dikhana

**Deliverable:** Chalta hua quiz.

---

## Phase 9: Polish (Hafta 7)

- Splash animation, page transitions
- Empty states aur loading indicators
- Error handling (database na khule to saaf message)
- Dark mode ki har screen check
- Font size ke extreme values par layout
- App icon (`flutter_launcher_icons`) aur app ka naam
- Code saaf karna: `flutter analyze` aur `dart format .`

```bash
flutter pub add dev:flutter_launcher_icons
```
`pubspec.yaml` mein icon config likho aur `dart run flutter_launcher_icons` chalao.

---

## Phase 10: Testing (Hafta 7)

| Test | Kaise |
|---|---|
| Unit | `hashPin/verifyPin`, streak, quiz generator |
| Widget | Login screen, AyatCard |
| Data | Validation SQL (Phase 1.5) dobara chalao |
| Audio | 83 ayaat ki checklist (har audio sahi?) |
| Offline | Airplane mode ON, poora app chalao |
| Devices | Kam az kam 2 real phones + 1 emulator |
| Edge cases | Naya install, app update, galat PIN, 0 bookmarks |
| Review | Ustad se final content review |

```bash
flutter test
flutter analyze
```

**Bug tracking:** ek simple checklist (Google Sheet/GitHub Issues) mein bugs likho aur fix hone par tick karo.

---

## Phase 11: Release (Hafta 8)

### Step 11.1: Signing
```bash
keytool -genkey -v -keystore ~/yaseen-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias yaseen
```
`android/key.properties` banao, `build.gradle` mein signingConfig lagao. **Keystore aur password GitHub par mat daalo; backup apne paas rakho.**

### Step 11.2: Build
```bash
flutter build apk --release --split-per-abi
```
APK `build/app/outputs/flutter-apk/` mein milegi. Zyada tar phones ke liye `app-arm64-v8a-release.apk` kaam aati hai; confusion se bachne ke liye ek universal APK bhi bana lo (`flutter build apk --release`).

### Step 11.3: Install test
Release APK ko ek saaf phone par install karo aur poora checklist dobara chalao.

### Step 11.4: Report aur presentation
- Report: Introduction, Objectives, Requirements (PRD), Design (UI/UX), Technology (TRD), Implementation, Screenshots, Testing, Limitations, Future work, References/Credits
- Presentation: 8-10 slides, aur **live demo** (airplane mode ON karke dikhao ke app offline chalti hai)
- Surah Yaseen ke mauzoobaat aur sabaq ka section bhi report mein shamil karo, kyunki yeh Islamiyat ka project hai

---

## Timeline Summary

| Hafta | Kaam | Deliverable |
|---|---|---|
| 0 (3 din) | Tools, project setup | Default app chale |
| 1 | Data tayyar, audio, ustad review | yaseen.db + audio |
| 2 | Project setup, data layer | DB se data parh sake |
| 3 | Login, navigation, ayaat list | Login se ayaat tak |
| 4 | Word-by-word grammar | Core feature |
| 5 | Audio, dashboard | Player + dashboard |
| 6 | Bookmarks, settings, quiz | P1 features |
| 7 | Polish aur testing | Bug-free build |
| 8 | Release, report, presentation | APK + report |

## Priority Cut (Agar Time Kam Ho)

**Har haal mein:** Ayaat + tarjuma, grammar bottom sheet, audio, local login, dashboard (basic), dark mode.
**Pehle hata sakte hain:** quiz, weekly chart, streak, PIN lock timer, speed control, Grammar Guide (sirf ek chhota version rakho).

## Common Masail aur Hal

| Masla | Hal |
|---|---|
| `flutter doctor` mein Android licenses | `flutter doctor --android-licenses` |
| Arabic harakat kat rahi hain | `height: 2.0`, Quran font |
| Audio nahi chal rahi | Assets `pubspec.yaml` mein listed hain? File ka naam/path sahi? `flutter clean` aur dobara run |
| Database purana data dikha raha hai | App uninstall karke dobara install karo (ya migration likho) |
| YAML error | Indentation spaces check karo |
| APK bohat bari | Audio 64 kbps mono, `--split-per-abi` |
| Hot reload mein DB change nazar nahi aata | Full restart karo (asset change hot reload se nahi aata) |

## Final Checklist (Submit Karne Se Pehle)

- [ ] 83 ayaat, tarjuma aur grammar verified
- [ ] Har ayat ki audio sahi
- [ ] Airplane mode mein sab chalta hai
- [ ] Login, bookmark, progress app band karke bhi save
- [ ] Light/Dark dono theme theek
- [ ] Credits (Tanzil, Corpus, qaari, translator) About mein
- [ ] Signed release APK tayyar
- [ ] Source code GitHub par (keystore ke bina)
- [ ] Report aur presentation tayyar
- [ ] Ustad ne data dekh liya

---

*Har phase ke start mein mujhe bata dena, main us phase ka complete code (screens, providers, repositories) ek ek karke likh dunga.*
