import 'package:flutter/material.dart';
import '../core/gardan_data.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../widgets/common.dart';
import '../widgets/gardan_modal.dart';

class GrammarTopic {
  final String title;
  final String category; // 'buniyadi', 'irab', 'zameer', 'huroof', 'murakkab', 'gardan'
  final String kind; // 'ism', 'fil', 'harf', 'zameer'
  final String shortDesc;
  final String detail;
  final String quranExample;

  const GrammarTopic({
    required this.title,
    required this.category,
    required this.kind,
    required this.shortDesc,
    required this.detail,
    required this.quranExample,
  });
}

final List<GrammarTopic> allGrammarTopics = [
  // --- 14 Sighon ki Gardan ---
  const GrammarTopic(
    title: '14 Sighon ki Gardan (فعل کی 14 گردانیں)',
    category: 'gardan',
    kind: 'fil',
    shortDesc: 'عربی میں ہر فعل (Verb) کی 14 شکلیں ہوتی ہیں: 6 غائب، 6 حاضر، 2 متکلم۔',
    detail: 'عربی صرف (Sarf) میں جب بھی کوئی فعل گردانا جاتا ہے تو فاعل (فاعل کے مذکر/مؤنث اور واحد/تثنیہ/جمع) کے اعتبار سے 14 صیغے بنتے ہیں:\n\n'
        '1. واحد مذکر غائب (هُوَ - جیسے خَلَقَ: اس ایک مرد نے بنایا)\n'
        '2. تثنیہ مذکر غائب (هُمَا - خَلَقَا: ان دو مردوں نے بنایا)\n'
        '3. جمع مذکر غائب (هُمْ - خَلَقُوا: ان سب مردوں نے بنایا)\n'
        '4. واحد مؤنث غائب (هِيَ - خَلَقَتْ: اس ایک عورت نے بنایا)\n'
        '5. تثنیہ مؤنث غائب (هُمَا - خَلَقَتَا: ان دو عورتوں نے بنایا)\n'
        '6. جمع مؤنث غائب (هُنَّ - خَلَقْنَ: ان سب عورتوں نے بنایا)\n'
        '7. واحد مذکر حاضر (أَنْتَ - خَلَقْتَ: تو نے بنایا)\n'
        '8. تثنیہ مذکر حاضر (أَنْتُمَا - خَلَقْتُمَا: تم دو نے بنایا)\n'
        '9. جمع مذکر حاضر (أَنْتُمْ - خَلَقْتُمْ: تم سب نے بنایا)\n'
        '10. واحد مؤنث حاضر (أَنْتِ - خَلَقْتِ: تو نے بنایا)\n'
        '11. تثنیہ مؤنث حاضر (أَنْتُمَا - خَلَقْتُمَا: تم دو نے بنایا)\n'
        '12. جمع مؤنث حاضر (أَنْتُنَّ - خَلَقْتُنَّ: تم سب نے بنایا)\n'
        '13. واحد متکلم (أَنَا - خَلَقْتُ: میں نے بنایا)\n'
        '14. جمع متکلم (نَحْنُ - خَلَقْنَا: ہم سب نے بنایا)',
    quranExample: 'سورة يس، آیت 9: "وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا" (جَعَلْنَا = جمع متکلم)',
  ),

  // --- Kalimah & Buniyadi ---
  const GrammarTopic(
    title: 'Ism (اسم - Noun/Adjective)',
    category: 'buniyadi',
    kind: 'ism',
    shortDesc: 'کسی شخص، جگہ، چیز، کام یا صفت کا نام جو زمانے کے بغیر مکمل معنی دے۔',
    detail: 'اسم کی نشانیاں:\n'
        '• شروع میں الف لام (الـ) آنا، جیسے: اَلْقُرْآنُ، اَلْحَكِيمُ\n'
        '• آخر پر تنوین (ً ٍ ٌ) آنا، جیسے: صِرَاطٍ، مُسْتَقِيمٍ\n'
        '• اس سے پہلے حرفِ جر آنا، جیسے: عَلَى صِرَاطٍ\n'
        '• گول تاء (ة) کا ہونا، جیسے: رَحْمَةٌ، آيَةٌ\n\n'
        'اسم کی اعرابی حالتیں 3 ہوتی ہیں: مرفوع (Pesh)، منصوب (Zabar)، مجرور (Zer)۔',
    quranExample: 'سورة يس، آیت 2: "وَٱلْقُرْءَانِ ٱلْحَكِيمِ" (القرآن اور الحکیم دونوں اسم ہیں)',
  ),

  const GrammarTopic(
    title: 'Fe’l (فعل - Verb)',
    category: 'buniyadi',
    kind: 'fil',
    shortDesc: 'ایسا کلمہ جس میں کسی کام کا کرنا یا ہونا کسی زمانے (ماضی، حال، مستقبل) کے ساتھ پایا جائے۔',
    detail: 'فعل کی بنیادی اقسام:\n'
        '1. فعل ماضی (Past Tense): جو کام گزرے ہوئے زمانے میں ہوا، جیسے: خَلَقَ (اس نے پیدا کیا)، قَالَ (اس نے کہا)۔\n'
        '2. فعل مضارع (Present/Future): جو کام موجودہ یا آنے والے زمانے میں ہو، جیسے: يَخْلُقُ (وہ پیدا کرتا ہے یا کرے گا)، يَعْلَمُونَ (وہ جانتے ہیں)۔\n'
        '3. فعل امر (Imperative): کسی کام کا حکم دینا، جیسے: قُلْ (کہہ دیجیے!)، اِعْلَمْ (جان لو!)۔\n'
        '4. فعل نہی (Prohibition): کسی کام سے روکنا، جیسے: لَا تَفْعَلْ (مت کر!)۔',
    quranExample: 'سورة يس، آیت 77: "أَوَلَمْ يَرَ ٱلْإِنسَٰنُ أَنَّا خَلَقْنَٰهُ" (خَلَقْنَا = فعل ماضی)',
  ),

  const GrammarTopic(
    title: 'Harf (حرف - Particle)',
    category: 'buniyadi',
    kind: 'harf',
    shortDesc: 'ایسا لفظ جو اکیلا اپنا پورا مفہوم ظاہر نہ کر سکے بلکہ اسم یا فعل کے ساتھ مل کر معنی دے۔',
    detail: 'حرف کا اپنا کوئی آزادانہ زمانہ نہیں ہوتا۔ یہ جملے کے اجزاء کو آپس میں جوڑتا ہے۔\n'
        'عربی میں حروف کی متعدد اقسام ہیں جیسے حروفِ جارہ (مِنْ، إِلَى)، حروفِ عاطفہ (وَ، فَ)، حروفِ نداء (يَا)، حروفِ نفی (لَا، مَا)، اور حروفِ مشبہ بالفعل (إِنَّ، أَنَّ)۔ تمام حروف مبنی (Mabni) ہوتے ہیں۔',
    quranExample: 'سورة يس، آیت 4: "عَلَىٰ صِرَٰطٍ مُّسْتَقِيمٍ" (عَلَى = حرفِ جر)',
  ),

  // --- I'rab (Marfu, Mansub, Majroor) ---
  const GrammarTopic(
    title: 'Marfu’ (مرفوع - Nominative Case)',
    category: 'irab',
    kind: 'ism',
    shortDesc: 'وہ اسم جس پر پیش (ضمہ) یا اس کا نائب (واؤ، الف) ہو۔',
    detail: 'اہم مرفوعات:\n'
        '1. الفاعل (Fa’il - کام کرنے والا): جیسے جَاءَ رَجُلٌ (آدمی آیا)۔ فاعل ہمیشہ مرفوع ہوتا ہے!\n'
        '2. نائب الفاعل (Passive Subject): فعل مجہول کے بعد آنے والا اسم۔\n'
        '3. المبتدأ (Mubtada): جملہ اسمیہ کا پہلا حصہ۔\n'
        '4. الخبر (Khabar): جملہ اسمیہ کا دوسرا حصہ جو مبتدا کی خبر دیتا ہے۔\n'
        'علامتِ رفع: مفرد میں ضمہ (پیش ُ ٌ)، تثنیہ میں الف (انِ)، اور جمع مذکر سالم میں واؤ (ونَ)۔',
    quranExample: 'سورة يس، آیت 20: "وَجَاءَ مِنْ أَقْصَا الْمَدِينَةِ رَجُلٌ" (رَجُلٌ مرفوع ہے کیونکہ یہ فاعل ہے)',
  ),

  const GrammarTopic(
    title: 'Mansoob (منصوب - Accusative Case)',
    category: 'irab',
    kind: 'ism',
    shortDesc: 'وہ اسم جس پر زبر (فتحہ) یا اس کا نائب (الف، یاء) ہو۔ مفعول ہمیشہ منصوب ہوتا ہے۔',
    detail: 'اہم منصوبات (12 اقسام):\n'
        '1. مفعول بہ (Direct Object): جس پر کام واقع ہو، جیسے: خَلَقَ اللّٰهُ الْإِنْسَانَ (اللہ نے انسان کو پیدا کیا - الإنسان منصوب ہے)۔\n'
        '2. مفعول مطلق (Cognate Accusative): تاکید کے لیے فعل کا مصدر آنا۔\n'
        '3. مفعول فیہ / ظرف (Adverb of Time/Place): وقت یا جگہ بتانے والا اسم۔\n'
        '4. حال (Circumstantial state): فاعل یا مفعول کی حالت بتانے والا لفظ۔\n'
        '5. إنَّ کا اسم: إنَّ کے بعد آنے والا اسم منصوب ہو جاتا ہے۔\n'
        'علامتِ نصب: مفرد میں فتحہ (زبر َ ً)، تثنیہ اور جمع میں یاء (يْنِ / يْنَ)۔',
    quranExample: 'سورة يس، آیت 9: "وَجَعَلْنَا مِن بَيْنِ أَيْدِيهِمْ سَدًّا" (سَدًّا مفعول بہ ہونے کی وجہ سے منصوب ہے)',
  ),

  const GrammarTopic(
    title: 'Majroor (مجرور - Genitive Case)',
    category: 'irab',
    kind: 'ism',
    shortDesc: 'وہ اسم جس کے نیچے زیر (کسرہ) یا اس کا نائب (یاء) ہو۔',
    detail: 'اسم صرف دو حالتوں میں مجرور ہوتا ہے:\n\n'
        '1. جب اس سے پہلے کوئی حرفِ جر آئے (مجرور بحرفِ جر):\n'
        'جیسے: فِي كِتَابٍ، عَلَى صِرَاطٍ، بِسْمِ اللّٰهِ\n\n'
        '2. جب وہ مضاف الیہ (Mudaf Ilayh) بنے (مجرور بالإضافة):\n'
        'جیسے: قَلْبُ الْقُرْآنِ (قرآن کا دل - القرآنِ مجرور ہے کیونکہ مضاف الیہ ہے)۔\n\n'
        'علامتِ جر: مفرد میں کسرہ (زیر ِ ٍ)، تثنیہ و جمع مذکر سالم میں یاء ماقبل مفتوح/مکسور۔',
    quranExample: 'سورة يس، آیت 4: "عَلَىٰ صِرَٰطٍ مُّسْتَقِيمٍ" (صِرَاطٍ حرفِ جر "عَلَى" کی وجہ سے مجرور ہے)',
  ),

  // --- Zama'ir (Muttasil vs Munfasil) ---
  const GrammarTopic(
    title: 'Zameer Munfasil (ضمیر منفصل - Detached Pronoun)',
    category: 'zameer',
    kind: 'zameer',
    shortDesc: 'وہ ضمیر جو اکیلی الگ لفظ کے طور پر لکھی اور پڑھی جائے (کل 14 ضمائر)۔',
    detail: 'ضمائر منفصلہ مرفوعہ (14 الفاظ):\n'
        '• غائب مذکر: هُوَ (وہ ایک)، هُمَا (وہ دو)، هُمْ (وہ سب)\n'
        '• غائب مؤنث: هِيَ (وہ ایک عورت)، هُمَا (وہ دو عورتیں)، هُنَّ (وہ سب عورتیں)\n'
        '• حاضر مذکر: أَنْتَ (تو ایک مرد)، أَنْتُمَا (تم دو مرد)، أَنْتُمْ (تم سب مرد)\n'
        '• حاضر مؤنث: أَنْتِ (تو ایک عورت)، أَنْتُمَا (تم دو عورتیں)، أَنْتُنَّ (تم سب عورتیں)\n'
        '• متکلم: أَنَا (میں)، نَحْنُ (ہم سب)',
    quranExample: 'سورة يس، آیت 69: "إِنْ هُوَ إِلَّا ذِكْرٌ وَقُرْآنٌ مُّبِينٌ" (هُوَ = ضمیر منفصل واحد مذکر غائب)',
  ),

  const GrammarTopic(
    title: 'Zameer Muttasil (ضمیر متصل - Attached Pronoun)',
    category: 'zameer',
    kind: 'zameer',
    shortDesc: 'وہ ضمیر جو کسی اسم، فعل یا حرف کے آخر میں جڑ کر آئے۔',
    detail: 'جیسے: كَ (تیرا/تجھ کو)، هُ (اس کا/اس کو)، هَا (اس عورت کا)، نَا (ہمارا/ہم کو)، ي (میرا/مجھ کو)۔\n\n'
        '• اگر اسم کے ساتھ جڑے تو مضاف الیہ بنتی ہے (جیسے: كِتَابُكَ = تیری کتاب)۔\n'
        '• اگر فعل کے ساتھ جڑے تو مفعول بہ بنتی ہے (جیسے: خَلَقْنَاهُ = ہم نے اسے بنایا)۔\n'
        '• اگر حرفِ جر کے ساتھ جڑے تو مجرور بنتی ہے (جیسے: لَكَ = تیرے لیے، فِيهِ = اس میں)۔',
    quranExample: 'سورة يس، آیت 3: "إِنَّكَ لَمِنَ ٱلْمُرْسَلِينَ" (كَ = ضمیر متصل حاضر)',
  ),

  // --- Huroof ki Aqsam ---
  const GrammarTopic(
    title: 'Huroof-e-Jarah (حروفِ جارہ - Prepositions)',
    category: 'huroof',
    kind: 'harf',
    shortDesc: 'وہ حروف جو اپنے بعد آنے والے اسم کو زیر (کسرہ / حالتِ جر) دیتے ہیں۔',
    detail: 'مشهور 17 حروفِ جارہ کا شعر:\n'
        'با، تا، کاف، لام، واؤ، منذ، مذ، خلا\n'
        'رب، حاشا، من، عدا، فی، عن، علی، حتی، الی\n\n'
        'قرآن میں کثرت سے مستعمل:\n'
        '• مِنْ (سے): مِنْ دُونِ اللّٰهِ\n'
        '• إِلَى (کی طرف): إِلَى صِرَاطٍ\n'
        '• فِي (میں): فِي ضَلَالٍ\n'
        '• عَلَى (پر): عَلَى صِرَاطٍ\n'
        '• بِـ (ساتھ/سے): بِإِمَامٍ مُبِينٍ\n'
        '• لِـ (کے لیے): لِلْمُتَّقِينَ\n'
        '• وَ (قسمیہ): وَالْقُرْآنِ الْحَكِيمِ',
    quranExample: 'سورة يس، آیت 2: "وَٱلْقُرْءَانِ ٱلْحَكِيمِ" (واؤ قسمیہ حرفِ جر ہے، اس لیے القرآنِ مجرور ہے)',
  ),

  const GrammarTopic(
    title: 'Huroof-e-Mushabbah bil-Fe’l (حروفِ مشبہ بالفعل)',
    category: 'huroof',
    kind: 'harf',
    shortDesc: 'وہ 6 حروف جو جملہ اسمیہ پر داخل ہو کر مبتدا کو زبر (نصب) اور خبر کو پیش (رفع) دیتے ہیں۔',
    detail: 'یہ 6 حروف ہیں:\n'
        '1. إِنَّ (بیشک - تاکید کے لیے)\n'
        '2. أَنَّ (کہ - وضاحت کے لیے)\n'
        '3. كَأَنَّ (گویا کہ - تشبیہ کے لیے)\n'
        '4. لَكِنَّ (لیکن - استدراک کے لیے)\n'
        '5. لَيْتَ (کاش - تمنا کے لیے)\n'
        '6. لَعَلَّ (شاید / تاکہ - امید کے لیے)',
    quranExample: 'سورة يس، آیت 3: "إِنَّكَ لَمِنَ ٱلْمُرْسَلِينَ" (إِنَّ حرفِ مشبہ بالفعل ہے، كَ اس کا اسم ہے)',
  ),

  // --- Murakkabat ---
  const GrammarTopic(
    title: 'Murakkab-e-Tauseefi (مرکب توصیفی - Descriptive)',
    category: 'murakkab',
    kind: 'ism',
    shortDesc: 'موصوف اور صفت کا مجموعہ جس میں دوسرا اسم پہلے اسم کی اچھائی یا برائی بیان کرے۔',
    detail: 'قاعدہ: صفت اپنے موصوف کے 4 امور میں 100% تابع ہوتی ہے:\n'
        '1. اعراب میں (دونوں مرفوع، یا دونوں منصوب، یا دونوں مجرور)\n'
        '2. جنس میں (دونوں مذکر یا دونوں مؤنث)\n'
        '3. عدد میں (دونوں واحد، تثنیہ یا جمع)\n'
        '4. وسعت میں (دونوں معرفہ یا دونوں نکرہ)',
    quranExample: 'سورة يس، آیت 4: "صِرَٰطٍ مُّسْتَقِيمٍ" (صِرَاطٍ موصوف ہے اور مُسْتَقِيمٍ اس کی صفت ہے)',
  ),

  const GrammarTopic(
    title: 'Murakkab-e-Izafi (مرکب اضافی - Possessive)',
    category: 'murakkab',
    kind: 'ism',
    shortDesc: 'مضاف اور مضاف الیہ کا مرکب، جس میں ایک اسم کی نسبت دوسرے اسم کی طرف کی جائے (کا، کی، کے)۔',
    detail: 'قواعد:\n'
        '• مضاف (پہلا اسم): اس پر نہ تو الف لام (الـ) آتا ہے اور نہ تنوین۔\n'
        '• مضاف الیہ (دوسرا اسم): یہ ہمیشہ مجرور (Zer والا) ہوتا ہے!\n'
        'جیسے: رَسُولُ اللّٰهِ (اللہ کا رسول)، قَلْبُ الْقُرْآنِ (قرآن کا دل)۔',
    quranExample: 'سورة يس، آیت 38: "تَقْدِيرُ ٱلْعَزِيزِ ٱلْعَلِيمِ" (تَقْدِيرُ مضاف ہے اور ٱلْعَزِيزِ مضاف الیہ مجرور ہے)',
  ),

  const GrammarTopic(
    title: 'Mabni aur Mu’rab (مبنی اور معرب)',
    category: 'irab',
    kind: 'ism',
    shortDesc: 'مبنی وہ ہے جس کا آخری اعراب کبھی نہ بدلے، اور معرب وہ ہے جس کا اعراب عامل کے مطابق بدلے۔',
    detail: '• مبنی (Mabni): وہ کلمات جن پر عوامل کا اثر ہونے کے باوجود ان کی ظاہری شکل نہیں بدلتی۔ تمام حروف، فعل ماضی، فعل امر، ضمائر اور اسمائے اشارہ مبنی ہوتے ہیں۔\n'
        '• معرب (Mu’rab): وہ کلمات جن کی آخری حرکت حالتِ رفع میں پیش، حالتِ نصب میں زبر اور حالتِ جر میں زیر میں تبدیل ہو سکتی ہے۔ عربی کے اکثر اسماء اور فعل مضارع معرب ہوتے ہیں۔',
    quranExample: 'سورة يس، آیت 1: "يس" (حروفِ مقطعات مبنی ہیں)',
  ),
];

