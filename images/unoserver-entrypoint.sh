#!/bin/sh

set -e

exec unoserver \
  --interface "${UNOSERVER_INTERFACE:-0.0.0.0}" \
  --port "${UNOSERVER_PORT:-2003}" \
  --conversion-timeout "${UNOSERVER_CONVERSION_TIMEOUT:-120}"
