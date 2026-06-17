#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=false
VERSION=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    -*) echo "Unknown flag: $1"; exit 1 ;;
    *) VERSION="$1"; shift ;;
  esac
done

if [ -z "$VERSION" ]; then
  echo "Usage: $0 [--dry-run] <version>"
  echo "Example: $0 0.2.0"
  exit 1
fi

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHANGELOG="$REPO_ROOT/CHANGELOG.md"
DATE=$(date +%Y-%m-%d)

LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
if [ -z "$LAST_TAG" ]; then
  LAST_TAG=$(git rev-list --max-parents=0 HEAD)
fi

echo "→ Generating changelog for v$VERSION (since $LAST_TAG)"

# Collect commits and categorize them
FEAT=""; FIX=""; DOCS=""; CHORE=""; OTHER=""

while IFS= read -r msg; do
  nl=$'\n'
  case "$msg" in
    feat\(*\):*)  FEAT="${FEAT}  - $msg${nl}" ;;
    feat:*)       FEAT="${FEAT}  - $msg${nl}" ;;
    fix\(*\):*)   FIX="${FIX}  - $msg${nl}" ;;
    fix:*)        FIX="${FIX}  - $msg${nl}" ;;
    docs\(*\):*)  DOCS="${DOCS}  - $msg${nl}" ;;
    docs:*)       DOCS="${DOCS}  - $msg${nl}" ;;
    chore\(*\):*) CHORE="${CHORE}  - $msg${nl}" ;;
    chore:*)      CHORE="${CHORE}  - $msg${nl}" ;;
    ci\(*\):*)    CHORE="${CHORE}  - $msg${nl}" ;;
    ci:*)         CHORE="${CHORE}  - $msg${nl}" ;;
    build\(*\):*) CHORE="${CHORE}  - $msg${nl}" ;;
    build:*)      CHORE="${CHORE}  - $msg${nl}" ;;
    *)            OTHER="${OTHER}  - $msg${nl}" ;;
  esac
done < <(git --no-pager log "$LAST_TAG..HEAD" --pretty=format:"%s" --no-merges)

# Build entry content
ENTRY=""
ENTRY+=$'\n'"## [v$VERSION] — $DATE"$'\n'

[ -n "$FEAT" ]  && ENTRY+=$'\n'"### ✨ Features"$'\n\n'"$FEAT"
[ -n "$FIX" ]   && ENTRY+=$'\n'"### 🐛 Bug Fixes"$'\n\n'"$FIX"
[ -n "$DOCS" ]  && ENTRY+=$'\n'"### 📝 Documentation"$'\n\n'"$DOCS"
[ -n "$CHORE" ] && ENTRY+=$'\n'"### 🔧 Chores"$'\n\n'"$CHORE"
[ -n "$OTHER" ] && ENTRY+=$'\n'"### 📦 Other"$'\n\n'"$OTHER"

# Prepend to CHANGELOG (newest version first)
if [ "$DRY_RUN" = true ]; then
  echo "=== DRY RUN — no changes written ==="
  printf '%b\n' "$ENTRY"
  exit 0
fi

if [ -f "$CHANGELOG" ] && head -1 "$CHANGELOG" 2>/dev/null | grep -q "^# "; then
  HEADER=$(head -1 "$CHANGELOG")
  BODY=$(tail -n +2 "$CHANGELOG" | sed '/^$/d')
  printf '%s\n%b\n%s\n' "$HEADER" "$ENTRY" "$BODY" > "$CHANGELOG"
else
  printf '%s\n\n%b\n' "# Changelog" "$ENTRY" > "$CHANGELOG"
fi

echo "→ Entry prepended to $CHANGELOG"
echo "→ Don't forget to review and commit!"
