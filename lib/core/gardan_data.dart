/// Sarf: Arabic Verb Conjugations (14 Sighon ki Gardan)
class GardanEntry {
  final String arabic;
  final String sigha;
  final String urdu;
  final String type; // 'ghaib_m', 'ghaib_f', 'hazir_m', 'hazir_f', 'mutakallim'

  const GardanEntry({
    required this.arabic,
    required this.sigha,
    required this.urdu,
    required this.type,
  });
}

class VerbGardan {
  final String root;
  final String name; // e.g. "خَلَقَ"
  final String urduMeaning; // e.g. "Paida karna / banana"
  final String baab; // e.g. "باب نصر (نَصَرَ يَنْصُرُ)"
  final List<GardanEntry> madhi; // 14 forms
  final List<GardanEntry> mudare; // 14 forms
  final List<GardanEntry> amr; // 6 forms
  final List<GardanEntry> nahi; // 6 forms

  const VerbGardan({
    required this.root,
    required this.name,
    required this.urduMeaning,
    required this.baab,
    required this.madhi,
    required this.mudare,
    required this.amr,
    required this.nahi,
  });
}

/// Standard 14 Sigha names
const List<String> sighaNames14 = [
  'واحد مذکر غائب',
  'تثنیہ مذکر غائب',
  'جمع مذکر غائب',
  'واحد مؤنث غائب',
  'تثنیہ مؤنث غائب',
  'جمع مؤنث غائب',
  'واحد مذکر حاضر',
  'تثنیہ مذکر حاضر',
  'جمع مذکر حاضر',
  'واحد مؤنث حاضر',
  'تثنیہ مؤنث حاضر',
  'جمع مؤنث حاضر',
  'واحد متکلم (مذکر و مؤنث)',
  'جمع متکلم (مذکر و مؤنث)',
];

/// Standard 14 Pronouns corresponding to 14 Sighas
const List<String> pronounNames14 = [
  'هُوَ (Woh ek mard)',
  'هُمَا (Woh do mard)',
  'هُمْ (Woh sab mard)',
  'هِيَ (Woh ek aurat)',
  'هُمَا (Woh do auratein)',
  'هُنَّ (Woh sab auratein)',
  'أَنْتَ (Tu ek mard)',
  'أَنْتُمَا (Tum do mard)',
  'أَنْتُمْ (Tum sab mard)',
  'أَنْتِ (Tu ek aurat)',
  'أَنْتُمَا (Tum do auratein)',
  'أَنْتُنَّ (Tum sab auratein)',
  'أَنَا (Main)',
  'نَحْنُ (Hum sab)',
];

