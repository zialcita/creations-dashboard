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

YouTube row: `src/youtube_views.py` (yt-dlp, public, no sign-in) runs automatically in `./update.sh` before `compute_views.py`. Requires `pip install yt-dlp`. If the pull fails, previous values stay.

## Top ad creatives (Thursday refresh, BEFORE `./update.sh`)
Shows one card per Meta ad (thumbnail, name, status, spend, impressions, CTR, leads, CPL, "View ad" link) for the Creations Med Spa Ad Account `act_4526830877645470`: active ads plus any ad with spend in the period. GLP-1 / "DO NOT RELAUNCH" ads are always skipped.

1. In Ryze, run `meta_ads__runGraphRead` (adAccountId `act_4526830877645470`) twice and save each raw JSON response over the files in `src/data/meta_raw/` (the exact path + fields are in the header of `src/ad_creatives.py`):
   - `ads.json`: path `act_4526830877645470/ads?limit=100`
   - `insights.json`: path `act_4526830877645470/insights?level=ad&time_range={"since":"<month start>","until":"<today>"}&limit=100`
   If either response has `paging.next`, follow it and merge `data` arrays.
2. Run `python3 src/ad_creatives.py "Oct 1–29"` (the period label). It downloads the thumbnails now (Meta image links expire), shrinks them, and embeds them as base64 inside `dashboard.json`, so they only exist inside the encrypted page. No image files go into this public repo.
3. **Open `/workspace/creations-dashboard-review/review.html` and look at every thumbnail.** No before-and-after images in ads context, ever. If one appears, add `"<ad id>": "before-and-after"` to `src/data/ad_creatives_exclude.json` and re-run step 2.
4. Run `./update.sh "what changed"`.
