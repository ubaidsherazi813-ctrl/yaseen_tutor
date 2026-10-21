#!/usr/bin/env python3
import json
import os
import sqlite3

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "..", "assets", "data", "yaseen.db")
JSON_PATH = os.path.join(BASE_DIR, "..", "assets", "data", "yaseen_content.json")

def export_json():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()

    ayaat = [dict(r) for r in cur.execute("SELECT * FROM ayaat ORDER BY id").fetchall()]
    words = [dict(r) for r in cur.execute("SELECT * FROM words ORDER BY ayat_id, position").fetchall()]
    segments = [dict(r) for r in cur.execute("SELECT * FROM segments ORDER BY word_id, seg_order").fetchall()]
    topics = [dict(r) for r in cur.execute("SELECT * FROM topics ORDER BY id").fetchall()]

    data = {
        "ayaat": ayaat,
        "words": words,
        "segments": segments,
        "topics": topics
    }

    with open(JSON_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"Exported to {JSON_PATH}:")
    print(f"  {len(ayaat)} ayaat, {len(words)} words, {len(segments)} segments, {len(topics)} topics")

if __name__ == "__main__":
    export_json()
