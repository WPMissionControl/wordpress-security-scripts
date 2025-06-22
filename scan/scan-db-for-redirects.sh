#!/bin/bash

# --------------------------------------------
# Scan WordPress database (or dump) for suspicious redirect links
# --------------------------------------------
# Usage: ./scan-db-for-redirects.sh /path/to/db_dump.sql yourdomain.com [--dry-run]
#
# - Greps all <a href="..."> links
# - Filters out internal links
# - Flags links with suspicious TLDs or IP addresses
# --------------------------------------------

DB_FILE=$1
YOUR_DOMAIN=$2
DRY_RUN=$3

if [ -z "$DB_FILE" ] || [ -z "$YOUR_DOMAIN" ]; then
  echo "❌ Error: Missing required arguments."
  echo "Usage: $0 /path/to/db_dump.sql yourdomain.com [--dry-run]"
  exit 1
fi

if [ ! -f "$DB_FILE" ]; then
  echo "❌ Error: File '$DB_FILE' not found."
  exit 1
fi

echo "🔍 Scanning $DB_FILE for suspicious <a href= links..."
[ "$DRY_RUN" == "--dry-run" ] && echo "💡 Dry-run mode: no actions will be taken."
echo

# Extract all href links and strip tag
LINKS=$(grep -oi '<a href=["'\''"]\?[^"'\'' >]*' "$DB_FILE" | sed -E 's/<a href=["'\''"]?//I')

# Filter external links only
EXTERNAL_LINKS=$(echo "$LINKS" | grep -v "$YOUR_DOMAIN")

# Filter for suspicious TLDs or raw IPs
SUSPICIOUS_LINKS=$(echo "$EXTERNAL_LINKS" | grep -E '\.ru|\.xyz|\.top|\.click|\.info|\.tk|http://[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

COUNT=$(echo "$SUSPICIOUS_LINKS" | grep -c .)

if [ "$COUNT" -gt 0 ]; then
  echo "⚠️ Found $COUNT suspicious link(s):"
  echo
  echo "$SUSPICIOUS_LINKS"
else
  echo "✅ No suspicious links found."
fi

[ "$DRY_RUN" == "--dry-run" ] && echo "- Mode: DRY-RUN (preview only)"
