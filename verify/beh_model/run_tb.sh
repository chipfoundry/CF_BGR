#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${TMPDIR:-/tmp}/cf_bgr_tb"
iverilog -g2005 -o "$OUT" \
  "$ROOT/hdl/gl/CF_BGR.v" \
  "$ROOT/verify/beh_model/CF_BGR_core.v" \
  "$ROOT/verify/beh_model/tb_CF_BGR.v"
vvp "$OUT"
