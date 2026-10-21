import 'package:flutter/material.dart';
import '../core/labels.dart';
import '../core/theme.dart';
import '../widgets/common.dart';

class _Item {
  final String title, kind, body;
  const _Item(this.title, this.kind, this.body);
}

const _items = [
  _Item('Ism (اسم)', 'ism',
      'Kisi shakhs, jagah, cheez ya sifat ka naam, jo zamane ke baghair matlab de.\n\n'
      'Ism ki 3 halatein hoti hain:\n'
      '• Marfu: aakhir par damma (ُ ٌ), jaise fa’il ya mubtada\n'
      '• Mansub: aakhir par fatha (َ ً), jaise maf’ool\n'
      '• Majroor: aakhir par kasra (ِ ٍ), jaise harf-e-jar ya mudaf ilayh ke baad'),
  _Item('Fe’l (فعل)', 'fil',
      'Aisa lafz jis mein kaam aur zamana dono hon.\n\n'
      '• Madhi: guzra hua zamana\n'
      '• Mudare’: maujooda ya aane wala zamana\n'
      '• Amr: hukm dena\n'
      '• Nahi: kisi kaam se mana karna (jaise لَا تَفْعَلْ)'),
  _Item('Harf (حرف)', 'harf',
      'Aisa lafz jo akela poora matlab nahi deta, ism ya fe’l ke saath mil kar matlab deta hai.\n\n'
      'Aqsam (misalein):\n'
      '• Harf-e-Jar: مِنْ، إِلَى، فِي، بِ، لِ، عَلَى\n'
      '• Harf-e-Nida: يَا\n'
      '• Harf-e-Atf: وَ، فَ، ثُمَّ\n'
      '• Harf-e-Nafi: لَا، مَا، لَمْ، لَنْ\n'
      '• Harf-e-Istifham: هَلْ، أَ\n'
      '• Harf-e-Shart: إِنْ، لَوْ\n'
      '• Harf-e-Tahqeeq/Taakeed: إِنَّ، قَدْ، لَ'),
  _Item('Zameer (ضمیر)', 'zameer',
      'Zameer wo lafz hai jo kisi ism ki jagah aata hai (woh, aap, mein, hum...).\n\n'
      '• Muttasil: kisi lafz se juda hua, jaise كَ، هُ، هَا، هُمْ، نَا\n'
      '• Munfasil: alag lafz ki shakal mein, jaise هُوَ، أَنْتَ، أَنَا، نَحْنُ'),
  _Item('Mabni aur Mu’rab', 'ism',
      '• Mabni: jis lafz ki aakhri harkat/halat jumle ke mutabiq nahi badalti (zyada tar harf, fe’l madhi, amr, zameer).\n'
      '• Mu’rab: jis ki aakhri harkat jumle mein kirdar ke mutabiq badalti hai (zyada tar ism).'),
  _Item('Jins aur Adad', 'ism',
      '• Jins: Muzakkar (mard) ya Muannas (aurat)\n'
      '• Adad: Wahid (ek), Tasniya (do), Jama (do se zyada)\n'
      '• Purush: Ghaib (woh), Hazir (tum), Mutakallim (mein/hum)'),
  _Item('Huroof-e-Muqatta’at', 'harf',
      'Kuch suratein alag alag huroof se shuru hoti hain, jaise Yaseen ki “يس”. '
      'In ka haqeeqi ilm Allah ko hai (aam taur par ulama ka yahi mauqif hai).'),
];

class GrammarGuideScreen extends StatelessWidget {
  const GrammarGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    return Column(
      children: [
        const GradientHeader(title: 'Grammar Guide', subtitle: 'Arabic nahw ki buniyadi istilahat'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              for (final it in _items)
                AppCard(
                  padding: EdgeInsets.zero,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(it.title,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: kindColor(it.kind))),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(it.body, style: TextStyle(height: 1.6, color: p.text))],
                    ),
                  ),
                ),
              Text('Note: yeh buniyadi wazahat hai. Tafseeli grammar apne ustad se bhi confirm karein.',
                  style: TextStyle(fontSize: 11, color: p.text2)),
            ],
          ),
        ),
      ],
    );
  }
}
