#!/usr/bin/env bash
# obtener-imagen.sh — descarga una imagen SOLO si viene de un dominio oficial
# de Rockstar. Si no, falla. Este es el candado que impide que el agente
# publique material de terceros o filtrado.
#
# Uso:
#   bash scripts/obtener-imagen.sh "https://media-rockstargames-com.akamaized.net/.../foto.jpg"
#
# Imprime la ruta local del archivo descargado, o falla con código != 0.

set -euo pipefail

URL="${1:-}"
DESTINO_DIR="tmp-imagenes"

if [[ -z "$URL" ]]; then
  echo "ERROR: uso -> bash scripts/obtener-imagen.sh \"URL_de_la_imagen\"" >&2
  exit 1
fi

# ---- CANDADO 1: dominio ----
# Solo estos hosts. Cualquier otro se rechaza sin excepción.
DOMINIOS_PERMITIDOS=(
  "rockstargames.com"
  "www.rockstargames.com"
  "media-rockstargames-com.akamaized.net"
)

HOST=$(echo "$URL" | sed -E 's#^https?://([^/]+).*#\1#')

PERMITIDO=0
for d in "${DOMINIOS_PERMITIDOS[@]}"; do
  if [[ "$HOST" == "$d" ]]; then
    PERMITIDO=1
    break
  fi
done

if [[ $PERMITIDO -eq 0 ]]; then
  echo "RECHAZADO: '$HOST' no es un dominio oficial de Rockstar." >&2
  echo "Solo se permiten: ${DOMINIOS_PERMITIDOS[*]}" >&2
  echo "Publica este post como ENLACE en vez de con foto." >&2
  exit 3
fi

# ---- CANDADO 2: que sea imagen de verdad ----
EXT="${URL##*.}"
EXT="${EXT%%\?*}"
EXT=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')

case "$EXT" in
  jpg|jpeg|png|webp) ;;
  *)
    echo "RECHAZADO: extensión '$EXT' no es una imagen soportada (jpg, jpeg, png, webp)." >&2
    exit 4
    ;;
esac

# ---- Descargar ----
mkdir -p "$DESTINO_DIR"
NOMBRE="$DESTINO_DIR/$(date +%s)-$(basename "${URL%%\?*}")"

if ! curl -sSL --max-time 30 -o "$NOMBRE" "$URL"; then
  echo "ERROR: falló la descarga de $URL" >&2
  exit 5
fi

# ---- CANDADO 3: tamaño razonable ----
TAM=$(stat -c%s "$NOMBRE" 2>/dev/null || echo 0)

if (( TAM < 20000 )); then
  echo "RECHAZADO: el archivo pesa ${TAM} bytes. Probablemente es un logo, un" >&2
  echo "icono o una miniatura, no una captura. Publica como ENLACE." >&2
  rm -f "$NOMBRE"
  exit 6
fi

if (( TAM > 8000000 )); then
  echo "RECHAZADO: el archivo pesa ${TAM} bytes (más de 8 MB)." >&2
  rm -f "$NOMBRE"
  exit 7
fi

echo "$NOMBRE"
