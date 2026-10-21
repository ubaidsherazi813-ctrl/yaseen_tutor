#!/usr/bin/env python3
"""
yaseen.db banane ki script (content database).

Do tareeqe:

1) SAMPLE (app foran chalane ke liye, sirf Ayat 1-4, demo grammar):
      python tools/build_database.py --sample

2) POORA DATA (83 ayaat):
      python tools/build_database.py --tanzil tools/source/quran-uthmani.txt \
                                     --urdu   tools/source/ur.jalandhry.txt \
                                     --corpus tools/source/quranic-corpus-morphology-0.4.txt

   Source files khud download karein (README dekhein):
     - Tanzil.net  -> Quran text (Uthmani, "Text (with aya numbers)" ya "pipe" format: sura|aya|text)
     - Tanzil.net  -> Urdu translation (jaise ur.jalandhry), format: sura|aya|text
     - corpus.quran.com/download -> morphology file (TAB-separated)

   Optional: --meanings meanings.csv  (columns: ayat,word,meaning)  word-by-word matlab ke liye.

Output: assets/data/yaseen.db  (phir assets/data mein hi rehne dein)

ZAROORI: Corpus ki tags ko app ki istilahat mein badalne ka mapping (neeche TAGS) ek koshish hai.
Is ko apne ustad se zaroor verify karwayein. Yeh script maine yahan se un websites tak pohanch kar
test nahi ki, isliye pehli baar chalane par output zaroor check karein (--check dekhein).
"""
import argparse
import csv
import os
import re
import sqlite3
import sys

SURAH = 36

SCHEMA = """
DROP TABLE IF EXISTS segments; DROP TABLE IF EXISTS words;
DROP TABLE IF EXISTS ayaat;    DROP TABLE IF EXISTS topics;
CREATE TABLE ayaat (id INTEGER PRIMARY KEY, arabic TEXT NOT NULL, urdu TEXT NOT NULL);
CREATE TABLE words (
  id INTEGER PRIMARY KEY AUTOINCREMENT, ayat_id INTEGER NOT NULL, position INTEGER NOT NULL,
  arabic TEXT NOT NULL, meaning TEXT, root TEXT, UNIQUE(ayat_id, position));
CREATE TABLE segments (
  id INTEGER PRIMARY KEY AUTOINCREMENT, word_id INTEGER NOT NULL, seg_order INTEGER NOT NULL,
  arabic TEXT NOT NULL, kind TEXT NOT NULL, is_stem INTEGER NOT NULL DEFAULT 0,
  label TEXT, tense TEXT, i3rab TEXT, mabni TEXT, gender TEXT, number TEXT,
  person TEXT, pron_type TEXT, note TEXT);
CREATE TABLE topics (
  id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT, start_ayat INTEGER, end_ayat INTEGER);
CREATE INDEX idx_words_ayat ON words(ayat_id);
CREATE INDEX idx_seg_word ON segments(word_id);
"""

# Mauzoobaat (taqreeban hadein; ustad se confirm karein)
TOPICS = [
    (1, "Risalat ki tasdeeq", "Quran ki qasam aur Nabi (SAW) ki risalat", 1, 12),
    (2, "Basti walon ka qissa", "Teen rasool aur ek nek aadmi ki himayat", 13, 32),
    (3, "Tauheed ki nishaniyan", "Zameen, raat-din, suraj-chaand, kashtiyan", 33, 44),
    (4, "Qayamat aur akhirat", "Dobara uthaye jane ka bayan", 48, 65),
    (5, "Shaitan ki dushmani", "Shaitan ki ibadat se mana", 60, 62),
    (6, "Dobara zinda karne ki daleel", "Allah ki qudrat ka saboot", 77, 83),
]

# ---------------- SAMPLE DATA ----------------
def seg(arabic, kind, stem, label, **kw):
    return dict(arabic=arabic, kind=kind, is_stem=1 if stem else 0, label=label, **kw)

