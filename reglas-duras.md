# REGLAS DURAS — Constitución de la página

> **CAPA 1. Ningún agente puede editar este archivo.**
> Solo Giovani lo modifica a mano. Si un agente propone cambiar algo de aquí,
> debe escribirlo en `propuestas.md`, nunca tocar este documento.

**Página:** GTA 6 Online, Eastereggs, Historia
**Público:** hispanohablantes de Latinoamérica (México, Colombia, Argentina, Chile, Perú)
**Cadencia:** exactamente 2 publicaciones por día. Nunca 3. Nunca más.

---

## 1. PROHIBICIONES ABSOLUTAS

Estas no se negocian. Si hay duda, no se publica.

1. **NADA de material filtrado.** Ni gameplay filtrado, ni capturas de builds
   robados, ni assets de "CyberLeek" ni de ninguna filtración. Take-Two ya
   inició acciones legales por la difusión de este material. Publicarlo puede
   costar la página completa.

2. **NADA de enlaces de descarga.** Existe una ola activa de malware que se
   distribuye como "GTA 6 para PC". Jamás enlazar a sitios de descarga, APKs,
   torrents, "versiones jugables" ni nada parecido.

3. **NADA de criptomonedas ni promociones.** Parte del material filtrado se usó
   para promover una cripto. Cero contenido de ese tipo.

4. **SOLO se descargan imágenes de dominios oficiales de Rockstar**, y siempre
   a través de `scripts/obtener-imagen.sh`, que lo verifica automáticamente.
   Dominios permitidos: `rockstargames.com`, `www.rockstargames.com`,
   `media-rockstargames-com.akamaized.net`. Ningún otro, por ninguna razón.
   Si el script rechaza una imagen, se publica como *link post*. **No se busca
   una fuente alterna.**

5. **PROHIBIDO poner marca de agua sobre imagen ajena.** No protege de nada y
   agrega un problema legal encima del que ya había. Si la imagen no es oficial,
   la solución es no subirla, no marcarla.

6. **NO inventar información.** Si no hay fuente verificable, no se publica.
   Cero "según fuentes internas" sin enlace real.

7. **NO clickbait mentiroso.** Titular llamativo, sí. Titular que promete algo
   que el artículo no tiene, no. Eso mata el alcance a mediano plazo.

## 2. ETIQUETADO OBLIGATORIO

Todo post debe caer en una de estas tres categorías y decirlo:

| Etiqueta | Cuándo se usa |
|---|---|
| `CONFIRMADO` | Fuente oficial: Rockstar, Take-Two, Newswire, tráiler |
| `REPORTE` | Medio serio con periodista identificado (Bloomberg, IGN, Eurogamer) |
| `ESPECULACIÓN` | Teoría de comunidad, análisis de tráiler, rumor |

**Regla crítica:** todo contenido de "GTA 6 Online" es `ESPECULACIÓN` hasta nuevo
aviso. Rockstar confirmó que el lanzamiento del 19 de noviembre de 2026 será
estrictamente una experiencia para un solo jugador. No existe GTA 6 Online aún.

## 3. IDIOMA Y TONO

- Se busca en **todos los idiomas**, principalmente inglés. Se publica **solo
  en español latinoamericano**.
- Traducción **adaptada, no literal**. Nada de "esto es un game changer" ni
  calcos del inglés. Español neutro latino, entendible de México a Argentina.
- Sin regionalismos cerrados: nada de "chido", "guay", "chévere", "boludo".
  Neutro.
- Nunca dejar términos sin traducir salvo los propios del juego:
  *Vice City*, *Leonida*, *Rockstar*, *Easter egg*, *Newswire*, nombres de personajes.

## 4. FORMATO DE PUBLICACIÓN

- **Preferir foto** con imagen del banco oficial. Facebook da más alcance a las
  fotos nativas que a los enlaces.
- **Enlace como respaldo** cuando ninguna imagen del banco empate.
- **Longitud libre, según lo que pida la noticia.** Una nota con sustancia puede
  llevar varios párrafos; una confirmación corta va corta. Sin relleno para
  alargar ni recortes que dejen fuera lo importante.
- Máximo 5 hashtags al final. Siempre incluir `#GTA6`.
- Siempre acreditar la fuente por nombre dentro del texto ("según IGN...").
- Terminar con una pregunta abierta al público solo en posts de
  `ESPECULACIÓN`. En `CONFIRMADO` no hace falta.

## 5. LA REGLA MÁS IMPORTANTE

**Si en una corrida no hay nada que valga la pena, NO SE PUBLICA.**

Es preferible un día con 1 post o con 0 que un post de relleno. El relleno
entrena al algoritmo de Facebook para no mostrar tu página. Un día en silencio
no te cuesta nada. Una semana de relleno sí.

El agente debe registrar en el log: `SIN PUBLICAR — no hubo material que superara
el umbral` y seguir adelante sin inventar contenido.

## 6. LÍMITES TÉCNICOS

- Nunca publicar la misma URL dos veces (revisar `datos/publicados.json`).
- Nunca publicar dos notas del mismo tema en menos de 72 horas.
- Si el script de publicación falla, registrar el error y **no reintentar más de
  2 veces**. Nunca publicar en bucle.
