#!/usr/bin/env bash
# my_custom_script.sh - A handy utility script
# Place this in ~/.local/bin/ (stowed automatically by install.sh)

set -euo pipefail

# ---- helpers ----------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] COMMAND

A small collection of useful shell utilities.

Commands:
  mkcd <dir>       Create a directory and cd into it
  backup <file>    Create a timestamped backup copy of a file
  extract <file>   Extract common archive formats automatically
  weather [city]   Show current weather (requires curl)

Options:
  -h, --help       Show this help message and exit
EOF
}

# ---- commands ---------------------------------------------------------------
cmd_mkcd() {
  local dir="${1:?mkcd requires a directory name}"
  # NOTE: 'cd' only works when this function is sourced in the current shell.
  # Add the following to your .zshrc to use mkcd directly:
  #   mkcd() { my_custom_script.sh mkcd "$@" && cd "$@"; }
  mkdir -p "$dir" && echo "Created: $dir (cd into it manually, or source this script)"
}

cmd_backup() {
  local file="${1:?backup requires a file path}"
  local dest="${file}.bak.$(date +%Y%m%d_%H%M%S)"
  cp -v "$file" "$dest"
}

cmd_extract() {
  local file="${1:?extract requires an archive file}"
  case "$file" in
    *.tar.bz2)  tar xjf "$file"   ;;
    *.tar.gz)   tar xzf "$file"   ;;
    *.tar.xz)   tar xJf "$file"   ;;
    *.tar.zst)  tar --zstd -xf "$file" ;;
    *.bz2)      bunzip2 "$file"   ;;
    *.gz)       gunzip  "$file"   ;;
    *.tar)      tar xf  "$file"   ;;
    *.tbz2)     tar xjf "$file"   ;;
    *.tgz)      tar xzf "$file"   ;;
    *.zip)      unzip   "$file"   ;;
    *.Z)        uncompress "$file" ;;
    *.7z)       7z x    "$file"   ;;
    *.rar)      unrar x "$file"   ;;
    *)  echo "ERROR: '$file' — unknown archive format" >&2; exit 1 ;;
  esac
}

cmd_weather() {
  local city="${1:-}"
  curl -fsSL "https://wttr.in/${city}?format=3"
}

# ---- dispatch ---------------------------------------------------------------
main() {
  local cmd="${1:-}"
  shift || true

  case "$cmd" in
    mkcd)    cmd_mkcd    "$@" ;;
    backup)  cmd_backup  "$@" ;;
    extract) cmd_extract "$@" ;;
    weather) cmd_weather "$@" ;;
    -h|--help|help|"") usage ;;
    *) echo "ERROR: unknown command '$cmd'" >&2; usage; exit 1 ;;
  esac
}

main "$@"
