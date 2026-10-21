# PRD: Surah Yaseen Offline Learning App

**Product Requirements Document**
**Version:** 1.0 | **Platform:** Android (Flutter) | **Type:** Offline-first mobile app | **Subject:** Islamiyat Project

---

## 1. Product Overview

**App ka naam:** Yaseen Tutor (Qalb-ul-Quran)

Yeh ek offline Android app hai jo Surah Yaseen (Makki, 83 ayaat, Para 22-23) ko samajh kar parhne mein madad karti hai. Har ayat ke saath Arabic text, Urdu tarjuma, qaari ki audio aur **har lafz ki Arabic grammar (nahw)** dikhai jati hai. App ko chalane ke liye internet ki zaroorat nahi.

## 2. Problem Statement

- Aam students Surah Yaseen tilawat to kar lete hain, lekin matlab aur grammar nahi samajhte
- Tarjuma, grammar aur audio alag alag kitabon/apps mein milte hain
- Zyada tar Quran apps online chalti hain, jabke bohat si jagah internet nahi hota
- Arabic grammar ki istilahat (marfu, mansub, majroor, muttasil, munfasil wagera) beginners ke liye mushkil hoti hain

## 3. Goals aur Success Metrics

| Goal | Kaise napenge |
|---|---|
| Har ayat ka tarjuma aur grammar ek jagah | 83/83 ayaat ka data complete |
| Poori app offline chale | Airplane mode mein har feature test pass |
| Grammar asaan tareeqe se samjhana | Har lafz par tap karke 2 second mein detail khule |
| Seekhne ko mazedar banana | Quiz aur progress dashboard kaam kare |
| Data ki durusti | Ustad se text aur grammar verify ho |

## 4. Target Users

1. **School/college students** (primary): Islamiyat ke project aur seekhne ke liye
2. **Quran seekhne walay beginners:** jo tarjuma aur grammar sath sath seekhna chahte hain
3. **Ustad/teachers:** class mein dikhane ke liye

**User persona:** Ali, 16 saal ka student, Android phone, kabhi kabhi internet nahi hota, Urdu aur thori English samajhta hai, Arabic grammar seekh raha hai.

## 5. Scope

### In Scope (Version 1.0)
- Surah Yaseen ki tamam 83 ayaat
- Arabic text, Urdu tarjuma
- Ayat by ayat audio aur poori surat ki audio
- Word-by-word meaning aur grammar
- Local login (naam + PIN) aur guest mode
- Dashboard, bookmarks, search, quiz
- Dark/Light mode, font size
- Android APK

### Out of Scope (Future)
- Dusri suratein
- Online backend, cloud sync
- iOS release, Play Store release
- Voice recognition (tilawat check)

## 6. Functional Requirements

Priority: **P0** = zaroori, **P1** = important, **P2** = extra.

### 6.1 Authentication (Local)
| ID | Requirement | Priority |
|---|---|---|
| AU-1 | User naam, avatar aur 4-digit PIN se profile bana sake | P0 |
| AU-2 | App kholne par PIN se login ho | P0 |
| AU-3 | PIN hash (SHA-256 + salt) ke saath save ho, plain text mein nahi | P0 |
| AU-4 | Guest mode (bina login) | P1 |
| AU-5 | PIN change aur profile delete | P1 |
| AU-6 | 5 galat PIN ke baad 30 second ka lock | P2 |

> Note: login sirf is phone par local hai. Yeh online account nahi hai, aur PIN sirf privacy ke liye hai, bank jaisi security nahi.

### 6.2 Dashboard
| ID | Requirement | Priority |
|---|---|---|
| DB-1 | Greeting card ("Assalamu Alaikum, [Naam]") | P0 |
| DB-2 | Progress card: parhi hui ayaat / 83, circular progress | P0 |
| DB-3 | "Continue reading" button aakhri ayat par | P0 |
| DB-4 | Quick actions: Ayaat, Grammar Guide, Mauzoobaat, Quiz | P0 |
| DB-5 | Daily streak | P1 |
| DB-6 | Weekly reading chart | P1 |
| DB-7 | Bookmarks ka short list | P1 |

### 6.3 Ayaat Reading
| ID | Requirement | Priority |
|---|---|---|
| AY-1 | 83 ayaat ki list: Arabic + Urdu tarjuma + ayat number | P0 |
| AY-2 | Har ayat par play/pause audio | P0 |
| AY-3 | Bookmark button | P0 |
| AY-4 | Font size slider (Arabic aur Urdu alag) | P1 |
| AY-5 | Ayat number se jump (search) | P1 |
| AY-6 | Tarjuma show/hide toggle | P1 |
| AY-7 | Ayat copy/share (text) | P2 |

