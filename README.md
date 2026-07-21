# Publicar el asistente de Tiendas Full en Netlify

Misma lógica que ya probamos, adaptada a la estructura que usa Netlify. No hace falta
saber programar — son pasos de configuración.

## Paso 1 — Conseguir tu clave de API de Anthropic

1. Entrá a https://console.anthropic.com y creá una cuenta (o iniciá sesión).
2. Andá a **API Keys** y creá una nueva clave. Guardala en un lugar seguro.
3. En **Billing**, cargá una tarjeta y un límite de gasto mensual (podés poner un tope
   bajo, ej. USD 10-20, mientras estás probando).

## Paso 2 — Crear el formulario de derivación (Formspree)

1. Entrá a https://formspree.io y creá una cuenta gratuita.
2. Creá un nuevo formulario, poné el email donde querés recibir las derivaciones, y
   copiá la URL que te dan (`https://formspree.io/f/xxxxxxx`).
3. Abrí `public/index.html`, buscá la línea:
   ```
   const FORMSPREE_URL = "https://formspree.io/f/TU_ID_AQUI";
   ```
   y reemplazá `TU_ID_AQUI` por tu URL de Formspree.

## Paso 3 — Subir el proyecto a Netlify

Como ya usan Netlify, probablemente ya sepan este flujo, pero por las dudas:

1. Si no lo subiste todavía a un repositorio (GitHub/GitLab/Bitbucket), hacelo — Netlify
   necesita conectarse a un repo para poder construir la función junto con el sitio
   (arrastrar la carpeta directamente en el dashboard de Netlify, igual que en Vercel,
   **no** construye funciones, solo archivos estáticos).
2. En Netlify: **Add new site → Import an existing project** y elegí el repositorio.
3. En la configuración de build, Netlify debería detectar automáticamente el archivo
   `netlify.toml` de este proyecto (ya tiene configurado `publish = "public"` y
   `functions = "netlify/functions"`). No deberías necesitar tocar nada ahí.
4. Antes o después del primer deploy, andá a **Site configuration → Environment
   variables** y agregá:
   - Key: `ANTHROPIC_API_KEY`
   - Value: tu clave de Anthropic del Paso 1
5. Si agregaste la variable después del primer deploy, hacé un **"Trigger deploy" →
   "Deploy site"** para que la tome.

## Paso 4 — Probarlo

Abrí la URL que te da Netlify (algo como `tu-sitio.netlify.app`) y probá el chat. Si
algo falla, revisá **Functions → chat → Logs** en el dashboard de Netlify — ahí vas a
ver el error real (por ejemplo, si la clave de API no quedó bien cargada).

## Paso 5 — Insertarlo en tu web real

**Opción A — Página aparte:** un botón "Chatear con nosotros" que lleve a la URL de
Netlify.

**Opción B — Widget flotante en tu web:** agregá esto antes de `</body>` en las páginas
donde quieras el chat:

```html
<iframe
  src="https://TU-SITIO.netlify.app"
  style="position:fixed; bottom:20px; right:20px; width:400px; height:640px;
         border:none; border-radius:16px; box-shadow:0 4px 24px rgba(0,0,0,0.2); z-index:9999;"
></iframe>
```

Reemplazá `TU-SITIO.netlify.app` por tu URL real.

## Nota sobre el timeout

Netlify (igual que Vercel) corta las funciones a los 10 segundos en el plan gratuito.
Por eso este proyecto ya busca primero los fragmentos relevantes del manual en el
servidor (en vez de mandar el manual completo en cada mensaje) — así cada respuesta es
mucho más rápida y no debería acercarse a ese límite.
