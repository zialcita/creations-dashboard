# Creations Marketing Dashboard

Live: https://zialcita.github.io/creations-dashboard/ (passcode-protected, noindex).

`index.html` is **encrypted with StatiCrypt** (AES-256, same pattern as wyc-mooring-docs). The dashboard data is not readable in this public repo.

## Update the numbers
The editable source is deliberately **not committed** (it would be public). It lives on the box:

- Data: `/workspace/creations-dashboard/src/data/dashboard.json` (the only file you edit)
- Layout: `/workspace/creations-dashboard/src/template.html`
- Passcode: `/workspace/.secrets/creations-dashboard-passcode.txt`

Steps:
1. Edit `src/data/dashboard.json` (keep valid JSON; `progress` is a 0–100 bar value).
2. Run `./build.sh` — inlines the JSON and re-encrypts into `index.html`.
3. Commit and push `index.html`; GitHub Pages updates in ~1 minute.

Brand: creationsmedspa.com colors (#128599 teal, #9AB53B green, #EDECE6 cream, #BA9C78 gold), fonts Raleway + Sorts Mill Goudy, logo from the live site.
