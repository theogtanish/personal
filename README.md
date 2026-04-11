<div align="center">

# Personal

![Python](https://img.shields.io/badge/Python-3.x-blue?style=for-the-badge&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux-informational?style=for-the-badge&logo=linux&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)

> Scripts I actually use on my own machine.  
> Not tutorials. Not exercises. Just things I built because I needed them.

</div>

---

## About

I'm **Tanish**. This is where I keep scripts I wrote to fix annoying things on my setup.

Everything runs on my **Arch Linux** machine.

---

## Projects

| #   | Project   | File                           | Description                                                                                                                                          | Date Added |
| --- | --------- | ------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| 1   | Sorty     | [`sorty.py`](sorty.py)         | Watches `~/Downloads/brave` and moves files into the right folders — Videos, Pictures, Music, Documents, apps, archives — by extension. Autostarts via Hyprland. | 2026-04-05 |
| 2   | Mousike   | [`mousike.py`](mousike.py)     | Terminal music downloader. Search YouTube, pick a result, get an MP3 in `~/Music`. Named after the ancient Greek word for music — *Μουσική*.         | 2026-04-11 |

---

## How to Run

### Sorty

```bash
pip install watchdog --break-system-packages
mkdir -p ~/scripts
mv sorty.py ~/scripts/sorty.py
```

Set Brave's download folder to `~/Downloads/brave` in `brave://settings/downloads`

Add to `hyprland.conf`:
```
exec-once = python3 ~/scripts/sorty.py
```

---

### Mousike

```bash
pip install yt-dlp --break-system-packages
sudo pacman -S ffmpeg
python mousike.py
```

No arguments. It asks for a search query and handles the rest. Downloads to `~/Music` as 320kbps MP3.

---

## System

- OS: Arch Linux
- WM: Hyprland
- Browser: Brave

---

<div align="center">
  <sub>Built for my own machine. Use it if it helps. Break it if you want.</sub>
</div>
