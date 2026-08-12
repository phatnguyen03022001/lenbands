#!/usr/bin/env bash
set -euo pipefail

# Deprecated compatibility entry point.
#
# This command used to rewrite the canonical capability-family map and promotion
# policy with hard-coded case statements. That duplicated business knowledge and
# violated the frozen authority boundary, so it now fails closed. Keeping this
# short shim protects old invocations while making the replacement explicit.

echo "tools/generate-capability-registries.sh is deprecated and intentionally disabled." >&2
echo "Use tools/generate-lifecycle-registry.sh to render lifecycle only." >&2
echo "Edit capability-family-map.yaml, promotion-dependency-facts.yaml, and promotion-policy.yaml through their owners, then run tools/verify.sh." >&2
exit 64
