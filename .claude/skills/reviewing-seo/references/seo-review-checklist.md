# SEO And AI Discoverability Review Checklist

Use this checklist to guide a repository review, then spend most of the time on the highest-impact confirmed discoverability paths.

## Triage First

- Which URLs, routes, or doc pages are actually public?
- Which routes are authentication-gated and therefore not realistic SEO targets?
- Which public pages, docs, or downloads appear intended for search or external sharing?

## Generate Repo Sweep

- `generate.web/ClientApp/src/index.html`
- `generate.web/ClientApp/src/app/app.component.ts`
- `generate.web/ClientApp/src/app/app-routing.module.ts`
- `generate.web/ClientApp/src/app/home/home.component.ts` and `home.component.html`
- `generate.web/ClientApp/src/app/about/about.component.ts`
- `generate.web/Program.cs`
- `generate.web/Controllers/Web/AccountController.cs`, `generate.web/Controllers/Web/ErrorController.cs`
- `docs/README.md`, `docs/SUMMARY.md`, and pages under `docs/user-guide/`, `docs/developer-guides/`, `docs/release-notes/`
- Root `README.md` (links to the public GitBook site)

## Public Accessibility Check

- Identify unguarded Angular routes (no `canActivate` guard in `app-routing.module.ts`) versus routes behind `LoginGuard`
- Verify whether an unguarded route is intended for indexing or just happens to not require a route guard while still gating its content via API calls
- Avoid escalating missing SEO mechanics on clearly private application workflows (`reports`, `settings`)
- Escalate ambiguity when code or configuration sends mixed signals about indexability

## Core Metadata

- Unique document titles for public pages (the Angular SPA currently ships one static `<title>Generate</title>` for every route)
- Meta descriptions where public snippets matter (`generate.web/ClientApp/src/index.html` currently has a single generic `<meta name="description" content="Generate">`)
- Canonical tags where duplicate or alternate URLs are possible
- Sensible language, base URL, and share metadata for public surfaces

## Crawlability And Indexability

- `robots.txt`, meta robots, and indexing directives (none found under `generate.web/ClientApp/src/` at last check — confirm before reporting as missing)
- Sitemap presence or deliberate absence
- Public pages reachable through crawlable links
- Important public content not hidden behind JS-only flows, form posts, or downloads alone

## SPA And Rendering Model

- Whether meaningful public content exists in the initial HTML (currently: no, `generate.web/ClientApp/src/index.html` renders only a static "Loading ..." shell before Angular bootstraps)
- Whether search-critical public pages rely entirely on client-side rendering
- Whether there is any SSR, prerender, or static-generation support (`@angular/ssr` was not found in `angular.json` or `package.json` as of this review)
- Whether route-based content can be discovered without app-state assumptions

## Content Quality And Structure

- Descriptive headings and visible text on public pages
- Public copy that explains what Generate is and who it is for, versus copy that only makes sense to an already-authenticated user
- Avoidance of thin, duplicated, or placeholder-like content
- Doc-site pages and links with meaningful titles and working link targets (check `docs/README.md` and `docs/SUMMARY.md` for broken or placeholder links)

## AI Discoverability

- Clear public explanatory content, not just application chrome
- Stable URLs and obvious ownership signals
- The public `docs/` GitBook site as the primary citable/retrievable reference content for Generate
- Machine-readable metadata or content structure that reduces ambiguity

## Priority Calibration

- `Critical`: Public content intended for discovery is effectively blocked or absent
- `High`: Major discoverability barrier on an important public surface
- `Medium`: Confirmed issue with narrower scope or mixed evidence
- `Low`: Incremental discoverability improvement or consistency issue
