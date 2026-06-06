#!/usr/bin/env bash
set -euo pipefail

NAS_HOST="${NAS_HOST:-192.168.0.7}"
NAS_PORT="${NAS_PORT:-1007}"
NAS_USER="${NAS_USER:-JeremyLee}"
NAS_WEB_PATH="${NAS_WEB_PATH:-/volume1/web/agent}"
PUBLIC_CHECK_PATH="${PUBLIC_CHECK_PATH:-/agent/}"

if [[ ! -f index.html ]]; then
  echo "index.html not found. Run from the project root." >&2
  exit 1
fi

python3 - <<'PY'
from html.parser import HTMLParser
from pathlib import Path
for name in ["index.html", "agent_study_webpage_white.html"]:
    if Path(name).exists():
        parser = HTMLParser()
        parser.feed(Path(name).read_text())
        print(f"{name}: html parse ok")
PY

echo "Deploying to GitHub..."
git status --short
git push origin main

echo "Deploying to NAS ${NAS_USER}@${NAS_HOST}:${NAS_WEB_PATH} ..."
if [[ -n "${SSHPASS:-}" ]]; then
  SSH_BASE=(sshpass -e ssh -p "$NAS_PORT" -o PreferredAuthentications=password -o PubkeyAuthentication=no -o NumberOfPasswordPrompts=1)
else
  SSH_BASE=(ssh -p "$NAS_PORT")
fi

COPYFILE_DISABLE=1 tar --disable-copyfile --format ustar -czf - \
  index.html agent_study_webpage_white.html README.md SITE_VERSION .nojekyll \
  assets/hermes-telegram-flow.jpg assets/hermes-openclaw-overview.jpg \
  | "${SSH_BASE[@]}" "${NAS_USER}@${NAS_HOST}" "set -e; mkdir -p '$NAS_WEB_PATH'; tar -xzf - -C '$NAS_WEB_PATH'; cp '$NAS_WEB_PATH/index.html' /volume1/web/agent.html; rm -f '$NAS_WEB_PATH'/._*"

echo "Checking NAS LAN URL..."
curl -I --max-time 15 "http://${NAS_HOST}${PUBLIC_CHECK_PATH}" | sed -n '1,12p'

echo "Done."
