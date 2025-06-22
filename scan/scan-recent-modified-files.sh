#!/bin/bash

# --------------------------------------------
# Scan for recently modified files in a WordPress directory
# --------------------------------------------
# Usage: ./scan-recent-modified-files.sh /path/to/site [days]
# Example: ./scan-recent-modified-files.sh /var/www/html 7
#
# Default: 7 days if not provided
# --------------------------------------------

# Check if a path was provided
if [ -z "$1" ]; then
  echo "❌ Error: No path provided."
  echo "Usage: $0 /path/to/site [days]"
  exit 1
fi

TARGET_DIR=$1
DAYS=${2:-7}

# Check if directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Error: Directory $TARGET_DIR does not exist."
  exit 1
fi

echo "🔍 Scanning $TARGET_DIR for files modified in the last $DAYS day(s)..."
echo

# BSD/macOS-compatible version (no -printf)
find "$TARGET_DIR" -type f -mtime "-$DAYS" -exec stat -f '%m %N' {} \; 2>/dev/null |
  sort -n |
  while read -r mod_time file; do
    date_str=$(date -r "$mod_time" "+%Y-%m-%d %H:%M:%S")
    echo "$date_str $file"
  done

echo
echo "✅ Scan complete."
