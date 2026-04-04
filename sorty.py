import time
import shutil
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Folder Brave saves downloads to — this is what we watch
WATCH_DIR = Path.home() / "Downloads" / "brave"

# Maps file extensions to their destination folders
# Add or remove extensions here as needed
CATEGORIES = {
    # Videos
    "mp4":      Path.home() / "Videos",
    "mkv":      Path.home() / "Videos",
    "mov":      Path.home() / "Videos",
    "avi":      Path.home() / "Videos",
    "webm":     Path.home() / "Videos",
    # Pictures
    "png":      Path.home() / "Pictures",
    "jpg":      Path.home() / "Pictures",
    "jpeg":     Path.home() / "Pictures",
    "gif":      Path.home() / "Pictures",
    "webp":     Path.home() / "Pictures",
    "svg":      Path.home() / "Pictures",
    "ico":      Path.home() / "Pictures",
    # Music
    "mp3":      Path.home() / "Music",
    "flac":     Path.home() / "Music",
    "ogg":      Path.home() / "Music",
    "aac":      Path.home() / "Music",
    "wav":      Path.home() / "Music",
    # Documents
    "pdf":      Path.home() / "Documents",
    "docx":     Path.home() / "Documents",
    "doc":      Path.home() / "Documents",
    "txt":      Path.home() / "Documents",
    "xlsx":     Path.home() / "Documents",
    "xls":      Path.home() / "Documents",
    "pptx":     Path.home() / "Documents",
    "csv":      Path.home() / "Documents",
    # Apps
    "exe":      Path.home() / "Downloads" / "apps",
    "appimage": Path.home() / "Downloads" / "apps",
    "deb":      Path.home() / "Downloads" / "apps",
    "rpm":      Path.home() / "Downloads" / "apps",
    "iso":      Path.home() / "Downloads" / "apps",
    "dmg":      Path.home() / "Downloads" / "apps",
    # Archives
    "zip":      Path.home() / "Downloads" / "archives",
    "tar":      Path.home() / "Downloads" / "archives",
    "gz":       Path.home() / "Downloads" / "archives",
    "xz":       Path.home() / "Downloads" / "archives",
    "rar":      Path.home() / "Downloads" / "archives",
    "7z":       Path.home() / "Downloads" / "archives",
}

# Brave writes these temporary extensions while a download is in progress
# We ignore them and only act on the final completed file
IGNORE_SUFFIXES = {".crdownload", ".part"}


# If a file with the same name already exists at the destination,
# append _1, _2, _3 ... until we find a free name
def resolve_destination(dst_dir: Path, filename: str) -> Path:
    dst = dst_dir / filename
    if not dst.exists():
        return dst
    # Handle double extensions like .tar.gz correctly
    p = Path(filename)
    suffix = "".join(p.suffixes)
    stem = filename[: len(filename) - len(suffix)]
    counter = 1
    while True:
        candidate = dst_dir / f"{stem}_{counter}{suffix}"
        if not candidate.exists():
            return candidate
        counter += 1


def move_file(src: Path):
    ext = src.suffix.lstrip(".").lower()
    dst_dir = CATEGORIES.get(ext)
    if dst_dir is None:
        return
    dst_dir.mkdir(parents=True, exist_ok=True)
    dst = resolve_destination(dst_dir, src.name)
    try:
        shutil.move(str(src), str(dst))
        print(f"Moved: {src.name} → {dst}")
    except Exception as e:
        print(f"Error moving {src.name}: {e}")


class DownloadHandler(FileSystemEventHandler):
    # Fires every time a new file appears in the watch folder
    def on_created(self, event):
        if event.is_directory:
            return
        src = Path(event.src_path)
        if src.suffix.lower() in IGNORE_SUFFIXES:
            return
        # Brief wait to let Brave finish writing the file before we move it
        time.sleep(2)
        if not src.exists():
            return
        move_file(src)

    # Brave renames file.mp4.crdownload → file.mp4 when download completes
    # That rename fires on_moved, not on_created — so we handle it here
    def on_moved(self, event):
        if event.is_directory:
            return
        dst = Path(event.dest_path)
        if dst.suffix.lower() in IGNORE_SUFFIXES:
            return
        if not dst.exists():
            return
        move_file(dst)


if __name__ == "__main__":
    # Ensure the watch folder exists before starting the observer
    WATCH_DIR.mkdir(parents=True, exist_ok=True)
    handler = DownloadHandler()
    observer = Observer()
    observer.schedule(handler, str(WATCH_DIR), recursive=False)
    observer.start()
    print(f"Watching: {WATCH_DIR}")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
  
