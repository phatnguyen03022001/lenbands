#!/usr/bin/env bash
set -euo pipefail
script_dir="$(cd "$(dirname "$0")" && pwd)"
ruby "$script_dir/implementation-catalog.rb" "$@"