/// Gardan: خَلَقَ (خ - ل - ق) - Specifically requested by user!
const khalakaGardan = VerbGardan(
  root: 'خ ل ق',
  name: 'خَلَقَ (Paida karna)',
  urduMeaning: 'Paida karna / Banaya',
  baab: 'باب نصر (نَصَرَ يَنْصُرُ)',
  madhi: [
    GardanEntry(arabic: 'خَلَقَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne paida kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'خَلَقَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do mardon ne paida kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'خَلَقُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab mardon ne paida kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'خَلَقَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne paida kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'خَلَقَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do auraton ne paida kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'خَلَقْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne paida kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'خَلَقْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne paida kiya (ek mard)', type: 'hazir_m'),
    GardanEntry(arabic: 'خَلَقْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne paida kiya (mardon ne)', type: 'hazir_m'),
    GardanEntry(arabic: 'خَلَقْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne paida kiya (mardon ne)', type: 'hazir_m'),
    GardanEntry(arabic: 'خَلَقْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne paida kiya (ek aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'خَلَقْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne paida kiya (auraton ne)', type: 'hazir_f'),
    GardanEntry(arabic: 'خَلَقْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne paida kiya (auraton ne)', type: 'hazir_f'),
    GardanEntry(arabic: 'خَلَقْتُ', sigha: 'واحد متکلم', urdu: 'Maine paida kiya', type: 'mutakallim'),
    GardanEntry(arabic: 'خَلَقْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne paida kiya', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يَخْلُقُ', sigha: 'واحد مذکر غائب', urdu: 'Woh ek mard paida karta hai ya karega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَخْلُقَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do mard paida karte hain ya karenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَخْلُقُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab mard paida karte hain ya karenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'تَخْلُقُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat paida karti hai ya karegi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَخْلُقَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do auratein paida karti hain ya karengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'يَخْلُقْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein paida karti hain ya karengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَخْلُقُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ek mard paida karta hai ya karega', type: 'hazir_m'),
    GardanEntry(arabic: 'تَخْلُقَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mard paida karte ho ya karoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَخْلُقُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mard paida karte ho ya karoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَخْلُقِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ek aurat paida karti hai ya karegi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَخْلُقَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do auratein paida karti ho ya karogi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَخْلُقْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab auratein paida karti ho ya karogi', type: 'hazir_f'),
    GardanEntry(arabic: 'أَخْلُقُ', sigha: 'واحد متکلم', urdu: 'Main paida karta hoon ya karoonga', type: 'mutakallim'),
    GardanEntry(arabic: 'نَخْلُقُ', sigha: 'جمع متکلم', urdu: 'Hum sab paida karte hain ya karenge', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'اُخْلُقْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu paida kar (ek mard)!', type: 'hazir_m'),
    GardanEntry(arabic: 'اُخْلُقَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do paida karo (mardo)!', type: 'hazir_m'),
    GardanEntry(arabic: 'اُخْلُقُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab paida karo (mardo)!', type: 'hazir_m'),
    GardanEntry(arabic: 'اُخْلُقِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu paida kar (ek aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اُخْلُقَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do paida karo (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اُخْلُقْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab paida karo (auraton)!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تَخْلُقْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu paida mat kar!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَخْلُقَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do paida mat karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَخْلُقُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab paida mat karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَخْلُقِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu paida mat kar (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَخْلُقَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do paida mat karo (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَخْلُقْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab paida mat karo (auraton)!', type: 'hazir_f'),
  ],
);

/// Gardan: فَعَلَ (ف - ع - ل) - Standard Sarf Scale
const faalaGardan = VerbGardan(
  root: 'ف ع ل',
  name: 'فَعَلَ (Karna)',
  urduMeaning: 'Karna / Kiya',
  baab: 'باب فتح (فَتَحَ يَفْتَحُ)',
  madhi: [
    GardanEntry(arabic: 'فَعَلَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'فَعَلَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do mardon ne kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'فَعَلُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab mardon ne kiya', type: 'ghaib_m'),
    GardanEntry(arabic: 'فَعَلَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'فَعَلَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do auraton ne kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'فَعَلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne kiya', type: 'ghaib_f'),
    GardanEntry(arabic: 'فَعَلْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne kiya (ek mard)', type: 'hazir_m'),
    GardanEntry(arabic: 'فَعَلْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne kiya', type: 'hazir_m'),
    GardanEntry(arabic: 'فَعَلْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne kiya', type: 'hazir_m'),
    GardanEntry(arabic: 'فَعَلْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne kiya (ek aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'فَعَلْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne kiya', type: 'hazir_f'),
    GardanEntry(arabic: 'فَعَلْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne kiya', type: 'hazir_f'),
    GardanEntry(arabic: 'فَعَلْتُ', sigha: 'واحد متکلم', urdu: 'Maine kiya', type: 'mutakallim'),
    GardanEntry(arabic: 'فَعَلْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne kiya', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يَفْعَلُ', sigha: 'واحد مذکر غائب', urdu: 'Woh ek mard karta hai ya karega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَفْعَلَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do mard karte hain ya karenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَفْعَلُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab mard karte hain ya karenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'تَفْعَلُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat karti hai ya karegi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَفْعَلَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do auratein karti hain ya karengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'يَفْعَلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein karti hain ya karengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَفْعَلُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ek mard karta hai ya karega', type: 'hazir_m'),
    GardanEntry(arabic: 'تَفْعَلَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mard karte ho ya karoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَفْعَلُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mard karte ho ya karoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَفْعَلِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ek aurat karti hai ya karegi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَفْعَلَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do auratein karti ho ya karogi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَفْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab auratein karti ho ya karogi', type: 'hazir_f'),
    GardanEntry(arabic: 'أَفْعَلُ', sigha: 'واحد متکلم', urdu: 'Main karta hoon ya karoonga', type: 'mutakallim'),
    GardanEntry(arabic: 'نَفْعَلُ', sigha: 'جمع متکلم', urdu: 'Hum sab karte hain ya karenge', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'اِفْعَلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu kar (ek mard)!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِفْعَلَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِفْعَلُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِفْعَلِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu kar (ek aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِفْعَلَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do karo (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِفْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab karo (auraton)!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تَفْعَلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu mat kar!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَفْعَلَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَفْعَلُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat karo!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَفْعَلِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat kar (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَفْعَلَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat karo (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَفْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat karo (auraton)!', type: 'hazir_f'),
  ],
);

/// Gardan: قَالَ (ق - و - ل) - Very frequent in Surah Yaseen! (قَالُوا، قِيلَ، تَقُولُ...)
const qaalaGardan = VerbGardan(
  root: 'ق و ل',
  name: 'قَالَ (Kehna)',
  urduMeaning: 'Kehna / Bola',
  baab: 'باب نصر (نَصَرَ يَنْصُرُ) - معتل العین (اجوف واوی)',
  madhi: [
    GardanEntry(arabic: 'قَالَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne kaha', type: 'ghaib_m'),
    GardanEntry(arabic: 'قَالَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do mardon ne kaha', type: 'ghaib_m'),
    GardanEntry(arabic: 'قَالُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab ne kaha (Surah Yaseen me muta’addid bar aya)', type: 'ghaib_m'),
    GardanEntry(arabic: 'قَالَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne kaha', type: 'ghaib_f'),
    GardanEntry(arabic: 'قَالَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do auraton ne kaha', type: 'ghaib_f'),
    GardanEntry(arabic: 'قُلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne kaha', type: 'ghaib_f'),
    GardanEntry(arabic: 'قُلْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne kaha (ek mard)', type: 'hazir_m'),
    GardanEntry(arabic: 'قُلْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne kaha', type: 'hazir_m'),
    GardanEntry(arabic: 'قُلْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne kaha', type: 'hazir_m'),
    GardanEntry(arabic: 'قُلْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne kaha (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'قُلْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne kaha', type: 'hazir_f'),
    GardanEntry(arabic: 'قُلْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne kaha', type: 'hazir_f'),
    GardanEntry(arabic: 'قُلْتُ', sigha: 'واحد متکلم', urdu: 'Maine kaha', type: 'mutakallim'),
    GardanEntry(arabic: 'قُلْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne kaha', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يَقُولُ', sigha: 'واحد مذکر غائب', urdu: 'Woh kehta hai ya kahega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَقُولَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do mard kehte hain ya kahenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَقُولُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab kehte hain ya kahenge', type: 'ghaib_m'),
    GardanEntry(arabic: 'تَقُولُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat kehti hai ya kahegi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَقُولَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do auratein kehti hain ya kahengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'يَقُلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein kehti hain ya kahengi', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَقُولُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu kehta hai ya kahega', type: 'hazir_m'),
    GardanEntry(arabic: 'تَقُولَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do kehte ho ya kahoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَقُولُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab kehte ho ya kahoge', type: 'hazir_m'),
    GardanEntry(arabic: 'تَقُولِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ek aurat kehti hai ya kahegi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَقُولَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do auratein kehti ho ya kahogi', type: 'hazir_f'),
    GardanEntry(arabic: 'تَقُلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab auratein kehti ho ya kahogi', type: 'hazir_f'),
    GardanEntry(arabic: 'أَقُولُ', sigha: 'واحد متکلم', urdu: 'Main kehta hoon ya kahoonga', type: 'mutakallim'),
    GardanEntry(arabic: 'نَقُولُ', sigha: 'جمع متکلم', urdu: 'Hum sab kehte hain ya kahenge', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'قُلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu keh!', type: 'hazir_m'),
    GardanEntry(arabic: 'قُولَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do kaho!', type: 'hazir_m'),
    GardanEntry(arabic: 'قُولُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab kaho!', type: 'hazir_m'),
    GardanEntry(arabic: 'قُولِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu keh (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'قُولَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do kaho (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'قُلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab kaho (auraton)!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تَقُلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu mat keh!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَقُولَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat kaho!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَقُولُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat kaho!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَقُولِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat keh (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَقُولَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat kaho (auraton)!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَقُلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat kaho (auraton)!', type: 'hazir_f'),
  ],
);

/// Gardan: جَعَلَ (ج - ع - ل) - "وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا"
const jaalaGardan = VerbGardan(
  root: 'ج ع ل',
  name: 'جَعَلَ (Banana / Thehrana)',
  urduMeaning: 'Banana / Thehrana',
  baab: 'باب فتح (فَتَحَ يَفْتَحُ)',
  madhi: [
    GardanEntry(arabic: 'جَعَلَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne banaya', type: 'ghaib_m'),
    GardanEntry(arabic: 'جَعَلَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do mardon ne banaya', type: 'ghaib_m'),
    GardanEntry(arabic: 'جَعَلُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab ne banaya', type: 'ghaib_m'),
    GardanEntry(arabic: 'جَعَلَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne banaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'جَعَلَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do auraton ne banaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'جَعَلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne banaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'جَعَلْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne banaya (ek mard)', type: 'hazir_m'),
    GardanEntry(arabic: 'جَعَلْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne banaya', type: 'hazir_m'),
    GardanEntry(arabic: 'جَعَلْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne banaya', type: 'hazir_m'),
    GardanEntry(arabic: 'جَعَلْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne banaya (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'جَعَلْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne banaya', type: 'hazir_f'),
    GardanEntry(arabic: 'جَعَلْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne banaya', type: 'hazir_f'),
    GardanEntry(arabic: 'جَعَلْتُ', sigha: 'واحد متکلم', urdu: 'Maine banaya', type: 'mutakallim'),
    GardanEntry(arabic: 'جَعَلْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne banaya (jaise Ayat 9 me hai)', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يَجْعَلُ', sigha: 'واحد مذکر غائب', urdu: 'Woh banata hai ya banayega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَجْعَلَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do banate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَجْعَلُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab banate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'تَجْعَلُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat banati hai', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَجْعَلَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do banati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'يَجْعَلْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein banati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَجْعَلُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu banata hai', type: 'hazir_m'),
    GardanEntry(arabic: 'تَجْعَلَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do banate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تَجْعَلُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab banate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تَجْعَلِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu banati hai (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'تَجْعَلَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do banati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'تَجْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab banati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'أَجْعَلُ', sigha: 'واحد متکلم', urdu: 'Main banata hoon', type: 'mutakallim'),
    GardanEntry(arabic: 'نَجْعَلُ', sigha: 'جمع متکلم', urdu: 'Hum banate hain', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'اِجْعَلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu bana!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِجْعَلَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do banao!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِجْعَلُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab banao!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِجْعَلِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu bana (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِجْعَلَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do banao!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِجْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab banao!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تَجْعَلْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu mat bana!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَجْعَلَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat banao!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَجْعَلُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat banao!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَجْعَلِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat bana!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَجْعَلَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat banao!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَجْعَلْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat banao!', type: 'hazir_f'),
  ],
);

/// Gardan: عَلِمَ (ع - ل - م) - "لِتَعْلَمُوا عَدَدَ السِّنِينَ..."
const alimaGardan = VerbGardan(
  root: 'ع ل م',
  name: 'عَلِمَ (Janna / Ma’loom hona)',
  urduMeaning: 'Janna / Ma’loom hona',
  baab: 'باب سمع (سَمِعَ يَسْمَعُ)',
  madhi: [
    GardanEntry(arabic: 'عَلِمَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne jana', type: 'ghaib_m'),
    GardanEntry(arabic: 'عَلِمَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do ne jana', type: 'ghaib_m'),
    GardanEntry(arabic: 'عَلِمُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab ne jana', type: 'ghaib_m'),
    GardanEntry(arabic: 'عَلِمَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne jana', type: 'ghaib_f'),
    GardanEntry(arabic: 'عَلِمَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do ne jana', type: 'ghaib_f'),
    GardanEntry(arabic: 'عَلِمْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne jana', type: 'ghaib_f'),
    GardanEntry(arabic: 'عَلِمْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne jana (ek mard)', type: 'hazir_m'),
    GardanEntry(arabic: 'عَلِمْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne jana', type: 'hazir_m'),
    GardanEntry(arabic: 'عَلِمْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne jana', type: 'hazir_m'),
    GardanEntry(arabic: 'عَلِمْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne jana (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'عَلِمْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne jana', type: 'hazir_f'),
    GardanEntry(arabic: 'عَلِمْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne jana', type: 'hazir_f'),
    GardanEntry(arabic: 'عَلِمْتُ', sigha: 'واحد متکلم', urdu: 'Maine jana', type: 'mutakallim'),
    GardanEntry(arabic: 'عَلِمْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne jana', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يَعْلَمُ', sigha: 'واحد مذکر غائب', urdu: 'Woh janta hai ya janega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَعْلَمَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do jante hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'يَعْلَمُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab jante hain (Surah Yaseen me bar bar aya)', type: 'ghaib_m'),
    GardanEntry(arabic: 'تَعْلَمُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat janti hai', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَعْلَمَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do janti hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'يَعْلَمْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein janti hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'تَعْلَمُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu janta hai', type: 'hazir_m'),
    GardanEntry(arabic: 'تَعْلَمَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do jante ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تَعْلَمُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab jante ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تَعْلَمِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu janti hai (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'تَعْلَمَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do janti ho', type: 'hazir_f'),
    GardanEntry(arabic: 'تَعْلَمْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab janti ho', type: 'hazir_f'),
    GardanEntry(arabic: 'أَعْلَمُ', sigha: 'واحد متکلم', urdu: 'Main janta hoon', type: 'mutakallim'),
    GardanEntry(arabic: 'نَعْلَمُ', sigha: 'جمع متکلم', urdu: 'Hum sab jante hain', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'اِعْلَمْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu jaan le!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِعْلَمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do jaan lo!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِعْلَمُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab jaan lo!', type: 'hazir_m'),
    GardanEntry(arabic: 'اِعْلَمِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu jaan le (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِعْلَمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do jaan lo!', type: 'hazir_f'),
    GardanEntry(arabic: 'اِعْلَمْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab jaan lo!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تَعْلَمْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu mat jaan!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَعْلَمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat jaano!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَعْلَمُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat jaano!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تَعْلَمِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat jaan!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَعْلَمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat jaano!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تَعْلَمْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat jaano!', type: 'hazir_f'),
  ],
);

/// Gardan: أَنْذَرَ (ن - ذ - ر) - "وَسَوَاءٌ عَلَيْهِمْ أَأَنذَرْتَهُمْ أَمْ لَمْ تُنذِرْهُمْ" (Ayat 10)
const andharaGardan = VerbGardan(
  root: 'ن ذ ر',
  name: 'أَنْذَرَ (Darana / Khabardar karna)',
  urduMeaning: 'Darna / Aagah karna',
  baab: 'باب إفعال (ثلاثی مزید فیہ)',
  madhi: [
    GardanEntry(arabic: 'أَنْذَرَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek mard ne daraya', type: 'ghaib_m'),
    GardanEntry(arabic: 'أَنْذَرَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do ne daraya', type: 'ghaib_m'),
    GardanEntry(arabic: 'أَنْذَرُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab ne daraya', type: 'ghaib_m'),
    GardanEntry(arabic: 'أَنْذَرَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne daraya', type: 'ghaib_f'),
    GardanEntry(arabic: 'أَنْذَرَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do ne daraya', type: 'ghaib_f'),
    GardanEntry(arabic: 'أَنْذَرْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne daraya', type: 'ghaib_f'),
    GardanEntry(arabic: 'أَنْذَرْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Aap ne daraya (jaise Ayat 10 me: أَأَنْذَرْتَهُمْ)', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذَرْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne daraya', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذَرْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne daraya', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذَرْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne daraya (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'أَنْذَرْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne daraya', type: 'hazir_f'),
    GardanEntry(arabic: 'أَنْذَرْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne daraya', type: 'hazir_f'),
    GardanEntry(arabic: 'أَنْذَرْتُ', sigha: 'واحد متکلم', urdu: 'Maine daraya', type: 'mutakallim'),
    GardanEntry(arabic: 'أَنْذَرْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne daraya', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يُنْذِرُ', sigha: 'واحد مذکر غائب', urdu: 'Woh darata hai ya darayega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يُنْذِرَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do darate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'يُنْذِرُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab darate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'تُنْذِرُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat darati hai', type: 'ghaib_f'),
    GardanEntry(arabic: 'تُنْذِرَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do darati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'يُنْذِرْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein darati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'تُنْذِرُ', sigha: 'واحد مذکر حاضر', urdu: 'Aap darate hain (jaise: أَمْ لَمْ تُنْذِرْهُمْ)', type: 'hazir_m'),
    GardanEntry(arabic: 'تُنْذِرَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do darate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تُنْذِرُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab darate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تُنْذِرِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu darati hai (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'تُنْذِرَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do darati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'تُنْذِرْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab darati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'أُنْذِرُ', sigha: 'واحد متکلم', urdu: 'Main darata hoon', type: 'mutakallim'),
    GardanEntry(arabic: 'نُنْذِرُ', sigha: 'جمع متکلم', urdu: 'Hum darate hain', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'أَنْذِرْ', sigha: 'واحد مذکر حاضر', urdu: 'Aap daraiye / aagah kijiye!', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذِرَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do darayein!', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذِرُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab darayein!', type: 'hazir_m'),
    GardanEntry(arabic: 'أَنْذِرِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu daraye (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'أَنْذِرَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do darayein!', type: 'hazir_f'),
    GardanEntry(arabic: 'أَنْذِرْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab darayein!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تُنْذِرْ', sigha: 'واحد مذکر حاضر', urdu: 'Mat darayein!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُنْذِرَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat darayein!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُنْذِرُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat darayein!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُنْذِرِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat daraye!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تُنْذِرَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat darayein!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تُنْذِرْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat darayein!', type: 'hazir_f'),
  ],
);

/// Gardan: كَذَّبَ (ك - ذ - ب) - "إِذْ أَرْسَلْنَا إِلَيْهِمُ اثْنَيْنِ فَكَذَّبُوهُمَا" (Ayat 14)
const kadhabaGardan = VerbGardan(
  root: 'ك ذ ب',
  name: 'كَذَّبَ (Jhutlana)',
  urduMeaning: 'Jhutlana / Takzeeb karna',
  baab: 'باب تفعیل (ثلاثی مزید فیہ)',
  madhi: [
    GardanEntry(arabic: 'كَذَّبَ', sigha: 'واحد مذکر غائب', urdu: 'Us ek ne jhutlaya', type: 'ghaib_m'),
    GardanEntry(arabic: 'كَذَّبَا', sigha: 'تثنیہ مذکر غائب', urdu: 'Un do ne jhutlaya', type: 'ghaib_m'),
    GardanEntry(arabic: 'كَذَّبُوا', sigha: 'جمع مذکر غائب', urdu: 'Un sab ne jhutlaya (Ayat 14: فَكَذَّبُوهُمَا)', type: 'ghaib_m'),
    GardanEntry(arabic: 'كَذَّبَتْ', sigha: 'واحد مؤنث غائب', urdu: 'Us ek aurat ne jhutlaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'كَذَّبَتَا', sigha: 'تثنیہ مؤنث غائب', urdu: 'Un do ne jhutlaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'كَذَّبْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Un sab auraton ne jhutlaya', type: 'ghaib_f'),
    GardanEntry(arabic: 'كَذَّبْتَ', sigha: 'واحد مذکر حاضر', urdu: 'Tu ne jhutlaya', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذَّبْتُمَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do ne jhutlaya', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذَّبْتُمْ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab ne jhutlaya', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذَّبْتِ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu ne jhutlaya (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'كَذَّبْتُمَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do ne jhutlaya', type: 'hazir_f'),
    GardanEntry(arabic: 'كَذَّبْتُنَّ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab ne jhutlaya', type: 'hazir_f'),
    GardanEntry(arabic: 'كَذَّبْتُ', sigha: 'واحد متکلم', urdu: 'Maine jhutlaya', type: 'mutakallim'),
    GardanEntry(arabic: 'كَذَّبْنَا', sigha: 'جمع متکلم', urdu: 'Hum sab ne jhutlaya', type: 'mutakallim'),
  ],
  mudare: [
    GardanEntry(arabic: 'يُكَذِّبُ', sigha: 'واحد مذکر غائب', urdu: 'Woh jhutlata hai ya jhutlayega', type: 'ghaib_m'),
    GardanEntry(arabic: 'يُكَذِّبَانِ', sigha: 'تثنیہ مذکر غائب', urdu: 'Woh do jhutlate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'يُكَذِّبُونَ', sigha: 'جمع مذکر غائب', urdu: 'Woh sab jhutlate hain', type: 'ghaib_m'),
    GardanEntry(arabic: 'تُكَذِّبُ', sigha: 'واحد مؤنث غائب', urdu: 'Woh ek aurat jhutlati hai', type: 'ghaib_f'),
    GardanEntry(arabic: 'تُكَذِّبَانِ', sigha: 'تثنیہ مؤنث غائب', urdu: 'Woh do jhutlati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'يُكَذِّبْنَ', sigha: 'جمع مؤنث غائب', urdu: 'Woh sab auratein jhutlati hain', type: 'ghaib_f'),
    GardanEntry(arabic: 'تُكَذِّبُ', sigha: 'واحد مذکر حاضر', urdu: 'Tu jhutlata hai', type: 'hazir_m'),
    GardanEntry(arabic: 'تُكَذِّبَانِ', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do jhutlate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تُكَذِّبُونَ', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab jhutlate ho', type: 'hazir_m'),
    GardanEntry(arabic: 'تُكَذِّبِينَ', sigha: 'واحد مؤنث حاضر', urdu: 'Tu jhutlati hai (aurat)', type: 'hazir_f'),
    GardanEntry(arabic: 'تُكَذِّبَانِ', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do jhutlati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'تُكَذِّبْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab jhutlati ho', type: 'hazir_f'),
    GardanEntry(arabic: 'أُكَذِّبُ', sigha: 'واحد متکلم', urdu: 'Main jhutlata hoon', type: 'mutakallim'),
    GardanEntry(arabic: 'نُكَذِّبُ', sigha: 'جمع متکلم', urdu: 'Hum sab jhutlate hain', type: 'mutakallim'),
  ],
  amr: [
    GardanEntry(arabic: 'كَذِّبْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu jhutla!', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذِّبَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do jhutlao!', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذِّبُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab jhutlao!', type: 'hazir_m'),
    GardanEntry(arabic: 'كَذِّبِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu jhutla (aurat)!', type: 'hazir_f'),
    GardanEntry(arabic: 'كَذِّبَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do jhutlao!', type: 'hazir_f'),
    GardanEntry(arabic: 'كَذِّبْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab jhutlao!', type: 'hazir_f'),
  ],
  nahi: [
    GardanEntry(arabic: 'لَا تُكَذِّبْ', sigha: 'واحد مذکر حاضر', urdu: 'Tu mat jhutla!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُكَذِّبَا', sigha: 'تثنیہ مذکر حاضر', urdu: 'Tum do mat jhutlao!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُكَذِّبُوا', sigha: 'جمع مذکر حاضر', urdu: 'Tum sab mat jhutlao!', type: 'hazir_m'),
    GardanEntry(arabic: 'لَا تُكَذِّبِي', sigha: 'واحد مؤنث حاضر', urdu: 'Tu mat jhutla!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تُكَذِّبَا', sigha: 'تثنیہ مؤنث حاضر', urdu: 'Tum do mat jhutlao!', type: 'hazir_f'),
    GardanEntry(arabic: 'لَا تُكَذِّبْنَ', sigha: 'جمع مؤنث حاضر', urdu: 'Tum sab mat jhutlao!', type: 'hazir_f'),
  ],
);

/// Tamam Gardans ki list
final List<VerbGardan> allGardans = [
  khalakaGardan,
  faalaGardan,
  qaalaGardan,
  jaalaGardan,
  alimaGardan,
  andharaGardan,
  kadhabaGardan,
];

/// Lafz ya Root se Gardan talash karna
VerbGardan? findGardanForWord(String arabic, String? root) {
  if (root != null) {
    final cleanRoot = root.replaceAll(' ', '').trim();
    for (final g in allGardans) {
      if (g.root.replaceAll(' ', '').trim() == cleanRoot) return g;
    }
  }
  // Check exact verb or common words
  if (arabic.contains('خَلَقَ') || arabic.contains('خَلَقْنَا') || arabic.contains('يَخْلُقُ')) {
    return khalakaGardan;
  }
  if (arabic.contains('قَالَ') || arabic.contains('قَالُوا') || arabic.contains('قُلْ') || arabic.contains('يَقُولُ')) {
    return qaalaGardan;
  }
  if (arabic.contains('جَعَلَ') || arabic.contains('جَعَلْنَا') || arabic.contains('يَجْعَلُ')) {
    return jaalaGardan;
  }
  if (arabic.contains('عَلِمَ') || arabic.contains('يَعْلَمُونَ') || arabic.contains('تَعْلَمُونَ')) {
    return alimaGardan;
  }
  if (arabic.contains('أَنذَرْتَ') || arabic.contains('تُنذِرْ') || arabic.contains('أَنذَرَ')) {
    return andharaGardan;
  }
  if (arabic.contains('كَذَّبَ') || arabic.contains('فَكَذَّبُوا')) {
    return kadhabaGardan;
  }
  // Return default standard Faala
  return null;
}
