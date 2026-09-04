---
name: "4geeks-pending-projects"
description: "Muestra proyectos pendientes de 4Geeks Academy con enlaces a sus instrucciones y template"
---

# 4Geeks Pending Projects Skill

Muestra los proyectos pendientes de 4Geeks Academy con enlaces directos a las instrucciones y al template de inicio.

## Configuration

El skill necesita dos variables de entorno configuradas en `openclaw.json`:

```json
{
  "env": {
    "FOURGEEKS_AUTH_TOKEN": "tu_token_aqui",
    "STUDENT_ID": "tu_student_id_aqui"
  }
}
```

O en `.env`:
```
FOURGEEKS_AUTH_TOKEN
STUDENT_ID
```

## How to use

When the user asks about pending projects, execute the following steps:

### 1. Get the auth token

Read `FOURGEEKS_AUTH_TOKEN` from environment or `.env` file.

### 2. Fetch all tasks

Call GET `https://breathecode.herokuapp.com/v1/assignment/user/me/task?limit=100`

Headers: `Authorization: Token $FOURGEEKS_AUTH_TOKEN`

### 3. Filter pending projects

From the response `results`, filter items where:
- `task_type == "PROJECT"`
- `task_status == "PENDING"`

### 4. For each project, fetch asset details

Call GET `https://breathecode.herokuapp.com/v1/registry/asset/{associated_slug}` (public, no auth needed)

Extract:
- `readme_url` → enlace a las instrucciones en GitHub
- `template_url` → enlace al template de inicio
- `title` → nombre del proyecto
- `difficulty` → dificultad
- `description` → descripción breve

### 5. Format output

For each pending project, show:

```
📦 [TITLE]
   📖 Instrucciones: [readme_url]
   🏗️ Template: [template_url]
   📚 Cohort: [cohort name]
```

## Example output

```
📦 PROYECTOS PENDIENTES — 5

📦 Showcase your friend's artist talent with a website
   📖 Instrucciones: https://github.com/4GeeksAcademy/ai-engineering-syllabus/blob/main/content/projects/html-css-artist-landing-seo-access/README.md
   🏗️ Template: https://github.com/4GeeksAcademy/html-hello
   📚 Cohort: spain-aie-pt-4

📦 Milestone 1 — Your Company's Public Website
   📖 Instrucciones: https://github.com/4GeeksAcademy/ai-engineering-syllabus/blob/main/content/projects/ai-eng-milestone-web-fundamentals/README.md
   🏗️ Template: https://github.com/4GeeksAcademy/html-hello
   📚 Cohort: spain-aie-pt-4
```

## Notes

- The registry asset endpoint is public (no auth token needed)
- The task endpoint requires the `FOURGEEKS_AUTH_TOKEN`
- The `readme_url` pattern is: `https://github.com/4GeeksAcademy/ai-engineering-syllabus/blob/main/content/projects/{slug}/README.md`
