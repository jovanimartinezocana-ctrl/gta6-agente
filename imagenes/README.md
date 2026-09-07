# IMÁGENES

**No tienes que armar nada aquí.** El agente descarga las imágenes solo, en cada
corrida, desde fuentes oficiales de Rockstar.

## Cómo funciona

1. El agente busca la imagen que empate con el tema del post, en:
   - El artículo del Newswire de donde salió la nota
   - `rockstargames.com/VI/media/screenshots` (99 capturas oficiales de GTA 6,
     más 51 de Ultimate Edition y 12 de Vintage Vice City)
   - `rockstargames.com/VI`

2. La descarga **siempre** con `scripts/obtener-imagen.sh`, que aplica tres
   candados:
   - **Dominio:** solo `rockstargames.com`, `www.rockstargames.com` y
     `media-rockstargames-com.akamaized.net`. Cualquier otro se rechaza.
   - **Tipo:** solo jpg, jpeg, png, webp.
   - **Tamaño:** entre 20 KB y 8 MB. Descarta logos, iconos y miniaturas.

3. Si algún candado se activa, el agente **publica ese post como enlace** en vez
   de con foto. No busca una fuente alterna.

4. Registra lo usado en `catalogo.json` para no repetir imagen.

## Qué contiene esta carpeta

| Archivo | Para qué |
|---|---|
| `catalogo.json` | Memoria de imágenes ya usadas. Lo llena el agente. |
| `README.md` | Esto. |
| `tmp-imagenes/` | Descargas temporales de cada corrida. No se commitea. |

## Si quieres acelerar las cosas (opcional)

Rockstar ofrece las 99 capturas de GTA 6 **como archivo ZIP** en
`rockstargames.com/VI/media/screenshots`. Puedes descargarlo, subir las que más
te gusten a esta carpeta, y registrarlas en `catalogo.json` con sus temas.

El agente las prefiere sobre descargar, porque ya vienen etiquetadas por ti.
No es necesario, pero mejora la puntería en la elección de imagen.
