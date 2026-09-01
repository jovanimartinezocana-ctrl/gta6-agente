#!/usr/bin/env bash
# publicar.sh — publica o programa un link post en la página de Facebook
#
# Uso:
#   ./publicar.sh "texto del post" "https://url-fuente.com"                      -> publica ya
#   ./publicar.sh "texto del post" "https://url-fuente.com" "2026-09-01 13:00"   -> programa
#
# Requiere en el entorno:
#   FB_PAGE_TOKEN  - token de página de larga duración
#   FB_PAGE_ID     - ID numérico de la página
#
# Ambos se configuran en el panel Cloud Environment de la Routine.
# NO existe archivo .env en el entorno de nube. No lo busques.

set -euo pipefail

API_VERSION="v25.0"
MENSAJE="${1:-}"
ENLACE="${2:-}"
CUANDO="${3:-}"

if [[ -z "$MENSAJE" || -z "$ENLACE" ]]; then
  echo "ERROR: uso -> ./publicar.sh \"mensaje\" \"url\" [\"YYYY-MM-DD HH:MM\"]" >&2
  exit 1
fi

if [[ -z "${FB_PAGE_TOKEN:-}" ]]; then
  echo "ERROR: falta FB_PAGE_TOKEN en las variables de entorno." >&2
  exit 1
fi

if [[ -z "${FB_PAGE_ID:-}" ]]; then
  echo "ERROR: falta FB_PAGE_ID en las variables de entorno." >&2
  exit 1
fi

ENDPOINT="https://graph.facebook.com/${API_VERSION}/${FB_PAGE_ID}/feed"

if [[ -n "$CUANDO" ]]; then
  # --- POST PROGRAMADO ---
  # Facebook exige que el timestamp esté al menos 10 minutos en el futuro.
  # El límite superior varía segun la documentacion (30 dias / 6 meses):
  # nos mantenemos muy por debajo, siempre el mismo dia.
  TS=$(date -u -d "$CUANDO America/Mexico_City" +%s 2>/dev/null || true)

  if [[ -z "$TS" ]]; then
    echo "ERROR: no pude interpretar la fecha '$CUANDO'. Formato: YYYY-MM-DD HH:MM" >&2
    exit 1
  fi

  AHORA=$(date -u +%s)
  MARGEN=$(( TS - AHORA ))

  if (( MARGEN < 900 )); then
    echo "AVISO: '$CUANDO' está a menos de 15 min (o ya pasó). Publicando de inmediato." >&2
    CUANDO=""
  fi
fi

if [[ -n "$CUANDO" ]]; then
  RESPUESTA=$(curl -sS -X POST "$ENDPOINT" \
    -d "message=$MENSAJE" \
    -d "link=$ENLACE" \
    -d "published=false" \
    -d "scheduled_publish_time=$TS" \
    -d "access_token=$FB_PAGE_TOKEN")
  MODO="programado para $CUANDO (CDMX)"
else
  RESPUESTA=$(curl -sS -X POST "$ENDPOINT" \
    -d "message=$MENSAJE" \
    -d "link=$ENLACE" \
    -d "access_token=$FB_PAGE_TOKEN")
  MODO="publicado de inmediato"
fi

# --- Manejo de resultado ---
if echo "$RESPUESTA" | grep -q '"error"'; then
  echo "FALLO ($MODO):" >&2
  echo "$RESPUESTA" >&2
  exit 2
fi

POST_ID=$(echo "$RESPUESTA" | sed -n 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
echo "OK — $MODO"
echo "post_id: $POST_ID"
