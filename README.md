# Yaseen Tutor: Offline Surah Yaseen Learning App (Flutter)

Arabic text + Urdu tarjuma + har lafz ki grammar + audio + dashboard + quiz.
**Poori app offline chalti hai** (koi server/internet nahi).

> **Sach baat pehle:** is zip mein Flutter ka poora source code hai, lekin mere paas Flutter chalane ka
> setup nahi tha, isliye code compile/test nahi hua. Pehli baar run par chhoti si error aa sakti hai;
> terminal ka error mujhe bhej dein, theek ho jayegi.
> Zip mein **sirf 4 sample ayaat (1-4)** hain taake app foran chal jaye. Poori 83 ayaat ka data
> aap neeche (Step 6) wali script se banayenge.

---------------------------------------------------------------------

## 1. Zip mein kya hai

```
yaseen_tutor/
├── pubspec.yaml            ← packages, fonts, assets ki list
├── lib/
│   ├── main.dart           ← app ka starting point
│   ├── core/               ← theme (rang), labels, PIN hashing
│   ├── models/             ← Ayat, Word, Segment, Topic, AppUser
│   ├── services/           ← db_service.dart (SQLite)
│   ├── providers/          ← app_state.dart (login, progress...), audio_provider.dart
│   ├── screens/            ← splash, login, profile banana, home, ayaat, grammar guide, quiz,
│   │                         profile/settings, topics, bookmarks
│   └── widgets/            ← ayat card, grammar bottom sheet, mini player, common widgets
├── assets/
│   ├── data/yaseen.db      ← content database (abhi SAMPLE: ayat 1-4)
│   ├── audio/              ← ayat_001.mp3 ... (aap ne daalni hain)
│   └── fonts/              ← Amiri Quran, Noto Nastaliq Urdu, Poppins (open-license, offline)
├── tools/
│   ├── build_database.py   ← poori 83 ayaat ki yaseen.db banati hai
│   └── download_audio.py   ← 83 audio files download/rename karti hai
└── docs/                   ← PRD.md, TRD.md, UI-UX.md, Implementationplan.md
```

**Do database kyun?** `yaseen.db` (assets se copy hota hai, sirf parhne ke liye: ayaat, grammar) aur
`yaseen_user.db` (app khud banati hai: profiles, bookmarks, progress, quiz scores). Is tarah content
update karo to user ka data nahi mitta.

---------------------------------------------------------------------

## 2. Kya kya download/install karna hai (laptop par, ek baar)

| Tool | Kahan se | Kis liye |
|---|---|---|
| **Flutter SDK** | https://docs.flutter.dev/get-started/install | app banane ka framework (Dart us mein shamil hai) |
| **Android Studio** | https://developer.android.com/studio | Android SDK, emulator, licenses |
| **VS Code** (+ "Flutter" extension) | https://code.visualstudio.com | code editor (Android Studio bhi chal sakta hai) |
| **Python 3** | https://www.python.org/downloads | database aur audio scripts |
| **Git** (optional) | https://git-scm.com | code ka backup |
| **ffmpeg** (optional) | https://ffmpeg.org | audio ka size chhota karne ke liye |

Flutter SDK ko unzip karke uska `bin` folder system PATH mein daalen (install page par OS ke hisaab se likha hai).
Android Studio kholen: **More Actions → SDK Manager** mein "Android SDK", "Platform-Tools",
"Command-line Tools" install rakhein.

Phir terminal mein:
```bash
flutter doctor --android-licenses     # sab par 'y'
flutter doctor                        # Android toolchain aur Flutter par tick aana chahiye
```
(Chrome/Visual Studio ke red cross is project ke liye zaroori nahi.)

---------------------------------------------------------------------

## 3. Project taiyar karna (Android folder banana)

Zip mein Android ka generated folder nahi hota, isliye ek naya project banayen aur is zip ki files uske upar copy karein:

```bash
flutter create yaseen_tutor --platforms=android
```
Ab is zip ke andar ki ye cheezein `yaseen_tutor/` mein copy karein (replace/overwrite karein):
`lib/`, `assets/`, `tools/`, `docs/`, `pubspec.yaml`.
Phir `yaseen_tutor/test/widget_test.dart` delete kar dein (wo purani counter app ka test hai).

