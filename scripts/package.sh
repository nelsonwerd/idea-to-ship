#!/usr/bin/env bash
# package.sh — build the .skill archives for the idea-to-ship suite.
#
# For each skill under skills/<name>/ it: validates the SKILL.md frontmatter,
# stages a clean copy (dropping .DS_Store / .git), injects the repo LICENSE,
# zips it to <name>.skill at the repo root, verifies the archive, and prints
# a SHA-256 checksum.
#
# Usage:
#   scripts/package.sh            # package every skill under skills/
#   scripts/package.sh ideate     # package just one skill
#
# Manual tool — not wired to CI or a hook. zip embeds mtimes, so re-running
# won't always reproduce identical bytes; the printed checksum is the audit
# handle. To refresh a standalone repo's archive, run this and copy the
# resulting <name>.skill over (suite and standalone content are kept in sync).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LICENSE_FILE="$ROOT/LICENSE"
SKILLS_DIR="$ROOT/skills"

fail() { echo "ERROR: $*" >&2; exit 1; }

# Resolve the skill list: explicit args, or every directory under skills/.
skills=("$@")
if [ ${#skills[@]} -eq 0 ]; then
  while IFS= read -r d; do skills+=("$(basename "$d")"); done \
    < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d | sort)
fi

# One staging root for the whole run, cleaned once on exit (no per-iteration trap).
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

for name in "${skills[@]}"; do
  src="$SKILLS_DIR/$name"
  skillmd="$src/SKILL.md"
  [ -d "$src" ]     || fail "no skill folder: $src"
  [ -f "$skillmd" ] || fail "missing SKILL.md: $skillmd"

  # Validate frontmatter: opens with a '---' fence, carries 'name: <self>' and 'description:'.
  head -1 "$skillmd" | grep -qx -- '---' \
    || fail "$name: SKILL.md must start with a '---' frontmatter fence"
  fm="$(awk 'NR>1 && /^---[[:space:]]*$/{exit} NR>1{print}' "$skillmd")"
  printf '%s\n' "$fm" | grep -qE '^name:[[:space:]]*[^[:space:]]'            || fail "$name: frontmatter missing 'name:'"
  printf '%s\n' "$fm" | grep -qE '^description:[[:space:]]*([^[:space:]]|[>|])' || fail "$name: frontmatter missing 'description:'"
  fm_name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -1)"
  [ "$fm_name" = "$name" ] || fail "$name: frontmatter name '$fm_name' != folder name '$name'"

  # Clean staging copy, then inject LICENSE.
  stage="$work/$name"
  cp -R "$src" "$stage"
  find "$stage" -name .DS_Store -delete
  find "$stage" -name .git -prune -exec rm -rf {} + 2>/dev/null || true
  [ -f "$LICENSE_FILE" ] && cp "$LICENSE_FILE" "$stage/LICENSE"

  out="$ROOT/$name.skill"
  rm -f "$out"
  ( cd "$work" && zip -rqX "$out" "$name" )   # -X strips extra attrs for stabler archives

  # Verify the archive carries the two required files.
  unzip -l "$out" | grep -q "$name/SKILL.md" || fail "$name: SKILL.md missing from archive"
  unzip -l "$out" | grep -q "$name/LICENSE"  || fail "$name: LICENSE missing from archive"

  sum="$(shasum -a 256 "$out" | awk '{print $1}')"
  echo "built $name.skill  sha256=$sum"
done

echo "done."
