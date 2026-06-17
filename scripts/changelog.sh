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

[ -n "$FEAT" ]  && ENTRY+=$'\n'"### Added"$'\n\n'"$FEAT"
[ -n "$FIX" ]   && ENTRY+=$'\n'"### Fixed"$'\n\n'"$FIX"
[ -n "$DOCS" ]  && ENTRY+=$'\n'"### Changed"$'\n\n'"$DOCS"
[ -n "$CHORE" ] && ENTRY+=$'\n'"### Changed"$'\n\n'"$CHORE"
[ -n "$OTHER" ] && ENTRY+=$'\n'"### Changed"$'\n\n'"$OTHER"

# Prepend to CHANGELOG (newest version first)
if [ "$DRY_RUN" = true ]; then
  echo "=== DRY RUN — no changes written ==="
  printf '%b\n' "$ENTRY"
  exit 0
fi

if [ -f "$CHANGELOG" ] && grep -q "^# " "$CHANGELOG"; then
  # Find the first version header — insert before it
  HEADER_LINES=$(grep -n "^## \[" "$CHANGELOG" | head -1 | cut -d: -f1 || echo "")
  if [ -n "$HEADER_LINES" ]; then
    HEAD=$(head -n $((HEADER_LINES - 1)) "$CHANGELOG")
    TAIL=$(tail -n +$HEADER_LINES "$CHANGELOG")
    printf '%s\n%b\n%s\n' "$HEAD" "$ENTRY" "$TAIL" > "$CHANGELOG"
  else
    printf '%b\n' "$ENTRY" >> "$CHANGELOG"
  fi
else
  printf '%s\n\n%s\n\n%s\n\n%s\n' \
    "# Changelog" \
    "All notable changes to this project will be documented in this file." \
    "The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)," \
    "and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)." \
    > "$CHANGELOG"
  printf '%b\n' "$ENTRY" >> "$CHANGELOG"
fi

echo "→ Entry prepended to $CHANGELOG"
echo "→ Don't forget to review and commit!"
