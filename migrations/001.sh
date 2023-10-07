#!/usr/bin/env bash

jq_query=$(cat <<'EOF'
    .from_year = .fromYear | del(.fromYear) |
    .to_year = .toYear | del(.toYear) | del(.to_year | nulls) |
    .files = [.files[] | .filename = .fileName | del(.fileName)] |
    .files = [.files[] | .media_type = .mediaType | del(.mediaType)] |
    .files = [.files[] | .source_url = .sourceUrl | del(.sourceUrl)] |
    .version = 2
EOF
)

export jq_query

function rewrite {
    jq "$jq_query" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

export -f rewrite

find ./submissions/ -type f -name '*.json' -exec bash -c 'rewrite "$@"' bash "{}" \;
