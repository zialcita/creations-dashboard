#!/usr/bin/env bash
# Rebuild + encrypt: inlines src/data/dashboard.json into src/template.html, encrypts with StatiCrypt -> index.html
set -euo pipefail; cd "$(dirname "$0")"
PASS_FILE=${PASS_FILE:-/workspace/.secrets/creations-dashboard-passcode.txt}
python3 - <<'PY'
import json;d=json.load(open('src/data/dashboard.json'));t=open('src/template.html').read()
open('src/build.html','w').write(t.replace('__DATA__',json.dumps(d,ensure_ascii=False).replace('</','<\\/')))
PY
STATICRYPT_PASSWORD="$(cat "$PASS_FILE")" npx -y staticrypt@3 src/build.html -d . --short --remember 14 \
  --template-title "Creations Marketing Dashboard" --template-instructions "Enter the Creations team passcode." \
  --template-color-primary "#128599" --template-color-secondary "#EDECE6" --template-button "Open dashboard" >/dev/null
mv build.html index.html; rm -f src/build.html
grep -q 'name="robots"' index.html || sed -i 's#<head>#<head><meta name="robots" content="noindex,nofollow">#' index.html
echo "Built index.html (encrypted)"
