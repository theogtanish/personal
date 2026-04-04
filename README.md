<div align="center">

# 🛠️ Personal

![Python](https://img.shields.io/badge/Python-3.x-blue?style=for-the-badge&logo=python&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Linux-informational?style=for-the-badge&logo=linux&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge)

> Scripts and tools I actually use day-to-day on my own machine. 🔧  
> Not tutorials. Not exercises. Just things I built because I needed them.

</div>

---

## 👋 About This Repo

Hey, I'm **Tanish**. This is where I keep personal-use scripts — small tools I wrote to automate annoying things on my setup.

Everything here runs on my **Arch Linux** machine. If it works for you too, great. If not, tweak it.

---

## 📂 Projects

| #   | Project      | File                       | Description                                                                                                                                                                                                          | Date Added |
| --- | ------------ | -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| 1   | 🗂️ Sorty | [`sorty.py`](sorty.py) | A background daemon that watches `~/Downloads/brave` and automatically moves files into the right folders — Videos, Pictures, Music, Documents, apps, archives — by extension. Uses `watchdog`. Autostarts via Hyprland. | 2026-04-05 |

> More tools coming as I keep building stuff I need. 👀

---

## 🛠️ How to Run

Make sure you have **Python 3** and **pip** installed, then follow the steps for each tool:

**Install the dependency:**

```bash
pip install watchdog --break-system-packages
```

**Place the script:**

```bash
mkdir -p ~/scripts
mv sorty.py ~/scripts/sorty.py
```

**Set Brave's download folder** to `~/Downloads/brave` in `brave://settings/downloads`

**Autostart with Hyprland** — add this to your `hyprland.conf`:

```
exec-once = python3 ~/scripts/sorty.py
```

---

## ⚙️ System

- OS: Arch Linux
- WM: Hyprland
- Browser: Brave

---

## 🙌 Connect

If any of this is useful to you, feel free to star ⭐ the repo or follow along!

---

<div align="center">
  <sub>Built for my own machine. Use it if it helps. Break it if you want. 🤷</sub>
</div>
