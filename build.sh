#!/bin/bash

mkdir -p public
base_url="https://fkkarakurt.github.io"

for file in posts/*.md; do
  filename=$(basename "$file" .md)
  cmark --unsafe "$file" > tmp_content.html
  title=$(grep -m1 '^# ' "$file" | sed 's/^# //')
  description=$(sed -n 's/^description: \(.*\)$/\1/p' "$file" | head -n1)
  if [ -z "$description" ]; then
    description=$(sed -n '/^# /,$p' "$file" | sed '1d' | grep -v '^$' | head -n 3 | tr '\n' ' ' | cut -c1-160)
  fi
  url="$base_url/public/$filename.html"

  sed -e "/CONTENT_HERE/ {
    r tmp_content.html
    d
  }" \
  -e "s/___TITLE_HERE___/$title/g" \
  -e "s|description_meta.|$description|g" \
  -e "s|https://fkkarakurt.github.io/path-to-article.html|$url|g" \
  -e "s|summary.|$description|g" \
  template.html > public/"$filename".html

  sed -i '/<h[1-6]>description:.*<\/h[1-6]>/Id' public/"$filename".html

done

rm -f tmp_content.html
