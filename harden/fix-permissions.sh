#!/bin/bash

# --------------------------------------------
# Fix file and folder permissions in a WordPress site
# --------------------------------------------
# Usage: ./fix-permissions.sh /path/to/wordpress [--dry-run]
#
# Sets:
# - 755 for all directories
# - 644 for all files
# - 600 for wp-config.php
# --------------------------------------------

TARGET_DIR=$1
DRY_RUN=$2

if [ -z "$TARGET_DIR" ]; then
  echo "❌ Error: No path provided."
  echo "Usage: $0 /path/to/wordpress [--dry-run]"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Error: Directory $TARGET_DIR does not exist."
  exit 1
fi

echo "🔧 Fixing permissions in: $TARGET_DIR"
[ "$DRY_RUN" == "--dry-run" ] && echo "💡 Dry-run mode: no changes will be made."
echo

# Check for dangerously open permissions
echo "🕵️ Scanning for dangerous permissions (666/777)..."
DANGEROUS=$(find "$TARGET_DIR" \( -perm 777 -o -perm 666 \))
if [ -n "$DANGEROUS" ]; then
  echo "⚠️ Warning: Found files or folders with unsafe permissions:"
  echo "$DANGEROUS"
  echo
fi

# Directories ➜ 755
echo "📁 Setting 755 for directories..."
DIR_COUNT=0
while IFS= read -r dir; do
  ((DIR_COUNT++))
  [ "$DRY_RUN" != "--dry-run" ] && chmod 755 "$dir"
done < <(find "$TARGET_DIR" -type d)

# Files ➜ 644
echo "📄 Setting 644 for files..."
FILE_COUNT=0
while IFS= read -r file; do
  ((FILE_COUNT++))
  [ "$DRY_RUN" != "--dry-run" ] && chmod 644 "$file"
done < <(find "$TARGET_DIR" -type f)

# wp-config.php ➜ 600
WPCONFIG="$TARGET_DIR/wp-config.php"
if [ -f "$WPCONFIG" ]; then
  echo "🔒 Locking down wp-config.php ➜ 600"
  [ "$DRY_RUN" != "--dry-run" ] && chmod 600 "$WPCONFIG"
fi

echo
echo "✅ Done."
echo "🧾 Summary:"
echo "- Directories processed: $DIR_COUNT"
echo "- Files processed:       $FILE_COUNT"
[ "$DRY_RUN" == "--dry-run" ] && echo "- Mode: DRY-RUN (no changes applied)"
