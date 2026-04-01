# Super_Kitty

Personal dotfiles for a Kitty + Zsh setup managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── README.md
├── install.sh                   # Bootstrap script — installs stow and symlinks everything
├── zsh/                         # Zsh configuration  → ~/
│   └── .zshrc
├── git/                         # Git configuration  → ~/
│   ├── .gitconfig
│   └── .gitignore_global
├── config/                      # Tool configs       → ~/.config/
│   ├── starship/
│   │   └── starship.toml
│   ├── kitty/
│   │   └── kitty.conf
│   └── eza/
│       └── theme.yml
└── scripts/                     # Custom scripts     → ~/.local/bin/
    └── my_custom_script.sh
```

## Quick Start

```bash
git clone https://github.com/Aghavali9/Super_Kitty.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

`install.sh` will:
1. Install **GNU Stow** if it isn't already present (supports apt, brew, pacman, dnf).
2. Stow each package so that symlinks are created in the correct locations:
   - `zsh/` and `git/` → `$HOME`
   - `config/` → `$HOME` (so `config/kitty/kitty.conf` lands at `~/.config/kitty/kitty.conf`)
   - `scripts/` → `$HOME` (so scripts land in `~/.local/bin/`)

## Requirements

| Tool | Purpose |
|------|---------|
| [Zsh](https://www.zsh.org/) | Shell |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | Terminal emulator |
| [Starship](https://starship.rs/) | Cross-shell prompt |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement |
| [GNU Stow](https://www.gnu.org/software/stow/) | Symlink farm manager |
