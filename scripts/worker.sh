#!/usr/bin/env bash
# Delegiert eine Implementierungsaufgabe an den günstigen Worker.
# Standard: Codex (GPT-5.6 Luna) über das ChatGPT-Plus-Abo — kein API-Key nötig.
# Alternativ: DeepSeek/GLM per API (headless Claude Code gegen deren Endpoint).
# Verbraucht in keinem Fall Claude-Abo-Kontingent.
#
# Nutzung:
#   scripts/worker.sh "Aufgabenbeschreibung"
#   scripts/worker.sh --file .worker-task.md
#
# Konfiguration über .env.devteam (siehe .env.devteam.example).
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [ -f .env.devteam ]; then
  set -a
  # shellcheck disable=SC1091
  source .env.devteam
  set +a
fi

PROVIDER="${WORKER_PROVIDER:-codex}"

BRANCH="$(git branch --show-current)"
if [ "$BRANCH" = "main" ] || [ -z "$BRANCH" ]; then
  echo "Abbruch: Der Worker arbeitet nie auf 'main'. Erst einen Feature-Branch erstellen." >&2
  exit 1
fi

if [ "${1:-}" = "--file" ]; then
  TASK="$(cat "${2:?Pfad zur Task-Datei fehlt}")"
else
  TASK="${1:?Aufgabenbeschreibung fehlt (als Argument oder mit --file <datei>)}"
fi

PROMPT="Du bist der Implementierungs-Worker in diesem Repository (Branch: $BRANCH).

Aufgabe:
$TASK

Regeln:
- Falls eine PLAN.md existiert, halte dich an den Plan.
- Bleib strikt bei der Aufgabe — keine ungefragten Umbauten an anderem Code.
- Prüfe dein Ergebnis mit 'npm run build' und behebe Fehler, bevor du fertig meldest.
- Committe deine Änderungen auf dem aktuellen Branch mit einer aussagekräftigen Commit-Message.
- Antworte am Ende mit einer kurzen Zusammenfassung: was wurde geändert, welche Dateien, Ergebnis von npm run build."

echo ">> Worker ($PROVIDER) startet auf Branch '$BRANCH' ..." >&2

case "$PROVIDER" in
  codex)
    if ! command -v codex >/dev/null 2>&1; then
      echo "Codex CLI nicht gefunden. Installieren mit: npm install -g @openai/codex && codex login" >&2
      exit 1
    fi
    # Luna braucht Codex CLI >= 0.144.0. Bei Problemen CODEX_WORKER_MODEL=""
    # setzen, dann nutzt Codex sein Standardmodell.
    MODEL="${CODEX_WORKER_MODEL-gpt-5.6-luna}"
    MODEL_ARGS=()
    if [ -n "$MODEL" ]; then
      MODEL_ARGS=(-m "$MODEL")
    fi
    codex exec --sandbox workspace-write "${MODEL_ARGS[@]}" "$PROMPT"
    ;;
  kimi|deepseek|glm)
    MODEL_ENV=()
    if [ "$PROVIDER" = "kimi" ]; then
      # Kimi Code Membership: eigener Abo-Endpoint, Key aus der Kimi Code Console
      BASE_URL="https://api.kimi.com/coding/"
      TOKEN="${KIMI_API_KEY:?KIMI_API_KEY fehlt — in .env.devteam eintragen (Key aus der Kimi Code Console)}"
      MODEL_ENV=(ANTHROPIC_MODEL="${KIMI_WORKER_MODEL:-k3}")
    elif [ "$PROVIDER" = "deepseek" ]; then
      BASE_URL="https://api.deepseek.com/anthropic"
      TOKEN="${DEEPSEEK_API_KEY:?DEEPSEEK_API_KEY fehlt — in .env.devteam eintragen}"
    else
      BASE_URL="https://api.z.ai/api/anthropic"
      TOKEN="${GLM_API_KEY:?GLM_API_KEY fehlt — in .env.devteam eintragen}"
    fi
    env -u ANTHROPIC_API_KEY \
      ANTHROPIC_BASE_URL="$BASE_URL" \
      ANTHROPIC_AUTH_TOKEN="$TOKEN" \
      "${MODEL_ENV[@]}" \
      claude -p "$PROMPT" \
      --permission-mode acceptEdits \
      --allowedTools "Read,Glob,Grep,Edit,Write,Bash(npm run build),Bash(npm install:*),Bash(git status),Bash(git diff:*),Bash(git log:*),Bash(git add:*),Bash(git commit:*)"
    ;;
  *)
    echo "Unbekannter WORKER_PROVIDER: '$PROVIDER' (erlaubt: codex, kimi, deepseek, glm)" >&2
    exit 1
    ;;
esac
