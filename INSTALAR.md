# INSTALAR — guía operativa paso a paso

> `SETUP.md` explica **por qué** cada cosa.
> Este archivo es el **orden exacto de ejecución**. Síguelo de arriba a abajo sin saltarte nada.
> Tiempo real: unos 90 minutos.

---

# ANTES DE EMPEZAR — requisitos

Verifica que tienes las tres cosas. Si falta una, no sigas.

| Requisito | Cómo lo compruebas |
|---|---|
| Plan Claude **Pro, Max, Team o Enterprise** | Las Routines no existen en el plan gratuito |
| Cuenta de **GitHub** | Las Routines solo clonan repos de GitHub |
| Ser **administrador** de la página de Facebook | No editor, no moderador. Administrador. |

Ten a la mano los archivos descargados. Son 12.

---

# BLOQUE 1 — Armar el repositorio (20 min)

## 1.1 Crear el repo

1. Entra a https://github.com/new
2. Nombre: `gta6-agente`
3. Marca **Private**
4. Marca **Add a README file**
5. Click en **Create repository**

## 1.2 Subir los archivos normales

En tu repo: botón **Add file** → **Upload files**.

Arrastra estos 6, todos juntos:

```
SETUP.md
INSTALAR.md
reglas-duras.md
reglas-editoriales.md
fuentes.md
propuestas.md
```

Abajo escribe `estructura inicial` y click en **Commit changes**.

## 1.3 Crear las carpetas con archivos dentro

GitHub no deja crear carpetas vacías. Se crean escribiendo la ruta completa al
crear el archivo. Repite este procedimiento **7 veces**, una por archivo:

> **Add file** → **Create new file** → en el campo del nombre escribe la ruta
> completa (incluyendo las diagonales) → pega el contenido → **Commit changes**

| # | Ruta que escribes en el campo del nombre | Contenido que pegas |
|---|---|---|
| 1 | `prompts/agente-a-publicador.md` | el del archivo descargado |
| 2 | `prompts/agente-b-analista.md` | idem |
| 3 | `scripts/publicar.sh` | idem |
| 4 | `datos/publicados.json` | solo esto: `[]` |
| 5 | `datos/bitacora.md` | idem |
| 6 | `reportes/README.md` | idem |
| 7 | `.claude/agents/rastreador-prensa.md` | idem |
| 8 | `.claude/agents/rastreador-comunidad.md` | idem |

> **Ojo con las dos últimas.** La carpeta empieza con **punto** (`.claude`). Si
> intentas subirlas arrastrando, tu sistema operativo las oculta y no aparecen en
> el selector. **Por eso hay que escribirlas a mano** con el método de arriba.
> Escribe exactamente: `.claude/agents/rastreador-prensa.md`

## 1.4 Verificar la estructura

Tu repo debe verse así. Si falta algo, vuelve al 1.3:

```
gta6-agente/
├─ .claude/
│  └─ agents/
│     ├─ rastreador-prensa.md
│     └─ rastreador-comunidad.md
├─ datos/
│  ├─ bitacora.md
│  └─ publicados.json
├─ prompts/
│  ├─ agente-a-publicador.md
│  └─ agente-b-analista.md
├─ reportes/
│  └─ README.md
├─ scripts/
│  └─ publicar.sh
├─ INSTALAR.md
├─ SETUP.md
├─ fuentes.md
├─ propuestas.md
├─ reglas-duras.md
└─ reglas-editoriales.md
```

> **Nota técnica:** al subir por la web, `publicar.sh` no queda marcado como
> ejecutable. No importa — el prompt del Agente A ya lo invoca con
> `bash scripts/publicar.sh`, que funciona igual.

---

# BLOQUE 2 — Token de Facebook (40 min)

Este es el bloque que más se atora. Ve despacio.

## 2.1 Crear la app

1. https://developers.facebook.com → **My Apps** → **Create App**
2. Tipo: **Business**
3. Nombre: `Agente GTA6`
4. Vincula tu página cuando te lo pida
5. Anota tu **App ID** y tu **App Secret** (Settings → Basic)

## 2.2 Generar el token de usuario corto

1. Ve a https://developers.facebook.com/tools/explorer/
2. Arriba a la derecha, selecciona tu app `Agente GTA6`
3. En **Permissions**, agrega las tres:
   ```
   pages_show_list
   pages_read_engagement
   pages_manage_posts
   ```
