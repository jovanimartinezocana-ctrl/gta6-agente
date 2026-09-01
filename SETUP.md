# SETUP — de cero a publicando

Tiempo estimado: **90 minutos**, una sola vez.

---

## PARTE 1 — App de Facebook y token (45 min)

Como la página es tuya y tú administras la app, **no necesitas App Review ni
verificación de negocio**. Publicar en páginas que tu propia cuenta de
desarrollador administra funciona con Standard Access; la revisión solo hace
falta para publicar en páginas de terceros.

### 1.1 Crear la app
1. Entra a https://developers.facebook.com → **My Apps** → **Create App**
2. Tipo: **Business**
3. Nombre: `Agente GTA6` (o el que quieras)
4. Vincula la app a tu página

### 1.2 Obtener el token de página que no expira

Son 3 pasos encadenados. En el **Graph API Explorer**:

**Paso A — token de usuario corto**
Selecciona tu app, y en permisos agrega:
```
pages_show_list
pages_read_engagement
pages_manage_posts
```
Click en *Generate Access Token*. Copia el resultado.

**Paso B — convertirlo en token largo**
```
GET /oauth/access_token
  ?grant_type=fb_exchange_token
  &client_id={TU_APP_ID}
  &client_secret={TU_APP_SECRET}
  &fb_exchange_token={TOKEN_DEL_PASO_A}
```

**Paso C — obtener el token de página**
Con el token largo del paso B:
```
GET /me/accounts
```
Ahí sale tu página con su `id` y su `access_token`. **Ese token de página no
expira.** Guarda los dos valores.

### 1.3 Verificar que no expira
Pega el token en https://developers.facebook.com/tools/debug/accesstoken/
En "Expires" debe decir **Never**. Si dice una fecha, repite el paso B.

### 1.4 Poner la app en modo Live
En el panel de la app, pasa de *Development* a **Live**.

> **Por qué importa:** si la app se queda en modo Development, existe el riesgo
> de que tus posts solo sean visibles para ti y los admins de la app. Live Mode
> por sí solo no requiere revisión de Meta — la revisión es para Advanced Access.

### 1.5 Prueba manual (no te saltes esto)
```bash
export FB_PAGE_TOKEN="tu_token"
export FB_PAGE_ID="tu_page_id"
bash scripts/publicar.sh "Prueba del sistema." "https://www.rockstargames.com/newswire"
```
Abre tu página **desde el celular con la sesión cerrada**. Si ves el post, todo
bien. Si no lo ves, revisa el 1.4. Después borra el post de prueba.

---

## PARTE 2 — Repositorio (10 min)

1. Crea un repo **privado** en GitHub: `gta6-agente`
2. Sube todo este contenido
3. Conecta tu cuenta de GitHub a Claude Code

> El repo es la memoria del agente. Cada corrida arranca desde cero y es
> stateless — sin el repo, el martes te repite la nota del lunes.

---

## PARTE 3 — Routine del Agente A (20 min)

1. Ve a **claude.ai/code/routines** → **New routine** → **Cloud**
2. Configura:

| Campo | Valor |
|---|---|
| Nombre | `GTA6 — Publicador diario` |
| Repositorio | `gta6-agente` |
| Frecuencia | Diaria, **07:00** (America/Mexico_City) |
| Prompt | El contenido completo de `prompts/agente-a-publicador.md` |

3. **Cloud Environment → Variables de entorno:**

| Variable | Valor |
|---|---|
| `FB_PAGE_TOKEN` | tu token de página |
| `FB_PAGE_ID` | tu ID de página |

4. **Cloud Environment → Acceso de red: Custom.** Dominios permitidos:
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
reddit.com
gtaforums.com
gta.fandom.com
```

> Custom en vez de Full: si el agente lee contenido malicioso en algún sitio y lo
> intentan usar para que haga una petición a otro lado, Custom la bloquea.

---

## PARTE 4 — Routine del Agente B (10 min)

Igual que la anterior, pero:

| Campo | Valor |
|---|---|
| Nombre | `GTA6 — Analista semanal` |
| Frecuencia | Semanal, **domingos 09:00** |
| Prompt | El contenido de `prompts/agente-b-analista.md` |
| Variables | Las mismas dos |
| Red | Solo `graph.facebook.com` (no necesita buscar) |

---

## PARTE 5 — Los primeros días

Elegiste ir directo a publicación, así que estas son las precauciones que
sustituyen al modo borrador:

**Día 1.** Dispara la routine manualmente mientras estás despierto. Revisa los 2
posts antes de que se publiquen a las 13:00 — tienes 6 horas de margen porque
quedan programados, no publicados de inmediato. Ese margen es tu red de seguridad
y por eso el diseño programa en vez de publicar al instante.

**Días 2 a 7.** Revisa una vez al día. Lo que buscas específicamente:
- ¿Suena a traducción de Google o a persona?
- ¿Repitió tema?
- ¿Etiquetó bien lo que es especulación?

Si algo falla, no toques el prompt de inmediato. Anótalo. A los 7 días haces un
solo ajuste bien pensado en vez de siete parches.

**Semana 4.** El Agente B empieza a tener datos suficientes. Antes de eso te va a
decir que la muestra es insuficiente, y eso es correcto, no es una falla.

---

## SI ALGO SE ROMPE

| Síntoma | Causa probable |
|---|---|
| `#10 API Permission Denied` | App en Development Mode, o falta `pages_manage_posts` |
| Los posts no los ve nadie | App en Development Mode → pasar a Live |
| El token dejó de servir | Usaste el token de usuario, no el de página. Repite 1.2 paso C |
| La routine no corrió | Revisa consumo de cuota: comparte límites con tu cuenta de Claude |
| Publicó repetido | Revisa que `datos/publicados.json` se esté commiteando |

## APAGADO DE EMERGENCIA

Desactiva la routine desde claude.ai/code/routines. Los posts ya programados en
Facebook **siguen en cola** — hay que borrarlos aparte desde el Meta Business
Suite, en Publicaciones programadas.
