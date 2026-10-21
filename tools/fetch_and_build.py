#!/usr/bin/env python3
import json
import os
import re
import urllib.request
import sqlite3

SURAH = 36
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SOURCE_DIR = os.path.join(BASE_DIR, "source")
os.makedirs(SOURCE_DIR, exist_ok=True)

CORPUS_URL = "https://raw.githubusercontent.com/bnjasim/quranic-corpus/master/quranic-corpus-morphology-0.4.txt"
ALQURAN_URL = "https://api.alquran.cloud/v1/surah/36/editions/quran-uthmani,ur.jalandhry"

headers = {"User-Agent": "Mozilla/5.0"}

def download_data():
    corpus_path = os.path.join(SOURCE_DIR, "corpus_36.txt")
    if not os.path.exists(corpus_path):
        print("Downloading Quranic Corpus morphology for Surah 36...")
        req = urllib.request.Request(CORPUS_URL, headers=headers)
        with urllib.request.urlopen(req) as resp, open(corpus_path, "w", encoding="utf-8") as out:
            for line in resp:
                text_line = line.decode("utf-8")
                if text_line.startswith(f"({SURAH}:"):
                    out.write(text_line)
        print("Corpus for Surah 36 saved.")

    tanzil_ar_path = os.path.join(SOURCE_DIR, "tanzil_ar.txt")
    tanzil_ur_path = os.path.join(SOURCE_DIR, "tanzil_ur.txt")
    if not os.path.exists(tanzil_ar_path) or not os.path.exists(tanzil_ur_path):
        print("Downloading Surah 36 Arabic and Urdu from Al-Quran Cloud...")
        req = urllib.request.Request(ALQURAN_URL, headers=headers)
        with urllib.request.urlopen(req) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        
        ar_ayahs = data["data"][0]["ayahs"]
        ur_ayahs = data["data"][1]["ayahs"]

        with open(tanzil_ar_path, "w", encoding="utf-8") as far:
            for a in ar_ayahs:
                # Remove bismillah prefix if attached to ayat 1 (except Fatiha)
                text = a["text"]
                if a["numberInSurah"] == 1 and text.startswith("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ "):
                    text = text.replace("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ", "")
                far.write(f"{SURAH}|{a['numberInSurah']}|{text}\n")

        with open(tanzil_ur_path, "w", encoding="utf-8") as fur:
            for a in ur_ayahs:
                fur.write(f"{SURAH}|{a['numberInSurah']}|{a['text']}\n")
        print("Arabic and Urdu text saved.")

    return tanzil_ar_path, tanzil_ur_path, corpus_path

if __name__ == "__main__":
    ar_file, ur_file, corp_file = download_data()
    print("Files ready:", ar_file, ur_file, corp_file)