SAMPLE = [
    (1, "يسٓ", "یٰسین (حروفِ مقطعات؛ ان کا حقیقی علم اللہ کو ہے) [sample tarjuma]", [
        ("يسٓ", "huroof-e-muqatta’at", None,
         [seg("يسٓ", "harf", True, "Huroof-e-Muqatta’at", mabni="Mabni")]),
    ]),
    (2, "وَٱلْقُرْءَانِ ٱلْحَكِيمِ", "قسم ہے حکمت والے قرآن کی [sample tarjuma]", [
        ("وَٱلْقُرْءَانِ", "qasam hai Quran ki", None,
         [seg("وَ", "harf", False, "Harf-e-Qasam", mabni="Mabni"),
          seg("ٱلْقُرْءَانِ", "ism", True, "Ism", i3rab="Majroor", mabni="Mu’rab", gender="Muzakkar", number="Wahid")]),
        ("ٱلْحَكِيمِ", "hikmat wala", None,
         [seg("ٱلْحَكِيمِ", "ism", True, "Ism (Sifat)", i3rab="Majroor", mabni="Mu’rab", gender="Muzakkar", number="Wahid")]),
    ]),
    (3, "إِنَّكَ لَمِنَ ٱلْمُرْسَلِينَ", "بے شک آپ رسولوں میں سے ہیں [sample tarjuma]", [
        ("إِنَّكَ", "beshak aap", None,
         [seg("إِنَّ", "harf", True, "Harf-e-Mushabbah bil Fe’l (Taakeed)", mabni="Mabni"),
          seg("كَ", "zameer", False, "Zameer", pron_type="Muttasil", gender="Muzakkar", number="Wahid", person="Hazir")]),
        ("لَمِنَ", "yaqeenan ... mein se", None,
         [seg("لَ", "harf", False, "Lam-e-Taakeed", mabni="Mabni"),
          seg("مِنَ", "harf", True, "Harf-e-Jar", mabni="Mabni")]),
        ("ٱلْمُرْسَلِينَ", "bheje hue (rasool)", "رسل",
         [seg("ٱلْمُرْسَلِينَ", "ism", True, "Ism (Ism-e-Maf’ool)", i3rab="Majroor", mabni="Mu’rab", gender="Muzakkar", number="Jama (Salim)")]),
    ]),
    (4, "عَلَىٰ صِرَٰطٍ مُّسْتَقِيمٍ", "سیدھے راستے پر [sample tarjuma]", [
        ("عَلَىٰ", "par", None,
         [seg("عَلَىٰ", "harf", True, "Harf-e-Jar", mabni="Mabni")]),
        ("صِرَٰطٍ", "raasta", "صرط",
         [seg("صِرَٰطٍ", "ism", True, "Ism", i3rab="Majroor", mabni="Mu’rab", gender="Muzakkar", number="Wahid")]),
        ("مُّسْتَقِيمٍ", "seedha", "قوم",
         [seg("مُّسْتَقِيمٍ", "ism", True, "Ism (Sifat)", i3rab="Majroor", mabni="Mu’rab", gender="Muzakkar", number="Wahid")]),
    ]),
]

# ---------------- CORPUS MAPPING ----------------
# tag -> (kind, label). Jo tag yahan nahi, woh "Harf" maana jata hai aur note mein tag likha jata hai.
TAGS = {
    "N": ("ism", "Ism"), "PN": ("ism", "Ism (Ism-e-Alam)"), "ADJ": ("ism", "Ism (Sifat)"),
    "IMPN": ("ism", "Ism-e-Fe’l (Amr)"), "PRON": ("zameer", "Zameer"),
    "DEM": ("ism", "Ism-e-Ishara"), "REL": ("ism", "Ism-e-Mausool"),
    "T": ("ism", "Zarf (Zamaan)"), "LOC": ("ism", "Zarf (Makaan)"),
    "V": ("fil", "Fe’l"),
    "P": ("harf", "Harf-e-Jar"), "CONJ": ("harf", "Harf-e-Atf"), "NEG": ("harf", "Harf-e-Nafi"),
    "INTG": ("harf", "Harf-e-Istifham"), "COND": ("harf", "Harf-e-Shart"), "VOC": ("harf", "Harf-e-Nida"),
    "INL": ("harf", "Huroof-e-Muqatta’at"), "CERT": ("harf", "Harf-e-Tahqeeq"),
    "ACC": ("harf", "Harf-e-Nasb"), "EMPH": ("harf", "Harf-e-Taakeed"), "FUT": ("harf", "Harf-e-Istiqbal"),
    "SUB": ("harf", "Harf-e-Rabt"), "RSLT": ("harf", "Harf-e-Jaza"), "REM": ("harf", "Harf-e-Isti’naf"),
}

