#!/usr/bin/env bash
# One-shot update: validate JSON -> rebuild/encrypt -> push public index.html (if changed) -> push private source.
# Public:  zialcita/creations-dashboard      (git dir .git)
# Private: zialcita/creations-dashboard-src  (git dir .git-src, same folder)
set -euo pipefail
cd "$(dirname "$0")"
GH=/usr/local/bin/gh
push() { git -c credential.https://github.com.helper= -c "credential.https://github.com.helper=!$GH auth git-credential" "$@" push origin main; }
id=(-c user.name=zialcita -c user.email=zialcita@users.noreply.github.com)
MSG=${1:-"Dashboard update $(date '+%Y-%m-%d %H:%M %Z')"}

echo "1/4 Validating src/data/dashboard.json"
python3 -m json.tool src/data/dashboard.json >/dev/null || { echo "ERROR: dashboard.json is not valid JSON"; exit 1; }

echo "2/4 Rebuilding + encrypting"
# StatiCrypt uses a random IV each build, so only re-encrypt when the plaintext changed.
python3 - <<'PY' > /tmp/cd-plain.hash
import json,hashlib;print(hashlib.sha256((json.dumps(json.load(open('src/data/dashboard.json')),sort_keys=True)+open('src/template.html').read()).encode()).hexdigest())
PY
if [ -f .last-build.hash ] && cmp -s /tmp/cd-plain.hash .last-build.hash; then
  echo "   content unchanged; skipping re-encrypt"
else
  ./build.sh && cp /tmp/cd-plain.hash .last-build.hash
fi

echo "3/4 Public repo"
git add index.html README.md build.sh update.sh .gitignore assets robots.txt .nojekyll
if git diff --cached --quiet; then echo "   no public changes"; else git "${id[@]}" commit -qm "$MSG" && push && echo "   pushed $(git rev-parse --short HEAD)"; fi

echo "4/4 Private source repo"
S=(--git-dir=.git-src --work-tree=.)
git "${S[@]}" add -f src/data/dashboard.json src/template.html build.sh update.sh README.md .gitignore
if git "${S[@]}" diff --cached --quiet; then echo "   no source changes"; else git "${S[@]}" "${id[@]}" commit -qm "$MSG" && git "${S[@]}" -c credential.https://github.com.helper= -c "credential.https://github.com.helper=!$GH auth git-credential" push origin main && echo "   pushed $(git "${S[@]}" rev-parse --short HEAD)"; fi
echo "Done."
