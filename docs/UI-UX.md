# UI/UX Design Document

**Project:** Yaseen Tutor (Offline Flutter App)
**Design style:** Modern Islamic, clean, calm, readable

---

## 1. Design Principles

1. **Parhna pehle:** Arabic text bara, saaf aur sukoon bhara ho
2. **Seekhna asaan:** Grammar ek tap par, bina ghabraye
3. **Calm look:** Zyada rang aur shor nahi; green + gold ka sukoon
4. **Har jagah consistent:** Same cards, same buttons, same spacing
5. **Accessible:** Bara font, achha contrast, bade tap targets

## 2. Colour System

### Light Theme
| Token | Hex | Use |
|---|---|---|
| primary | #0B6E4F | AppBar, buttons, active icons |
| primaryDark | #064E38 | Pressed state |
| accent (gold) | #C9A227 | Highlights, streak, ayat number badge |
| background | #FAF6EA | Screen background |
| surface | #FFFFFF | Cards |
| textPrimary | #1F2933 | Main text |
| textSecondary | #5F6B76 | Chhota text |
| divider | #E6E0CC | Lines |
| error | #B3261E | Galat PIN, errors |
| success | #1E9E5A | Sahi jawab |

### Dark Theme
| Token | Hex |
|---|---|
| background | #0F1F1A |
| surface | #172A23 |
| primary | #3DBE8B |
| accent | #E0B84A |
| textPrimary | #F2F0E6 |
| textSecondary | #B7C2BC |
| divider | #2A3D35 |