```bash
cd yaseen_tutor
flutter pub get
```

---------------------------------------------------------------------

## 4. Pehli baar chalana (sample data ke saath)

**Phone par (behtar):**
1. Phone: Settings → About phone → "Build number" par 7 baar tap → Developer options on.
2. Developer options → **USB debugging** on. USB se laptop se jodein, "Allow" dabayein.
3. `flutter devices` mein phone nazar aana chahiye.
4. `flutter run`

**Emulator par:** Android Studio → Device Manager → Create device → start, phir `flutter run`.

Pehli baar app khulegi: Splash → **Profile banayein** (naam, avatar, 4-digit PIN) → Dashboard.
Ayaat tab mein 4 sample ayaat milengi; kisi lafz par tap karein to grammar sheet khulegi.
Audio ke button par abhi "Audio file nahi mili" aayega, jab tak Step 6 mein audio na daalen.

---------------------------------------------------------------------

## 5. App kaise use karni hai (user guide)

- **Login:** PIN daalein. 5 galat PIN par 30 second ka lock. "Guest" se bina profile bhi chal sakti hai.
  PIN sirf is phone par privacy ke liye hai (online account nahi).
- **Home:** progress ring, "Continue" button (pehli na parhi hui ayat), streak, hafte ka chart, shortcuts.
- **Ayaat:** har ayat ka card. ▶ audio, ✓ "parh li" (progress), 🔖 bookmark.
  Lafz ke neeche ka rang qism batata hai: **neela = Ism, sabz = Fe’l, surkh = Harf, narangi = Zameer**.
  Lafz par tap → bottom sheet: lafz ke tukde (prefix/stem/suffix), qism, i’rab (marfu/mansub/majroor),
  mabni/mu’rab, jins, adad, zameer muttasil/munfasil, fe’l ka zamana. "Pichla/Agla lafz" buttons.
  Upar 🔍 se ayat number par jump, 🌐 se tarjuma on/off.
- **Grammar:** Ism, Fe’l, Harf (aqsam), Zameer, I’rab, Mabni/Mu’rab ki wazahat.
- **Quiz:** lafz dekh kar Ism/Fe’l/Harf chunein; score save hota hai.
- **Profile:** Light/Dark/System theme, font size, tarjuma/lafz-matlab on/off, audio speed aur auto-next,
  PIN badlein, profile delete, About, Logout.
- **Mauzoobaat / Bookmarks:** Home ke shortcuts se.

---------------------------------------------------------------------

## 6. POORA DATA (83 ayaat) aur AUDIO banana

### 6a. Data files download karein (apne laptop par)
Ye files `tools/source/` folder (khud banayein) mein rakhein:

1. **Quran text:** https://tanzil.net/download → Quran Text Type: **Uthmani**, Output: **Text (with aya numbers)**
   / pipe format `sura|aya|text`. Download karke `quran-uthmani.txt` naam rakhein.
2. **Urdu tarjuma:** https://tanzil.net/trans → Urdu mein se kisi mustanad tarjume (jaise Jalandhry) ki
   `.txt` file (format `sura|aya|text`). Mutarjim ka naam yaad rakhein (About mein likhna hai).
3. **Grammar:** https://corpus.quran.com/download → morphology file (`quranic-corpus-morphology-0.4.txt`).
   Pehle unki license/shartein parh lein.

