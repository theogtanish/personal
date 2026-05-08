#!/usr/bin/env bash
# =============================================================
#   omarhcy's Arch Linux Setup Script
#   Run as a regular user (with sudo access), NOT as root
# =============================================================

set -e  # exit on error

# ── colors ────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${CYAN}[•]${RESET} $*"; }
success() { echo -e "${GREEN}[✓]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $*"; }
section() { echo -e "\n${BOLD}${CYAN}══ $* ══${RESET}\n"; }

# ── sanity checks ─────────────────────────────────────────────
[[ $EUID -eq 0 ]] && { echo -e "${RED}Don't run as root!${RESET}"; exit 1; }
command -v pacman &>/dev/null || { echo "Not an Arch system!"; exit 1; }

# =============================================================
#  1. SYSTEM UPDATE
# =============================================================
section "System Update"
sudo pacman -Syu --noconfirm
success "System updated"

# =============================================================
#  2. INSTALL YAY (AUR helper) — needed for AUR packages
# =============================================================
section "AUR Helper → yay"
if ! command -v yay &>/dev/null; then
    info "Installing yay..."
    sudo pacman -S --noconfirm --needed git base-devel
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    success "yay installed"
else
    success "yay already installed — skipping"
fi

# =============================================================
#  3. OFFICIAL REPO PACKAGES  (pacman)
# =============================================================
section "Official Packages (pacman)"

PACMAN_PKGS=(
    # ── your picks ────────────────────────────────────────────
    bash          # The shell itself (keep up to date)
    fzf           # Fuzzy finder — interactive search for anything
    fd            # Blazing-fast modern replacement for `find`
    zoxide        # Smarter `cd` — learns your most-visited dirs
    ripgrep       # `rg` — fastest grep in the west, respects .gitignore
    github-cli    # `gh` — manage PRs, issues, repos from terminal
    bat           # Better `cat` with syntax highlighting & line numbers
    pass          # Unix password manager — GPG-encrypted, git-backed

    # ── suggested additions ───────────────────────────────────
    eza           # Modern `ls` replacement (icons, tree view, git info)
    btop          # Beautiful real-time resource monitor (CPU/RAM/GPU)
    starship      # Blazing-fast cross-shell prompt customizer
    tmux          # Terminal multiplexer — split panes, persist sessions
    neovim        # Extensible text editor (the good one)
    lazygit       # Terminal UI for git — stage, commit, branch visually
    git-delta     # Stunning diffs for git, side-by-side, syntax-aware
    stow          # Symlink manager — the dotfiles best friend
    tldr          # Simplified man pages with practical examples
    zsh           # Z shell — popular bash alternative
    jq            # JSON processor for the terminal
    yq            # YAML/TOML processor (like jq for YAML)
    ncdu          # Visual disk usage — find what's eating your space
    wget          # Reliable file downloader
    curl          # HTTP client & all-round network Swiss Army knife
    rsync         # Efficient file sync/backup tool
    tree          # Print directory structure as a tree
    unzip         # Extract .zip archives
    p7zip         # 7z archives support
    noto-fonts    # Google Noto fonts — great unicode coverage
    ttf-nerd-fonts-symbols   # Nerd Font symbols for terminal icons

    # ── terminal productivity ──────────────────────────────────
    direnv        # Auto-loads .envrc when you cd into a folder — per-project env vars
    just          # Sane `make` alternative — store project shortcuts in a Justfile
    task          # Taskwarrior — powerful terminal to-do & task manager

    # ── file & navigation ─────────────────────────────────────
    broot         # Interactive tree navigator with fuzzy search inside huge dirs
    yazi          # Blazing fast terminal file manager with image preview
    duf           # Better `df` — disk usage with colors and a clean table

    # ── network & web ─────────────────────────────────────────
    xh            # Human-friendly curl alternative: `xh get api.example.com`
    bandwhich     # Real-time bandwidth usage per process and connection

    # ── dev tools ─────────────────────────────────────────────
    tokei         # Count lines of code in a project, by language, very fast
    hyperfine     # Benchmark any CLI command — runs N times, gives full stats
    difftastic    # Structural diff that understands code syntax, not just lines

    # ── system ────────────────────────────────────────────────
    procs         # Modern colorized `ps` replacement, searchable
    bottom        # `btm` — lightweight alternative to btop
    tealdeer      # Faster Rust-based tldr client (same concept, snappier)
    sd            # Simpler sed: `sd 'old' 'new' file` — no regex escaping pain

    # ── fun / misc ────────────────────────────────────────────
    glow          # Render Markdown beautifully right in the terminal
    cmatrix       # The Matrix rain effect. Useless. Essential.
)

sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
success "Official packages installed"

# =============================================================
#  4. AUR PACKAGES  (yay)
# =============================================================
section "AUR Packages (yay)"

AUR_PKGS=(
    # ── your picks ────────────────────────────────────────────
    brave-bin             # Brave Browser — privacy-focused, Chromium-based
    sklauncher-nojava     # SKLauncher — free Minecraft launcher (no Java bundled)
    doppler-cli           # Doppler — sync env vars & secrets across environments
    python-antigravity    # Antigravity — the Python `import antigravity` easter egg 🚀

    # ── suggested additions ───────────────────────────────────
    vesktop-bin           # Vesktop — better Discord client (Vencord built-in)
    nvm                   # Node Version Manager — switch Node.js versions easily
    spotify               # Spotify desktop client

    # ── terminal productivity ──────────────────────────────────
    atuin                 # Replaces shell history with a synced, searchable database
    mcfly-bin             # Smarter Ctrl+R history search using a neural network
    navi                  # Interactive cheatsheet for terminal commands, fzf-powered

    # ── file & navigation ─────────────────────────────────────
    xcp                   # Better `cp` with progress bars and parallel copying

    # ── network & web ─────────────────────────────────────────
    dog                   # Colorful modern `dig` replacement for DNS lookups
    gping                 # `ping` but with a live graph drawn in your terminal

    # ── dev tools ─────────────────────────────────────────────
    lazydocker            # TUI for Docker — like lazygit but for containers
    ast-grep              # Find and rewrite code using AST patterns, multi-language

    # ── system ────────────────────────────────────────────────
    choose                # Friendlier awk/cut for picking columns: `choose 0 2`

    # ── fun / misc ────────────────────────────────────────────
    slides-tui            # Give terminal presentations from a Markdown file
    ascii-image-converter # Convert images to ASCII art in the terminal
)

yay -S --noconfirm --needed "${AUR_PKGS[@]}"
success "AUR packages installed"

# =============================================================
#  5. SHELL CONFIG SNIPPETS  (appended to ~/.bashrc)
# =============================================================
section "Shell Config"

BASHRC="$HOME/.bashrc"

append_if_missing() {
    local marker="$1"; local block="$2"
    grep -qF "$marker" "$BASHRC" 2>/dev/null || echo -e "\n$block" >> "$BASHRC"
}

# zoxide — smart cd
append_if_missing "zoxide init" \
'# zoxide (smart cd)
eval "$(zoxide init bash)"'

# starship prompt
append_if_missing "starship init" \
'# starship prompt
eval "$(starship init bash)"'

# fzf keybindings + completion
append_if_missing "fzf.bash" \
'# fzf keybindings and fuzzy completion
[[ -f /usr/share/fzf/key-bindings.bash ]]  && source /usr/share/fzf/key-bindings.bash
[[ -f /usr/share/fzf/completion.bash ]]    && source /usr/share/fzf/completion.bash'

# bat as cat alias
append_if_missing "alias cat=bat" \
'# bat as cat
alias cat="bat --paging=never"'

# eza as ls aliases
append_if_missing "alias ls=eza" \
'# eza as ls
alias ls="eza --icons"
alias ll="eza -lah --icons --git"
alias lt="eza --tree --icons"'

# gh autocomplete
append_if_missing "gh completion" \
'# GitHub CLI completion
eval "$(gh completion -s bash)"'

# atuin — shell history
append_if_missing "atuin init" \
'# atuin (enhanced shell history)
eval "$(atuin init bash)"'

# direnv hook
append_if_missing "direnv hook" \
'# direnv — auto-load .envrc per project
eval "$(direnv hook bash)"'

# mcfly — smart history
append_if_missing "mcfly init" \
'# mcfly (neural history search)
eval "$(mcfly init bash)"'

success "Shell config snippets added to ~/.bashrc"

# =============================================================
#  6. DONE
# =============================================================
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════╗${RESET}"
echo -e "${GREEN}${BOLD}║   Setup complete, omarhcy! ✨         ║${RESET}"
echo -e "${GREEN}${BOLD}║   Run: source ~/.bashrc               ║${RESET}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════╝${RESET}"
echo ""
