#!/bin/sh
set -e

export MERIDIAN_PORT="${MERIDIAN_PORT:-${PORT:-3456}}"

exec meridian "$@"
