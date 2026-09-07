#!/usr/bin/env bash
# publicar.sh — publica en la página de Facebook
#
# MODO FOTO (preferido — más alcance):
#   bash scripts/publicar.sh foto "texto" "imagenes/archivo.jpg" "2026-09-01 13:00"
#
# MODO ENLACE (respaldo — cuando no hay imagen oficial que empate):
#   bash scripts/publicar.sh enlace "texto" "https://fuente.com" "2026-09-01 13:00"
#
# El cuarto argumento (fecha) es opcional. Sin él publica de inmediato.
#
# Requiere en el entorno: FB_PAGE_TOKEN, FB_PAGE_ID
# NO existe archivo .env en el entorno de nube. No lo busques.

set -euo pipefail

API_VERSION="v25.0"
MODO="${1:-}"
MENSAJE="${2:-}"
RECURSO="${3:-}"
CUANDO="${4:-}"

if [[ -z "$MODO" || -z "$MENSAJE" || -z "$RECURSO" ]]; then
  echo "ERROR: uso -> bash scripts/publicar.sh {foto|enlace} \"mensaje\" \"recurso\" [\"YYYY-MM-DD HH:MM\"]" >&2
  exit 1
fi

if [[ "$MODO" != "foto" && "$MODO" != "enlace" ]]; then
  echo "ERROR: el primer argumento debe ser 'foto' o 'enlace'. Recibí: '$MODO'" >&2
  exit 1
fi

for v in FB_PAGE_TOKEN FB_PAGE_ID; do
  if [[ -z "${!v:-}" ]]; then
    echo "ERROR: falta $v en las variables de entorno del Cloud Environment." >&2
    exit 1
  fi
done

# --- Resolver programación ---
TS=""
if [[ -n "$CUANDO" ]]; then
  TS=$(date -u -d "$CUANDO America/Mexico_City" +%s 2>/dev/null || true)
  if [[ -z "$TS" ]]; then
    echo "ERROR: no pude interpretar la fecha '$CUANDO'. Formato: YYYY-MM-DD HH:MM" >&2
    exit 1
  fi
  MARGEN=$(( TS - $(date -u +%s) ))
  if (( MARGEN < 900 )); then
    echo "AVISO: '$CUANDO' está a menos de 15 min o ya pasó. Publico de inmediato." >&2
    TS=""
  fi
fi

# --- Publicar ---
if [[ "$MODO" == "foto" ]]; then

  if [[ ! -f "$RECURSO" ]]; then
    echo "ERROR: no existe el archivo de imagen '$RECURSO'." >&2
    echo "Revisa imagenes/catalogo.json — el nombre debe coincidir exacto." >&2
    exit 3
  fi

  ARGS=( -F "caption=$MENSAJE" -F "source=@$RECURSO" -F "access_token=$FB_PAGE_TOKEN" )
  if [[ -n "$TS" ]]; then
    ARGS+=( -F "published=false" -F "scheduled_publish_time=$TS" )
    DESC="foto programada para $CUANDO (CDMX)"
  else
    DESC="foto publicada de inmediato"
  fi
  RESPUESTA=$(curl -sS -X POST "https://graph.facebook.com/${API_VERSION}/${FB_PAGE_ID}/photos" "${ARGS[@]}")

else

  ARGS=( -d "message=$MENSAJE" -d "link=$RECURSO" -d "access_token=$FB_PAGE_TOKEN" )
  if [[ -n "$TS" ]]; then
    ARGS+=( -d "published=false" -d "scheduled_publish_time=$TS" )
    DESC="enlace programado para $CUANDO (CDMX)"
  else
    DESC="enlace publicado de inmediato"
  fi
  RESPUESTA=$(curl -sS -X POST "https://graph.facebook.com/${API_VERSION}/${FB_PAGE_ID}/feed" "${ARGS[@]}")

fi

# --- Resultado ---
if echo "$RESPUESTA" | grep -q '"error"'; then
  echo "FALLO ($DESC):" >&2
  echo "$RESPUESTA" >&2
  exit 2
fi

POST_ID=$(echo "$RESPUESTA" | sed -n 's/.*"post_id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')
[[ -z "$POST_ID" ]] && POST_ID=$(echo "$RESPUESTA" | sed -n 's/.*"id"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

echo "OK — $DESC"
echo "post_id: $POST_ID"