BW = {
    "'": "ء", "|": "آ", ">": "أ", "&": "ؤ", "<": "إ", "}": "ئ", "A": "ا", "b": "ب", "p": "ة",
    "t": "ت", "v": "ث", "j": "ج", "H": "ح", "x": "خ", "d": "د", "*": "ذ", "r": "ر", "z": "ز",
    "s": "س", "$": "ش", "S": "ص", "D": "ض", "T": "ط", "Z": "ظ", "E": "ع", "g": "غ", "f": "ف",
    "q": "ق", "k": "ك", "l": "ل", "m": "م", "n": "ن", "h": "ه", "w": "و", "Y": "ى", "y": "ي",
    "F": "ً", "N": "ٌ", "K": "ٍ", "a": "َ", "u": "ُ", "i": "ِ", "~": "ّ", "o": "ْ", "`": "ٰ",
    "{": "ٱ", "^": "ٓ", "#": "ٔ", "_": "ـ",
}

def bw2ar(s):
    """Buckwalter -> Arabic (taqreeban; chhote farq ho sakte hain)."""
    return "".join(BW.get(ch, "") for ch in s)

GENDER = {"M": "Muzakkar", "F": "Muannas"}
NUMBER = {"S": "Wahid", "D": "Tasniya", "P": "Jama"}
PERSON = {"1": "Mutakallim", "2": "Hazir", "3": "Ghaib"}
PGN = re.compile(r"^([123])?([MF])?([SDP])?$")

def parse_segment(form, tag, feats):
    kind, label = TAGS.get(tag, ("harf", "Harf"))
    f = feats.split("|")
    is_stem = "STEM" in f
    d = dict(arabic=bw2ar(form), kind=kind, is_stem=1 if is_stem else 0, label=label,
             tense=None, i3rab=None, mabni=None, gender=None, number=None,
             person=None, pron_type=None, note=None)
    root = None
    for t in f:
        if t == "PERF": d["tense"] = "Madhi"
        elif t == "IMPF": d["tense"] = "Mudare’"
        elif t == "IMPV": d["tense"] = "Amr"
        elif t == "NOM": d["i3rab"] = "Marfu"
        elif t == "ACC": d["i3rab"] = "Mansub"
        elif t == "GEN": d["i3rab"] = "Majroor"
        elif t == "MOOD:SUBJ": d["i3rab"] = "Mansub"
        elif t == "MOOD:JUS": d["i3rab"] = "Majzoom"
        elif t.startswith("ROOT:"): root = " ".join(bw2ar(t[5:]))
        elif t.startswith("PRON:"):
            m = PGN.match(t[5:])
            d["pron_type"] = "Muttasil"
            if m: d["person"], d["gender"], d["number"] = (
                PERSON.get(m.group(1)), GENDER.get(m.group(2)), NUMBER.get(m.group(3)))
        elif t and PGN.fullmatch(t) and (any(c in t for c in "MF") or t in ("1S", "1P")):
            m = PGN.fullmatch(t)
            d["person"], d["gender"], d["number"] = (
                PERSON.get(m.group(1)), GENDER.get(m.group(2)), NUMBER.get(m.group(3)))
    if tag == "PRON" and is_stem: d["pron_type"] = "Munfasil"
    if tag == "V" and d["i3rab"] is None and d["tense"] == "Mudare’": d["i3rab"] = "Marfu"
    if kind == "harf" or d["tense"] in ("Madhi", "Amr") or tag in ("PRON", "DEM", "REL"):
        d["mabni"] = "Mabni"
    elif kind == "ism" or d["tense"]:
        d["mabni"] = "Mu’rab"
    if tag not in TAGS: d["note"] = "Corpus tag: " + tag
    return d, root

def read_pipe(path):
    out = {}
    with open(path, encoding="utf-8") as fh:
        for line in fh:
            line = line.rstrip("\n")
            if not line or line.startswith("#"): continue
            parts = line.split("|", 2)
            if len(parts) == 3 and parts[0].isdigit() and int(parts[0]) == SURAH:
                out[int(parts[1])] = parts[2].strip()
    return out

def is_mark(tok):
    return all(0x06D6 <= ord(c) <= 0x06DC or ord(c) in (0x06DE, 0x06E9) for c in tok)

def split_words(text):
    words = []
    for tok in text.split():
        if words and is_mark(tok): words[-1] += tok
        else: words.append(tok)
    return words

