#!/usr/bin/env bash

# update dates only for staged markdown files in content/

set -euo pipefail

# Get staged markdown files inside content/
files=$(git diff --cached --name-only --diff-filter=ACM | grep '^content/.*\.md$' || true)

if [[ -z "$files" ]]; then
  echo "No staged markdown files in content/, skipping."
  exit 0
fi

echo "Updating dates for staged files..."

for file in $files; do
  # Skip if file was deleted or doesn't exist
  [[ -f "$file" ]] || continue

  # Get last commit date (fallback to today if no history yet)
  git_date=$(git log -1 --date=format:'%Y-%m-%d' --format="%cd" -- "$file" 2>/dev/null || date +%F)

  if head -n 1 "$file" | grep -q "^---"; then
    if grep -q "^date:" "$file"; then
      echo "Updating date in $file"
      sed -i "0,/^date:/s/^date:.*/date: $git_date/" "$file"
    else
      echo "Adding date to frontmatter in $file"
      awk -v d="$git_date" '
        NR==1 { print; print "date: " d; next }
        { print }
      ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    fi
  else
    echo "Adding frontmatter + date to $file"
    {
      echo "---"
      echo "date: $git_date"
      echo "---"
      echo
      cat "$file"
    } > "$file.tmp" && mv "$file.tmp" "$file"
  fi

  # Re-stage the file after modification
  git add "$file"
done

echo "Done updating dates."