class GrammarGuideScreen extends StatefulWidget {
  const GrammarGuideScreen({super.key});

  @override
  State<GrammarGuideScreen> createState() => _GrammarGuideScreenState();
}

class _GrammarGuideScreenState extends State<GrammarGuideScreen> {
  String _selectedCat = 'all';
  String _searchQuery = '';

  final Map<String, String> _categories = {
    'all': 'تمام (All)',
    'gardan': 'گردان (Sarf)',
    'buniyadi': 'اسم، فعل، حرف',
    'irab': 'اعراب (مرفوع/منصوب/مجرور)',
    'zameer': 'ضمائر (Pronouns)',
    'huroof': 'حروف کی اقسام',
    'murakkab': 'مرکبات (Compounds)',
  };

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);

    final filtered = allGrammarTopics.where((t) {
      if (_selectedCat != 'all' && t.category != _selectedCat) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return t.title.toLowerCase().contains(q) ||
            t.shortDesc.toLowerCase().contains(q) ||
            t.detail.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Column(
      children: [
        const GradientHeader(
          title: 'Complete Grammar Guide',
          subtitle: 'عربی نحو، صرف، اعراب اور 14 صیغوں کی گردان',
        ),

        // Prominent Gardan Explorer Button
        Container(
          margin: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: InkWell(
            onTap: () => showGardanModal(context, initialGardan: khalakaGardan),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B6E4F), Color(0xFF1E9E5A)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0B6E4F).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.table_chart_rounded, color: Color(0xFFE0B84A), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '📖 14 Sighon ki Gardan (Sarf Explorer)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'خَلَقَ، قَالَ، جَعَلَ، عَلِمَ وغیرہ کی ماضی، مضارع، امر گردانیں',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
                ],
              ),
            ),
          ),
        ),

        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Grammar istilah talash karein (e.g. majroor, zameer, gardan)...',
              hintStyle: TextStyle(fontSize: 12, color: p.text2),
              prefixIcon: Icon(Icons.search, size: 20, color: p.primary),
              filled: true,
              fillColor: p.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: p.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: p.divider),
              ),
            ),
          ),
        ),

        // Category Filter Chips
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            children: _categories.entries.map((e) {
              final active = _selectedCat == e.key;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(e.value, style: TextStyle(fontSize: 11, color: active ? Colors.white : p.text)),
                  selected: active,
                  onSelected: (_) => setState(() => _selectedCat = e.key),
                  selectedColor: p.primary,
                  backgroundColor: p.surface,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: active ? p.primary : p.divider),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 6),

        // Topics List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    'Koi topic nahi mila',
                    style: TextStyle(color: p.text2),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) {
                    final t = filtered[i];
                    final color = kindColor(t.kind);
                    final isGardan = t.category == 'gardan';

                    return AppCard(
                      padding: EdgeInsets.zero,
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          leading: Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isGardan ? Icons.menu_book_rounded : Icons.school_outlined,
                              color: color,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            t.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: color,
                            ),
                          ),
                          subtitle: Text(
                            t.shortDesc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: p.text2),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(height: 1),
                            const SizedBox(height: 10),
                            Text(
                              t.detail,
                              style: TextStyle(height: 1.6, color: p.text, fontSize: 13),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: p.bg,
                                borderRadius: BorderRadius.circular(8),
                                border: Border(left: BorderSide(color: p.gold, width: 4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.auto_stories, size: 14, color: p.gold),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Surah Yaseen se Misal:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                          color: p.gold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t.quranExample,
                                    style: TextStyle(fontSize: 12, color: p.text),
                                  ),
                                ],
                              ),
                            ),
                            if (isGardan) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(Icons.table_chart, size: 18),
                                  label: const Text('14 Sighon ki Mukammal Table Kholen'),
                                  onPressed: () => showGardanModal(context, initialGardan: khalakaGardan),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