def write_db(out, ayaat_rows, topics):
    os.makedirs(os.path.dirname(out), exist_ok=True)
    if os.path.exists(out): os.remove(out)
    db = sqlite3.connect(out)
    db.executescript(SCHEMA)
    for aid, ar, ur, words in ayaat_rows:
        db.execute("INSERT INTO ayaat VALUES (?,?,?)", (aid, ar, ur))
        for pos, (warabic, meaning, root, segs) in enumerate(words, 1):
            cur = db.execute("INSERT INTO words(ayat_id,position,arabic,meaning,root) VALUES (?,?,?,?,?)",
                             (aid, pos, warabic, meaning, root))
            for order, s in enumerate(segs, 1):
                db.execute("""INSERT INTO segments(word_id,seg_order,arabic,kind,is_stem,label,tense,i3rab,
                              mabni,gender,number,person,pron_type,note) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                           (cur.lastrowid, order, s["arabic"], s["kind"], s["is_stem"], s.get("label"),
                            s.get("tense"), s.get("i3rab"), s.get("mabni"), s.get("gender"), s.get("number"),
                            s.get("person"), s.get("pron_type"), s.get("note")))
    db.executemany("INSERT INTO topics VALUES (?,?,?,?,?)", topics)
    db.commit()
    check(db)
    db.close()
    print("Bana diya:", out)

def check(db):
    n = db.execute("SELECT COUNT(*) FROM ayaat").fetchone()[0]
    w = db.execute("SELECT COUNT(*) FROM words").fetchone()[0]
    s = db.execute("SELECT COUNT(*) FROM segments").fetchone()[0]
    empty = db.execute("SELECT a.id FROM ayaat a LEFT JOIN words w ON w.ayat_id=a.id GROUP BY a.id HAVING COUNT(w.id)=0").fetchall()
    print(f"Ayaat: {n}   Words: {w}   Segments: {s}")
    if empty: print("WARNING: in ayaat ke words nahi hain:", [e[0] for e in empty])

def build_full(args):
    arabic = read_pipe(args.tanzil)
    urdu = read_pipe(args.urdu)
    meanings = {}
    if args.meanings:
        with open(args.meanings, encoding="utf-8") as fh:
            for r in csv.DictReader(fh): meanings[(int(r["ayat"]), int(r["word"]))] = r["meaning"]

    corpus = {}
    rx = re.compile(r"^\((\d+):(\d+):(\d+):(\d+)\)\t(\S+)\t(\S+)\t(.*)$")
    with open(args.corpus, encoding="utf-8") as fh:
        for line in fh:
            m = rx.match(line.rstrip("\n"))
            if not m or int(m.group(1)) != SURAH: continue
            v, w = int(m.group(2)), int(m.group(3))
            corpus.setdefault(v, {}).setdefault(w, []).append((m.group(5), m.group(6), m.group(7)))

    rows = []
    for aid in sorted(arabic):
        words_ar = split_words(arabic[aid])
        cw = corpus.get(aid, {})
        if len(words_ar) != len(cw):
            print(f"WARNING ayat {aid}: Tanzil words={len(words_ar)} Corpus words={len(cw)} (manually check karein)")
        words = []
        for i, wtext in enumerate(words_ar, 1):
            segs, root = [], None
            for (form, tag, feats) in cw.get(i, []):
                d, r = parse_segment(form, tag, feats)
                segs.append(d); root = root or r
            words.append((wtext, meanings.get((aid, i)), root, segs))
        rows.append((aid, arabic[aid], urdu.get(aid, ""), words))
    write_db(args.out, rows, TOPICS)

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sample", action="store_true")
    ap.add_argument("--tanzil"); ap.add_argument("--urdu"); ap.add_argument("--corpus")
    ap.add_argument("--meanings")
    ap.add_argument("--out", default=os.path.join(os.path.dirname(__file__), "..", "assets", "data", "yaseen.db"))
    a = ap.parse_args()
    if a.sample:
        write_db(a.out, [(i, ar, ur, [(w, m, r, s) for (w, m, r, s) in words]) for (i, ar, ur, words) in SAMPLE], TOPICS)
    elif a.tanzil and a.urdu and a.corpus:
        build_full(a)
    else:
        ap.print_help(); sys.exit(1)

if __name__ == "__main__":
    main()
