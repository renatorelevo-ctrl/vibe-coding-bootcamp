#!/usr/bin/env bash
# Lässt Codex (OpenAI) den aktuellen Feature-Branch gegen main reviewen.
# Verdict-Format und Prüfkriterien stehen in AGENTS.md — Codex liest die
# Datei automatisch. Läuft über das ChatGPT-Abo (codex login), kein API-Key.
#
# Nutzung:
#   scripts/codex-review.sh            # Review gegen main
#   scripts/codex-review.sh <branch>   # Review gegen anderen Basis-Branch
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [ -f .env.devteam ]; then
  set -a
  # shellcheck disable=SC1091
  source .env.devteam
  set +a
fi

BASE="${1:-main}"
BRANCH="$(git branch --show-current)"

# Review absichtlich NICHT mit dem Worker-Modell (Luna) laufen lassen:
# leer = Codex-Standardmodell, damit ein anderes Modell prüft als baut.
MODEL="${CODEX_REVIEW_MODEL-}"
MODEL_ARGS=()
if [ -n "$MODEL" ]; then
  MODEL_ARGS=(-m "$MODEL")
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Codex CLI nicht gefunden. Installieren mit: npm install -g @openai/codex" >&2
  echo "Danach einmalig anmelden: codex login" >&2
  exit 1
fi

if [ "$BRANCH" = "$BASE" ]; then
  echo "Abbruch: Du bist auf '$BASE' — es gibt keinen Diff zu reviewen." >&2
  exit 1
fi

echo ">> Codex reviewt '$BRANCH' gegen '$BASE' ..." >&2

codex exec "${MODEL_ARGS[@]}" "Führe ein Code-Review durch, wie in AGENTS.md unter 'Rolle: Reviewer' beschrieben. Zu prüfen sind alle Änderungen des Branches '$BRANCH' gegenüber '$BASE' (git diff $BASE...HEAD). Gib dein Ergebnis exakt im Verdict-Format aus AGENTS.md aus — auf Deutsch und für einen Nicht-Programmierer verständlich. Ändere keine Dateien."