4. Click en **Generate Access Token** → acepta
5. Copia el token. **Este dura 1 hora**, no lo uses todavía.

## 2.3 Convertirlo en token largo

En la misma barra del Explorer, cambia el método a **GET** y pega esta ruta
(reemplazando lo que va entre llaves, sin las llaves):

```
/oauth/access_token?grant_type=fb_exchange_token&client_id={TU_APP_ID}&client_secret={TU_APP_SECRET}&fb_exchange_token={TOKEN_DEL_2.2}
```

Click en **Submit**. Copia el `access_token` de la respuesta.

## 2.4 Obtener el token de página

Pega ese token largo en el campo de token del Explorer, y consulta:

```
/me/accounts
```

En la respuesta busca tu página. Anota **dos cosas**:
- `id` → este es tu **FB_PAGE_ID**
- `access_token` → este es tu **FB_PAGE_TOKEN**

## 2.5 Comprobar que no expira

1. Ve a https://developers.facebook.com/tools/debug/accesstoken/
2. Pega el **FB_PAGE_TOKEN**
3. En **Expires** debe decir **Never**

Si dice una fecha, te equivocaste de token en algún paso. Regresa al 2.3.

## 2.6 Pasar la app a modo Live

En el panel de tu app, arriba, mueve el switch de **Development** a **Live**.

Si te pide categoría o política de privacidad, llénalo con lo mínimo. No
necesitas App Review — eso solo aplica para publicar en páginas de terceros.

## 2.7 Prueba real (NO te saltes esto)

Desde cualquier terminal (tu compu, o Google Cloud Shell si no tienes):

```bash
curl -X POST "https://graph.facebook.com/v25.0/TU_PAGE_ID/feed" \
  -d "message=Prueba de conexión." \
  -d "link=https://www.rockstargames.com/newswire" \
  -d "access_token=TU_PAGE_TOKEN"
```

**Si responde con un `id`:** entra a tu página **desde el celular, con sesión
cerrada o en incógnito**. ¿Ves el post? Perfecto. Bórralo.

**Si NO lo ves con sesión cerrada:** la app sigue en Development. Repite el 2.6.

**Si responde `#10 API Permission Denied`:** falta `pages_manage_posts` o la app
está en Development. Repite 2.2 y 2.6.

> No sigas al bloque 3 hasta que esta prueba pase. Todo lo demás depende de esto.

---

# BLOQUE 3 — Conectar GitHub a Claude (10 min)

1. Instala o actualiza Claude Code:
   ```bash
   npm install -g @anthropic-ai/claude-code
   claude update
   ```
2. Inicia sesión con tu cuenta de claude.ai
3. Dentro de una sesión de Claude Code, ejecuta:
   ```
   /web-setup
   ```
   Esto concede el acceso de clonado que las Routines necesitan. **Sin este paso
   las routines no pueden leer tu repo.**

> Si no quieres instalar nada, puedes autorizar GitHub desde la interfaz web al
> crear la routine en el bloque 4. El `/web-setup` es el camino más directo.

---

# BLOQUE 4 — Routine del Agente A (15 min)

## 4.1 Crear

1. Ve a **https://claude.ai/code/routines**
2. Click en **New routine** → elige **Cloud**
   > Si eliges **Local**, corre en tu máquina y solo funciona con la compu
   > encendida. Tiene que ser **Cloud**.

## 4.2 Llenar el formulario

| Campo | Valor |
|---|---|
| Nombre | `GTA6 — Publicador diario` |
| Repositorio | `gta6-agente` |
| Prompt | Pega **todo** el contenido de `prompts/agente-a-publicador.md` |
| Trigger | Schedule → Diario → **07:00** → `America/Mexico_City` |

## 4.3 Variables de entorno

En **Cloud Environment** → variables:

| Nombre | Valor |
|---|---|
| `FB_PAGE_TOKEN` | el token del paso 2.4 |
| `FB_PAGE_ID` | el id del paso 2.4 |

## 4.4 Acceso de red

En **Cloud Environment** → Network access → elige **Custom** y pega:

