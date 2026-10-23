# Creations Marketing Dashboard

Live: https://zialcita.github.io/creations-dashboard/ (passcode-protected, noindex).

`index.html` is **encrypted with StatiCrypt** (AES-256, same pattern as wyc-mooring-docs). The dashboard data is not readable in this public repo.

## Update the numbers
The editable source is deliberately **not committed** (it would be public). It lives on the box:

- Data: `/workspace/creations-dashboard/src/data/dashboard.json` (the only file you edit)
- Layout: `/workspace/creations-dashboard/src/template.html`
- Passcode: `/workspace/.secrets/creations-dashboard-passcode.txt`

Source is backed up in the PRIVATE repo zialcita/creations-dashboard-src (git dir `.git-src` in the same folder).

Steps:
1. Edit `src/data/dashboard.json` (keep valid JSON; `progress` is a 0–100 bar value).
2. Run `./update.sh "what changed"` — validates the JSON, re-encrypts `index.html`, pushes it here (only if changed), and pushes the source to the private repo. Stops on any error; never force-pushes.
3. GitHub Pages updates in ~1 minute.

`./build.sh` alone just rebuilds/encrypts locally (passcode read from the secrets file at build time).

Brand: creationsmedspa.com colors (#128599 teal, #9AB53B green, #EDECE6 cream, #BA9C78 gold), fonts Raleway + Sorts Mill Goudy, logo from the live site.

## Views and engagement (Thursday refresh)
Edit `viewsByMonth.months[]` in dashboard.json: per-platform `platforms` (null = pending) from GHL Social Planner > Statistics impressions and Ryze `google_business_profile__getPerformance` (sum of the 4 BUSINESS_IMPRESSIONS_* metrics), plus `engagement` (likes + comments + shares). Roll the oldest month off. `./update.sh` runs `src/compute_views.py` to rebuild totals, charts and the table.
