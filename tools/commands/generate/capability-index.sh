#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$repo_root"

output="artifacts/operations/catalogs/capability-index.md"
check=false
if [[ "${1:-}" == "--check" ]]; then
  check=true
  shift
fi
if [[ $# -ne 0 ]]; then
  echo "usage: $0 [--check]" >&2
  exit 64
fi

# Keep a generated projection byte-stable when its source has not changed. The
# timestamp records the last content render, rather than making every check stale.
generated_at="$(sed -n 's/^- `generated_at`: `\(.*\)`$/\1/p' "$output" 2>/dev/null | head -n 1)"
[[ -n "$generated_at" ]] || generated_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
temp_root="${TMPDIR:-/tmp}"
rendered="$(mktemp "${temp_root%/}/lenbands-capability-index.XXXXXX")"
trap 'rm -f "$rendered"' EXIT

{
  printf '%s\n\n' '# Capability Index (generated)'
  printf '%s\n\n' 'This is a read-only projection of the Blueprint Capability Catalog; do not edit it manually and do not treat it as a replacement for `blueprint/03-features.md`.'
  printf '%s\n' '- `generated_from`: `blueprint/03-features.md`'
  printf '%s\n' "- \`generated_at\`: \`${generated_at}\`"
  printf '%s\n\n' '- `schema_version`: `1`'
  printf '%s\n' '| Capability ID |'
  printf '%s\n' '|---|'
  rg -o '`[A-Z][A-Z0-9_]*\.[A-Za-z][A-Za-z0-9_]*`' blueprint/03-features.md \
    | tr -d '`' \
    | rg -v '^DOMAIN\.Capability$' \
    | sort -u \
    | sed 's/^/| `/;s/$/` |/'
} > "$rendered"

if $check; then
  if cmp -s "$rendered" "$output"; then
    printf '%s is current\n' "$output"
  else
    printf '%s is stale; run tools/generate-capability-index.sh\n' "$output" >&2
    exit 1
  fi
elif cmp -s "$rendered" "$output"; then
  printf '%s unchanged\n' "$output"
else
  mv "$rendered" "$output"
  trap - EXIT
  printf 'generated %s\n' "$output"
fi