### 6.4 Word-by-Word Grammar (Core Feature)
| ID | Requirement | Priority |
|---|---|---|
| GR-1 | Ayat ke har lafz par tap karne se bottom sheet khule | P0 |
| GR-2 | Sheet mein: lafz, meaning, kalimay ki qism (Ism/Fe'l/Harf) | P0 |
| GR-3 | Ism ke liye: jins, adad, halat (marfu/mansub/majroor), mabni/mu'rab | P0 |
| GR-4 | Fe'l ke liye: madhi/mudare/amr/nahi, sigha (jins, adad, purush) | P0 |
| GR-5 | Harf ke liye: qism (jar, nida, atf, nafi, istifham, shart, tahqeeq wagera) | P0 |
| GR-6 | Zameer ke liye: muttasil ya munfasil | P0 |
| GR-7 | Lafz ki jad (root) aur grammar note | P1 |
| GR-8 | Har qism ka alag rang (color coding) | P1 |
| GR-9 | Lafz ke tukde (prefix/stem/suffix) alag dikhana, jaise "wa" + lafz | P1 |
| GR-10 | Grammar Guide screen jisme har istilah ki wazahat aur misal ho | P1 |

### 6.5 Audio
| ID | Requirement | Priority |
|---|---|---|
| AD-1 | Ayat by ayat offline audio | P0 |
| AD-2 | Play, pause, next, previous | P0 |
| AD-3 | Chalti ayat highlight aur auto-scroll | P1 |
| AD-4 | Repeat (ek ayat / poori surat) | P1 |
| AD-5 | Speed 0.75x, 1x, 1.25x | P2 |
| AD-6 | Mini player (neeche) | P1 |

### 6.6 Mauzoobaat (Topics)
- 5 main topics aur har topic ki related ayaat par link (P1)

### 6.7 Quiz
- Grammar quiz: "Is lafz ki qism kya hai?" (P1)
- Ayat ka matlab match karo (P2)
- Score save ho aur dashboard mein dikhe (P1)

### 6.8 Settings
- Dark/Light mode (P0), font size (P1), tarjuma on/off (P1), audio speed (P2), PIN/profile change (P1), About page (P1)

## 7. Non-Functional Requirements

| Category | Requirement |
|---|---|
| Offline | Poori app airplane mode mein chale |
| Performance | App 3 second se kam mein khule; ayat list smooth scroll (60 fps) |
| Size | APK 60 MB se kam (audio compressed) |
| Compatibility | Android 7.0 (API 24) aur upar |
| Security | PIN hashed, koi sensitive data plain text mein nahi |
| Accuracy | Quran text unmodified, verified source se |
| Accessibility | Font scaling, achha contrast, tap targets 48dp |
| Language | UI: Roman Urdu/English; Content: Arabic + Urdu |
| Privacy | Koi data phone se bahar nahi jata, koi analytics nahi |

## 8. User Stories

1. Student ke tor par, mein ayat par tap karke har lafz ka matlab aur grammar dekhna chahta hoon, taake mein samajh sakoon.
2. Student ke tor par, mein ayat ki audio sunna chahta hoon, taake sahi tilawat seekh sakoon.
3. Student ke tor par, mein bookmark lagana chahta hoon, taake wapas wahin se parhoon.
4. Student ke tor par, mein quiz se apni grammar test karna chahta hoon.
5. Teacher ke tor par, mein class mein dashboard aur grammar dikhana chahta hoon.

## 9. Acceptance Criteria (Mukhtasar)

- 83 ayaat dikhti hain aur Arabic text verified source se match karta hai
- Har ayat ki audio sahi ayat se mel khati hai
- Kisi bhi lafz par tap karne se grammar sheet khulti hai
- Airplane mode mein sab features chalte hain
- Dark mode mein koi text parha na jane wala na ho
- App band karke dobara kholne par bookmark aur progress bache hon

## 10. Content aur Data Policy

- **Quran text:** Tanzil.net ya Al-Quran Cloud se, bina tabdeeli. Apne haath se type nahi karna
- **Urdu tarjuma:** kisi mustanad tarjuma se (jaise Tanzil par maujood Urdu tarajim), translator ka naam app ke About page mein likhna
- **Grammar:** Quranic Arabic Corpus se; unki license/attribution shartein parhein aur About page mein credit dein
- **Audio:** EveryAyah.com se kisi mashhoor qaari ki recitation, terms of use dekh kar
- **Verification:** final data ustad se check karwana zaroori hai
- **Hadees/fazail:** sirf mustanad (authentic) hawalon ke saath

## 11. Risks

| Risk | Asar | Hal |
|---|---|---|
| Grammar data ki ghalti | Zyada | Corpus se import, ustad se review |
| Arabic text ki shaping/harkat ke masail | Darmiyana | Quran-specific font, device par test |
| App size barh jana | Kam | Audio 64 kbps, mono |
| Time kam | Zyada | P0 pehle, P2 baad mein |
| License masle | Darmiyana | Sources ke terms parhna, credits dena |

## 12. Release Criteria

- Tamam P0 requirements pass
- Kam az kam 3 alag devices/emulators par test
- Ustad ka data review complete
- Signed release APK tayyar
- Project report aur presentation tayyar
