#!/usr/bin/env python3
"""
Surah Yaseen ki 83 ayaat ki audio EveryAyah.com se download karke
assets/audio/ayat_001.mp3 ... ayat_083.mp3 ke naam se save karti hai.

Chalane ka tareeqa (apne laptop par, internet ke saath):
    python tools/download_audio.py --folder Alafasy_128kbps
    python tools/download_audio.py --folder Alafasy_128kbps --compress     (ffmpeg ho to size chhota)

--folder: qaari ka folder naam. EveryAyah.com ki recitation list mein dekh kar likhein
          (jaise Alafasy_128kbps, Husary_128kbps, Abdul_Basit_Murattal_192kbps).
Zaroori: website ke terms of use parh lein, aur app ke About mein qaari ka naam likhein.
Agar download na ho to files browser se bhi download karke yahi naam rakh sakte hain.
"""
import argparse
import os
import shutil
import subprocess
import urllib.request

ap = argparse.ArgumentParser()
ap.add_argument("--folder", required=True)
ap.add_argument("--count", type=int, default=83)
ap.add_argument("--compress", action="store_true")
a = ap.parse_args()

out_dir = os.path.join(os.path.dirname(__file__), "..", "assets", "audio")
os.makedirs(out_dir, exist_ok=True)

for n in range(1, a.count + 1):
    url = f"https://everyayah.com/data/{a.folder}/036{n:03d}.mp3"
    dest = os.path.join(out_dir, f"ayat_{n:03d}.mp3")
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=60) as r, open(dest, "wb") as f:
            f.write(r.read())
        if a.compress and shutil.which("ffmpeg"):
            tmp = dest + ".tmp.mp3"
            subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", dest,
                            "-b:a", "64k", "-ac", "1", tmp], check=True)
            os.replace(tmp, dest)
        print("ok  ", n)
    except Exception as e:
        print("FAIL", n, url, e)
print("Khatam. assets/audio ka size check karein.")