```
graph.facebook.com
rockstargames.com
ign.com
eurogamer.net
gamespot.com
videogameschronicle.com
pcgamer.com
polygon.com
theverge.com
kotaku.com
gamesradar.com
reddit.com
gtaforums.com
gta.fandom.com
```

> **Custom, no Full.** Si el agente lee una página maliciosa que intenta hacerlo
> mandar datos a otro servidor, Custom lo bloquea. Full no.

## 4.5 Guardar

---

# BLOQUE 5 — Routine del Agente B (10 min)

Mismo procedimiento:

| Campo | Valor |
|---|---|
| Nombre | `GTA6 — Analista semanal` |
| Repositorio | `gta6-agente` |
| Prompt | Todo el contenido de `prompts/agente-b-analista.md` |
| Trigger | Schedule → Semanal → **Domingo 09:00** → `America/Mexico_City` |
| Variables | Las mismas dos (`FB_PAGE_TOKEN`, `FB_PAGE_ID`) |
| Red | **Custom**, solo `graph.facebook.com` |

---

# BLOQUE 6 — Primera corrida supervisada (30 min)

**No esperes al día siguiente.** Dispárala tú ahora, despierto.

1. En `claude.ai/code/routines`, abre `GTA6 — Publicador diario`
2. Click en **Run now**
3. Observa la sesión en vivo. Deberías ver:
   - Lee los archivos de reglas
   - Lanza los dos rastreadores **en paralelo** (no uno tras otro)
   - Filtra y elige
   - Escribe los textos
   - Llama a `bash scripts/publicar.sh` dos veces
   - Hace commit de `publicados.json`

4. **Revisa el resultado en Meta Business Suite** → Publicaciones programadas.
   Los posts están en cola para las 13:00 y 20:00, todavía no publicados.
   **Ahí tienes tu ventana para borrarlos si algo salió mal.**

## Qué revisas específicamente

- [ ] ¿El español suena natural o a traducción de Google?
- [ ] ¿Etiquetó bien lo que es `ESPECULACIÓN`?
- [ ] ¿La miniatura del enlace se ve bien?
- [ ] ¿Publicó algo de filtraciones? (si sí, **detén todo y avísame**)
- [ ] ¿`datos/publicados.json` tiene las 2 entradas?

---

# BLOQUE 7 — Los primeros 7 días

**Revisa una vez al día**, en la mañana, antes de las 13:00.

**No cambies el prompt cada vez que veas algo raro.** Anota los problemas en una
nota. Al séptimo día haces **un solo ajuste bien pensado** en vez de siete
parches que se contradicen entre sí.

**Semana 4:** el Agente B empieza a tener datos suficientes. Antes de eso te va a
reportar que la muestra es insuficiente — eso está bien, no es una falla, es el
filtro de honestidad haciendo su trabajo.

---

# APAGADO DE EMERGENCIA

Si algo se sale de control:

1. **Pausa la routine** en `claude.ai/code/routines` (switch de Active a Paused)
2. **Borra los posts en cola** en Meta Business Suite → Publicaciones programadas
   > Pausar la routine **no cancela** lo que ya está programado en Facebook.
   > Son dos sistemas distintos. Hay que hacer las dos cosas.
3. Si necesitas cortar de raíz: revoca el token en
   https://www.facebook.com/settings?tab=business_tools

---

# PROBLEMAS COMUNES

| Síntoma | Causa | Solución |
|---|---|---|
| `#10 API Permission Denied` | App en Development o falta permiso | Bloques 2.2 y 2.6 |
| Los posts no los ve nadie | App en Development Mode | Bloque 2.6 |
| El token dejó de servir | Usaste el token de usuario, no el de página | Bloque 2.4 |
| La routine no encuentra el repo | Falta `/web-setup` | Bloque 3 |
| No encuentra los rastreadores | La carpeta `.claude/agents/` está mal | Bloque 1.3 |
| `command not found: ./scripts/publicar.sh` | Falta el bit de ejecución | Ya está resuelto: se invoca con `bash` |
| La routine no corrió | Cuota agotada | Las routines consumen del mismo límite de tu cuenta. Revisa `claude.ai/settings/usage` |
| Corrió tarde | Normal | Las routines arrancan con unos minutos de desfase, consistente por routine |
| Publicó repetido | `publicados.json` no se commiteó | Revisa el historial de commits del repo |
