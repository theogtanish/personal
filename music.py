import os
import glob
import yt_dlp

MUSIC_DIR = os.path.expanduser("~/Music")

# Ordered by reliability — Firefox first (no encryption), then Chromium-based
BROWSER_CHECKS = [
    ("firefox",  "~/.mozilla/firefox/*/cookies.sqlite"),
    ("chromium", "~/.config/chromium/Default/Cookies"),
    ("chrome",   "~/.config/google-chrome/Default/Cookies"),
    ("brave",    "~/.config/BraveSoftware/Brave-Browser/Default/Cookies"),
    ("edge",     "~/.config/microsoft-edge/Default/Cookies"),
]


def detect_browser() -> str | None:
    for browser, pattern in BROWSER_CHECKS:
        if glob.glob(os.path.expanduser(pattern)):
            return browser
    return None


def search(query: str) -> list[dict]:
    opts = {"quiet": True, "no_warnings": True, "extract_flat": True}
    with yt_dlp.YoutubeDL(opts) as ydl:
        info = ydl.extract_info(f"ytsearch10:{query}", download=False)

    if not info:
        return []

    results = []
    for e in info.get("entries", []):
        if not isinstance(e, dict):
            continue

        url = e.get("url") or (f"https://www.youtube.com/watch?v={e['id']}" if e.get("id") else None)
        if not url:
            continue

        mins, secs = divmod(int(e.get("duration") or 0), 60)
        results.append({
            "title":    e.get("title", "Unknown"),
            "url":      url,
            "duration": f"{mins}:{secs:02d}",
            "uploader": e.get("uploader", ""),
        })
    return results


def download(url: str) -> str | None:
    opts = {
        "format":         "bestaudio/best",
        "outtmpl":        os.path.join(MUSIC_DIR, "%(title)s.%(ext)s"),
        "postprocessors": [{"key": "FFmpegExtractAudio", "preferredcodec": "mp3", "preferredquality": "320"}],
        "quiet":          True,
        "no_warnings":    True,
        "overwrites":     True,  # always write to exact expected path, no (1)(2) suffixes
    }

    browser = detect_browser()
    if browser:
        opts["cookiesfrombrowser"] = (browser,)

    saved_path = None

    def progress_hook(d):
        nonlocal saved_path
        if d["status"] == "finished":
            saved_path = os.path.splitext(d["filename"])[0] + ".mp3"

    opts["progress_hooks"] = [progress_hook]

    with yt_dlp.YoutubeDL(opts) as ydl:
        ydl.download([url])

    return saved_path


def prompt(msg: str) -> str:
    return input(msg).strip()


def main():
    os.makedirs(MUSIC_DIR, exist_ok=True)

    print("\n  ♪  Music Downloader\n")

    while True:
        query = prompt("  Search: ")
        if not query:
            continue

        print("\n  Searching...\n")

        try:
            results = search(query)
        except Exception as e:
            print(f"\n  Error during search: {e}\n")
            continue

        if not results:
            print("  No results found.\n")
            continue

        for i, r in enumerate(results, 1):
            uploader = f" — {r['uploader']}" if r["uploader"] else ""
            print(f"  [{i}] {r['title']}{uploader}  ({r['duration']})")

        print()

        while True:
            choice = prompt(f"  Pick [1-{len(results)}]: ")
            if choice.isdecimal() and 1 <= int(choice) <= len(results):
                break
            print("  Invalid choice. Try again.")

        selected = results[int(choice) - 1]
        print(f"\n  ↓ Downloading: {selected['title']}")

        try:
            path = download(selected["url"])
        except Exception as e:
            print(f"\n  Download failed: {e}\n")
            continue

        if path and os.path.exists(path):
            print(f"  ✓ Saved: {path}\n")
        else:
            print("  ✓ Download complete (check ~/Music)\n")

        print()
        again = prompt("  Search for another? [y/n]: ")
        if again.lower() != "y":
            print("\n  Bye.\n")
            break


if __name__ == "__main__":
    main()
