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

4. **NO re-subir imágenes ni videos de terceros.** Se publica como *link post*:
   Facebook genera la miniatura automáticamente y acredita a la fuente. Solo se
   suben archivos si vienen del Newswire oficial de Rockstar.

5. **NO inventar información.** Si no hay fuente verificable, no se publica.
   Cero "según fuentes internas" sin enlace real.

6. **NO clickbait mentiroso.** Titular llamativo, sí. Titular que promete algo
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

- **Siempre link post** (mensaje + URL). Facebook arma la tarjeta con imagen.
- Longitud del texto: **40 a 90 palabras**. Ni tuit ni ensayo.
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