### 6b. Database banayein
```bash
python tools/build_database.py --tanzil tools/source/quran-uthmani.txt ^
                               --urdu   tools/source/ur.jalandhry.txt ^
                               --corpus tools/source/quranic-corpus-morphology-0.4.txt
```
(Mac/Linux par `^` ki jagah `\`.) Yeh `assets/data/yaseen.db` ko poori 83 ayaat se badal degi.
Script ke aakhir mein ayaat/words/segments ka count aata hai. **83 ayaat** aani chahiye.
Agar "WARNING ayat N: Tanzil words != Corpus words" aaye to us ayat ko hath se check karein.

Phir `lib/services/db_service.dart` mein `contentVersion = 1` ko `2` kar dein taake phone par nayi
database copy ho (ya app uninstall karke dobara install karein).

**Zaroori:** script ka mapping (Corpus tags → Ism/Fe’l/Harf wagera, `TAGS` dictionary) aur grammar ki
tafseel apne ustad se verify karwayein. Script ko maine in websites ke asal files par test nahi kiya;
agar file ka format alag nikle to uske shuru ki 20 lines mujhe bhej dein.
Lafz ka Urdu matlab (word-by-word) Corpus file mein nahi hota. Agar kisi mustanad source se mile to
`--meanings meanings.csv` (columns: `ayat,word,meaning`) se jod sakte hain; warna app mein woh hissa khali dikhega.

### 6c. Audio
```bash
python tools/download_audio.py --folder Alafasy_128kbps --compress
```
Ye `assets/audio/ayat_001.mp3 ... ayat_083.mp3` banati hai (EveryAyah.com se; folder ka naam unki list se
dekh lein). Download na ho to browser se download karke yahi naam rakh dein. Qaari ka naam About mein likhein.

### 6d. Dobara chalayein
```bash
flutter clean
flutter pub get
flutter run
```

---------------------------------------------------------------------

## 7. APK banana aur phone mein install karna

```bash
flutter build apk --release
```
APK yahan milti hai: `build/app/outputs/flutter-apk/app-release.apk`
(chhoti APK ke liye: `flutter build apk --release --split-per-abi`, phir zyada tar phones ke liye `app-arm64-v8a-release.apk`).

**Phone mein install:**
1. APK ko USB / WhatsApp / Google Drive se phone par bhejein.
2. Phone mein file kholen → agar poochhe to "Install unknown apps" ki ijazat dein.
3. Install karein. App ka naam **yaseen_tutor** hoga; naam badalne ke liye
   `android/app/src/main/AndroidManifest.xml` mein `android:label="Yaseen Tutor"` likhein.
4. Airplane mode on karke check karein ke app offline chalti hai.

(Play Store ke liye signed release aur qaari/data ki licenses chahiye; class project ke liye yeh zaroori nahi.)

---------------------------------------------------------------------

## 8. Aam masail

| Masla | Hal |
|---|---|
| `flutter doctor` mein Android licenses | `flutter doctor --android-licenses` |
| `Unable to locate Android SDK` | Android Studio → SDK Manager se SDK install, phir `flutter config --android-sdk <path>` |
| Phone `flutter devices` mein nahi | USB debugging on, "File transfer" mode, driver (Windows) |
| "Audio file nahi mili" | `assets/audio/ayat_001.mp3` jaise naam sahi hain? `flutter clean` karke dobara run |
| Purana data dikh raha hai | `contentVersion` barhayein ya app uninstall karein |
| Arabic harakat kati hui | Settings mein font size kam/zyada karke dekhein; line height `core/theme.dart` mein hai |
| Package version ka error | `flutter pub upgrade`; phir bhi na chale to error mujhe bhej dein |
| YAML error | `pubspec.yaml` ki spacing (indentation) check karein |

---------------------------------------------------------------------

## 9. Submit karne se pehle checklist

- [ ] 83 ayaat, tarjuma aur grammar ustad ne verify kar liye
- [ ] 83 audio files sahi ayat par chalti hain
- [ ] Airplane mode mein sab kuch chalta hai
- [ ] Light/Dark dono theme theek
- [ ] About mein credits: Tanzil, Quranic Arabic Corpus, qaari, mutarjim, aapka aur ustad ka naam
      (`lib/screens/profile_screen.dart` mein About ka text)
- [ ] Release APK phone par install karke test ki
- [ ] Report mein docs/ ki files (PRD, TRD, UI-UX, Implementation plan) shamil ki

## 10. Limitations (honest)

- PIN login sirf privacy ke liye hai, strong security nahi (4 digit).
- Sample data demo ke liye hai; sample tarjuma/grammar poore data se badal jayenge.
- Audio background mein (screen band) chalane ki alag setup abhi nahi hai.
- Quran ka text, tarjuma aur grammar ki zimmedari verify karna aap ki aur ustad ki hai.