> Dark mode mein primary green halka rakho (#3DBE8B), warna gehre background par chhup jayega. Contrast ratio kam az kam 4.5:1 check karo (WebAIM Contrast Checker).

### Grammar Colour Coding
| Qism | Rang | Hex | Label |
|---|---|---|---|
| Ism | Neela | #1E6FD9 | اسم |
| Fe'l | Sabz | #1E9E5A | فعل |
| Harf | Surkh | #D64545 | حرف |
| Zameer | Narangi | #E58A1F | ضمیر |

Rang ke saath **label bhi** dikhao, taake color-blind users ko masla na ho.

## 3. Typography

| Use | Font | Size | Weight |
|---|---|---|---|
| Arabic ayat | Amiri Quran | 26-34 (default 28) | Regular |
| Arabic lafz chip | Amiri Quran | 24 | Regular |
| Urdu tarjuma | Noto Nastaliq Urdu | 16-20 (default 17) | Regular |
| Headings | Poppins | 20-24 | SemiBold |
| Body/UI | Poppins | 14-16 | Regular |
| Buttons | Poppins | 15 | Medium |
| Caption | Poppins | 12 | Regular |

- Arabic line height: 2.0; Urdu (Nastaliq) line height: 2.0-2.2 (is ki lambi shakal ke liye zyada jagah chahiye)
- Sab fonts app ke andar bundle karo (offline)
- User font size slider se Arabic aur Urdu ka size badal sake

## 4. Spacing, Shape aur Elevation

- **Spacing scale:** 4, 8, 12, 16, 24, 32
- **Screen padding:** 16
- **Card radius:** 16, **Button radius:** 12, **Chip radius:** 10
- **Elevation:** cards par halka shadow (1-2), bottom sheet par 8
- **Tap target:** kam az kam 48x48 dp
- **Icons:** Material Symbols (rounded)
- **Pattern:** halke Islamic geometric pattern ka background (5-8% opacity) sirf splash, login aur dashboard header par

## 5. Navigation Structure

```
Splash
  ↓
Login / Create Profile (ya Guest)
  ↓
Main Shell (Bottom Navigation)
 ├── Home (Dashboard)
 ├── Ayaat  ──→ Ayat Detail ──→ Grammar Bottom Sheet
 ├── Grammar Guide
 ├── Quiz
 └── Profile / Settings
Extra screens: Mauzoobaat, Bookmarks, About
Persistent: Mini Player (bottom nav ke upar)
```

**Bottom Navigation (5 tabs):** Home, Ayaat, Grammar, Quiz, Profile. Active tab ka rang primary, neeche chhota gold indicator.

## 6. Screen-by-Screen Design

### 6.1 Splash Screen
- Gehra green background (gradient #0B6E4F → #064E38)
- Beech mein "يس" bara gold calligraphy
- Neeche: "Yaseen Tutor" aur tagline "Qalb-ul-Quran ko samjho"
- 2 second, fade-in animation, phir login ya dashboard

### 6.2 Login Screen
```
┌───────────────────────────┐
│  [Islamic pattern header] │
│        (Avatar)           │
│    Welcome back, Ali      │
│                           │
│     ○  ○  ○  ○           │  ← PIN dots
│                           │
│   1   2   3               │
│   4   5   6               │  ← Custom numeric keypad
│   7   8   9               │
│   ⌫   0   ✓               │
│                           │
│  [Switch profile]         │
│  [Continue as Guest]      │
└───────────────────────────┘
```
- PIN dots bharte hain jaise digit dabate hain
- Galat PIN: dots halka shake animation + surkh message "PIN galat hai"
- 5 galat attempts par 30 second lock aur countdown
- Pehli baar: "Create Profile" form: naam, avatar choose, PIN, confirm PIN

### 6.3 Dashboard (Home)
```
┌───────────────────────────────┐
│ Assalamu Alaikum, Ali    🔥5  │ ← greeting + streak
│ ┌───────────────────────────┐ │
│ │  (circular 30%)  25/83    │ │ ← Progress card
│ │  Ayaat parh li gayin      │ │
│ │  [Continue: Ayat 26 ▶]    │ │
│ └───────────────────────────┘ │
│  Quick Actions                │
│  [Ayaat] [Grammar] [Topics]   │
│  [Quiz]  [Bookmarks]          │
│  Is hafte ka reading chart    │
│  ▂ ▄ ▆ ▃ ▇ ▁ ▅              │
│  Bookmarks (horizontal list)  │
└───────────────────────────────┘
```
- Greeting card par halka gradient aur pattern
- Streak ka badge gold
- Chart `fl_chart` se, green bars
- Khali state: "Abhi tak koi ayat nahi parhi, shuru karo"

### 6.4 Ayaat List Screen
Har ayat ka **card**:
```
┌───────────────────────────────┐
│ (12)                  ▶  🔖  │ ← ayat number badge (gold), play, bookmark
│                               │
│  Arabic text (RTL, bara)      │
│  ─────────────────────        │
│  Urdu tarjuma (RTL)           │
└───────────────────────────────┘
```
- AppBar mein search icon: ayat number daalo
- Font size aur tarjuma toggle ke liye AppBar menu
- Chalti ayat ka card border gold aur halka highlight
- Card par tap karne se Ayat Detail khule

### 6.5 Ayat Detail + Grammar (Core Screen)
- Upar: ayat number aur audio controls (prev, play, next, repeat)
- Beech: Arabic ayat **lafz ba lafz chips** ki shakal mein (RTL Wrap), har chip par underline ka rang us lafz ki qism ka
- Chip ke neeche chhota Urdu meaning (optional toggle "Word meaning dikhao")
- Neeche: poora Urdu tarjuma

**Chip par tap karne par Bottom Sheet (draggable):**
```
┌───────────────────────────────┐
│  ━━━                          │
│        قَالُوا                 │ ← lafz bara
│   "unhon ne kaha"             │
│  ┌──────────┬───────────────┐ │
│  │ Qism     │ Fe'l (Madhi)  │ │
│  │ Sigha    │ Jama, Ghaib   │ │
│  │ Jad      │ ق و ل         │ │
│  │ I'rab    │ Mabni         │ │
│  └──────────┴───────────────┘ │
│  Lafz ke tukde:               │
│  [قَالُ] Fe'l  +  [وا] Zameer  │
│  (Muttasil)                   │
│  Note: ...                    │
│  [← Pichla lafz] [Agla lafz →]│
└───────────────────────────────┘
```
- Jin lafzon mein kayi tukde hon (jaise "wa" + ism), har tukda alag rang ka card
- Sheet mein "Pichla/Agla lafz" buttons taake ayat ke lafz ek ek karke parh sakein
- Har istilah (jaise "Muttasil") par tap se Grammar Guide ki wazahat khule

### 6.6 Audio Mini Player
- Bottom nav ke upar chhota bar: ayat number, play/pause, next, close
- Tap karne par full player sheet: seek bar, speed, repeat mode, ayat list

### 6.7 Grammar Guide Screen
- Sections (expandable cards): Ism, Fe'l, Harf, Zameer, I'rab (Marfu/Mansub/Majroor), Mabni/Mu'rab, Harf ki aqsam (Jar, Nida, Atf, Nafi, Istifham, Shart, Tahqeeq), Huroof-e-Muqatta'at
- Har istilah: Arabic naam, Urdu wazahat, aur Surah Yaseen se ek misal
- Upar search bar

### 6.8 Mauzoobaat Screen
- 5 topic cards (icon + title + ayat range), tap se related ayaat ki list

### 6.9 Quiz Screen
- Home: "Quiz shuru karo" aur pichle scores
- Sawal card: lafz bara dikhao, 3-4 options, progress bar upar
- Jawab dene par: sahi = sabz, galat = surkh + sahi jawab ki wazahat
- Result: score, "dobara koshish", "grammar guide dekho"

### 6.10 Bookmarks Screen
- Ayat cards ki list, swipe-to-delete (undo snackbar ke saath)
- Khali state: "Koi bookmark nahi"

### 6.11 Settings / Profile
- Profile card (naam, avatar), Theme toggle (Light/Dark/System), Arabic font size, Urdu font size, Tarjuma on/off, Word meaning on/off, Audio speed, PIN change, Profile delete (confirmation ke saath), About (credits, sources, version)

### 6.12 About Screen
- App ka naam, version, developer ka naam
- Data sources ke credits (Tanzil, Quranic Arabic Corpus, qaari, translator)
- Ustad/supervisor ka naam

## 7. Components Library

| Component | Detail |
|---|---|
| AyatCard | number badge, arabic, urdu, actions |
| WordChip | arabic text + rang ki underline + optional meaning |
| GrammarSheet | draggable bottom sheet |
| PinKeypad | 3x4 custom keypad |
| ProgressRing | circular percent |
| StatCard | icon + number + label |
| MiniPlayer | persistent audio bar |
| SectionHeader | title + "see all" |
| EmptyState | icon + message + action |

## 8. Interactions aur Animations

- Page transition: halka slide + fade (250 ms)
- Chip tap: halka scale (0.95) aur ripple
- Bottom sheet: smooth drag, snap points 40% / 85%
- Chalti ayat: highlight fade, auto-scroll
- PIN galat: shake (300 ms)
- Quiz jawab: color transition (200 ms)
- Animations ko mukhtasar rakho (200-300 ms), zyada tez ya zyada lambi nahi

## 9. Accessibility

- Font scaling system settings ke mutabiq chale; layout toot'na nahi chahiye
- Contrast 4.5:1
- Tap target 48dp
- Rang ke saath label/icon
- `Semantics` labels buttons par (jaise "Ayat 12 play karo")
- Dark mode mein sab screens check

## 10. Content Tone (UI Text)

- Roman Urdu/simple English, mukhtasar aur izzat ke saath
- Misal: "Ayat 26 se jaari rakhein", "PIN galat hai, dobara koshish karein"
- Quran se mutaliq jagah par adab ka khayal: Quran ka text kabhi bhi mazaak ya game-like animation ke saath nahi, aur Arabic text ko tor kar ya bigaar kar mat dikhana

## 11. Design Deliverables

1. Figma wireframes (low-fidelity) 11 screens ke liye
2. Style guide (colors, fonts, components)
3. High-fidelity mockups (Light + Dark)
4. Clickable prototype (optional)
5. Flutter `ThemeData` jo isi style guide se bane

## 12. Flutter Theme Code (Starter)

```dart
import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0B6E4F);
  static const gold = Color(0xFFC9A227);
  static const bgLight = Color(0xFFFAF6EA);
  static const bgDark = Color(0xFF0F1F1A);
}

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  scaffoldBackgroundColor: AppColors.bgLight,
  fontFamily: 'Poppins',
  cardTheme: CardThemeData(
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.bgDark,
  fontFamily: 'Poppins',
);
```

> Agar `CardThemeData` ka naam aapke Flutter version mein na chale to `CardTheme` use karo; Flutter ke versions mein yeh naam badla hai.

## 13. UX Testing Checklist

- [ ] Naya user 1 minute mein profile bana sakta hai
- [ ] Koi bhi lafz 2 taps mein grammar dikha deta hai
- [ ] Audio chalte waqt ayat highlight hoti hai
- [ ] Bari font size par bhi layout theek
- [ ] Dark mode mein sab text parhne layak
- [ ] 3 logon (dost/ustad) se feedback lena aur usi hisaab se tabdeeli
