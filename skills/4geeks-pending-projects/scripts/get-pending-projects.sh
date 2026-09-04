#!/bin/bash
# 4Geeks Pending Projects - Script de consulta
# Uso: bash scripts/get-pending-projects.sh

set -e

# Cargar token
if [ -f /root/.openclaw/.env ]; then
    source /root/.openclaw/.env
fi

TOKEN="${FOURGEEKS_AUTH_TOKEN}"

if [ -z "$TOKEN" ]; then
    echo "Error: FOURGEEKS_AUTH_TOKEN no está configurado"
    exit 1
fi

# Obtener tareas
TASKS=$(curl -s "https://breathecode.herokuapp.com/v1/assignment/user/me/task?limit=100" \
    -H "Authorization: Token $TOKEN" \
    --max-time 30)

python3 << 'PYEOF'
import json, sys

try:
    data = json.loads(sys.stdin.read())
except json.JSONDecodeError as e:
    print(f"Error parsing JSON: {e}")
    sys.exit(1)

tasks = data.get('results', data) if isinstance(data, dict) else data
if not isinstance(tasks, list):
    print("Error: respuesta inesperada de la API")
    sys.exit(1)

pending_projects = [t for t in tasks if t.get('task_type') == 'PROJECT' and t.get('task_status') == 'PENDING']

if not pending_projects:
    print("✅ No tienes proyectos pendientes. ¡Buen trabajo!")
    sys.exit(0)

print(f"📦 PROYECTOS PENDIENTES — {len(pending_projects)}\n")

for p in pending_projects:
    title = p.get('title', '?')
    slug = p.get('associated_slug', '')
    cohort = p.get('cohort', {})
    cname = cohort.get('name', '?') if isinstance(cohort, dict) else '?'
    opened = p.get('opened_at', '')[:10] if p.get('opened_at') else 'no iniciado'
    
    # Fetch asset details (public endpoint)
    import urllib.request
    try:
        req = urllib.request.Request(f"https://breathecode.herokuapp.com/v1/registry/asset/{slug}")
        with urllib.request.urlopen(req, timeout=10) as resp:
            asset = json.loads(resp.read())
        readme = asset.get('readme_url', '')
        template = asset.get('template_url', '')
        desc = asset.get('description', '')
        diff = asset.get('difficulty', '')
    except:
        readme = f"https://github.com/4GeeksAcademy/ai-engineering-syllabus/blob/main/content/projects/{slug}/README.md"
        template = ""
        desc = ""
        diff = ""
    
    print(f"📦 {title}")
    if desc:
        print(f"   📝 {desc}")
    if diff:
        print(f"   🎯 Dificultad: {diff}")
    print(f"   📖 Instrucciones: {readme}")
    if template:
        print(f"   🏗️ Template: {template}")
    print(f"   📚 Cohort: {cname}")
    print(f"   Estado: {opened}")
    print()

PYEOF
