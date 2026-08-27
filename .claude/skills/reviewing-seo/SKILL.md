---
name: reviewing-seo
description: Perform repository-grounded Search Engine Optimization and AI discoverability code reviews and produce a prioritized list of concrete issues or concerns with file and line references, across the Generate repo's Angular SPA (generate.web/ClientApp), ASP.NET Core hosting layer (generate.web), and the public GitBook documentation site (docs/). Use when the user asks for an SEO review, AI discoverability review, crawlability review, indexability review, metadata review, content discoverability review, search snippet review, structured-data review, canonicalization review, public-content review, documentation-site review, or landing-page visibility assessment for this repo. Account for the fact that Generate is an authenticated internal-use reporting tool for state education agency staff rather than a public marketing site, so weigh whether a route or surface is actually meant to be crawled before flagging it.
---

# Reviewing SEO

Review the code that exists before making claims. Prefer concrete discoverability problems over generic marketing advice.

## Generate Stack Focus

Tailor the review to this repository's stack and layout:

- Frontend: Angular 20.3.x SPA in `generate.web/ClientApp`, NgModule-based client-side routing, no `@angular/ssr` or prerender configuration found in `angular.json` or `package.json` — meaning the app has no server-rendered or prerendered fallback and meaningful content only exists after client-side hydration.
- Hosting: ASP.NET Core 10 in `generate.web`, SPA served through `app.UseSpa(...)` in `generate.web/Program.cs`, with `app.UseAuthentication()` and `app.UseAuthorization()` applied globally and most controllers under `generate.web/Controllers/Api/` gated with `[Authorize]` (e.g. `generate.web/Controllers/Api/UserController.cs`), with narrow `[AllowAnonymous]` carve-outs for login-related actions.
- Public-versus-private reality: Generate is not a content-first public site — it is a B2G (business-to-government) reporting tool for authenticated state education agency (SEA) staff. There is no dedicated `public/`-style route split. In `generate.web/ClientApp/src/app/app-routing.module.ts`, the routes `''` (`HomeComponent`), `login`, and `about` (`AboutComponent`) carry no `canActivate: [LoginGuard]`, while `settings` and `reports` do. But `HomeComponent` (`generate.web/ClientApp/src/app/home/home.component.ts`) is a login-gated dashboard shell that prompts anonymous visitors to sign in rather than real public marketing or help copy — treat "reachable without a route guard" as distinct from "intended as a public SEO landing page."
- The one genuinely public, crawlable surface is the documentation: `docs/` in this repo is published as a public GitBook site (linked from the root `README.md` as https://center-for-the-integration-of-id.gitbook.io/generate-documentation). `docs/README.md` is the doc site's landing page and `docs/SUMMARY.md` defines its navigation tree. GitBook itself handles most technical SEO mechanics (sitemap, meta tags, canonical URLs), so review here should focus on content quality — broken links, thin or duplicated pages, unclear titles, orphaned pages — not on-page HTML mechanics.
- Common starting points: `generate.web/ClientApp/src/index.html` (static SPA shell), `generate.web/ClientApp/src/app/app.component.ts`, `generate.web/ClientApp/src/app/app-routing.module.ts`, `generate.web/ClientApp/src/app/home/`, `generate.web/ClientApp/src/app/about/`, `generate.web/Program.cs`, `generate.web/Controllers/Web/*.cs`, and `docs/README.md` / `docs/SUMMARY.md`.

## Workflow

1. Determine which surfaces are intentionally public, which are authentication-gated, and which appear mixed or ambiguous.
2. Read only the files needed to trace indexability, crawlability, metadata, canonicalization, structured content, and discoverable public text. In this repo, start with the SPA shell, routing, the home/about routes, the ASP.NET hosting behavior, and the `docs/` GitBook site.
3. Use [references/seo-review-checklist.md](references/seo-review-checklist.md) as the default checklist. Use [references/generate-stack-seo.md](references/generate-stack-seo.md) for repo-specific hotspots and interpretation guidance.
4. For each suspected issue, confirm the URL, route, or doc page, whether it is publicly reachable without authentication, the search or AI-discovery implication, and the practical impact. Do not report speculative findings that assume public crawlability where the product is clearly gated.
5. Spend most time on issues affecting the public `docs/` GitBook site and any Angular route or static asset the code signals as intended for public reach — not on generic SEO gaps in clearly authenticated report and settings workflows.

## Finding Standard

Only report a finding when all of these are true:

- The SEO or discoverability behavior is present in code, markup, routing, or hosting configuration.
- A realistic public or intended-to-be-discoverable path reaches it.
- The impact is meaningful and not purely theoretical.

When the evidence is incomplete, say so explicitly and label it as an assumption or open question instead of a confirmed finding.

## Priority Rubric

Sort findings from highest to lowest priority:

- `Critical`: A public or intended-to-be-public surface is effectively undiscoverable, wrongly blocked from indexing, canonically broken, or served in a way that prevents search engines and AI systems from accessing the main content at all.
- `High`: Major discoverability barrier on an important public page or document set, such as missing or misleading title and description strategy, no crawlable content for a key landing page, broken canonical or indexing directives, or a JS-only pattern that leaves meaningful public content absent from the initial response.
- `Medium`: Confirmed issue with narrower scope, lower-traffic surfaces, partial mitigation already present, or an ambiguity about whether the route should be public.
- `Low`: Defense-in-depth improvement, snippet-quality improvement, consistency gap, or discoverability enhancement with limited present-day impact.

Prefer fewer, higher-confidence findings over long speculative lists.

## What To Look For

- Public routes or static pages that lack stable, descriptive titles, meta descriptions, canonical tags, or clear heading structure — starting with `generate.web/ClientApp/src/index.html`, whose current `<title>` and `<meta name="description">` are both the single static word "Generate" and never vary per route.
- SPA routing patterns where important public content exists only after client-side hydration, with no prerendering or server-rendered fallback (confirmed absent in `angular.json`/`package.json` for this repo).
- Indexing directives, `robots.txt`, meta robots tags, sitemap generation, or canonical behavior that conflict with the intended visibility of the app. No `robots.txt` or sitemap was found under `generate.web/ClientApp/src/` at the time of this review — note that as an open question rather than assume it is missing entirely.
- Public landing copy that is thin, generic, duplicated, or hidden behind interactive UI instead of crawlable text — e.g. whether `HomeComponent` or `AboutComponent` content reads as real public explanatory copy versus an authenticated-app shell.
- Broken links, orphaned pages, or thin content on the public `docs/` GitBook site (`docs/README.md`, `docs/SUMMARY.md`, and pages under `docs/user-guide/`, `docs/developer-guides/`, `docs/release-notes/`, etc.) — these directly affect what search engines and AI systems can retrieve about Generate.
- Missing or inconsistent Open Graph, Twitter card, or other share-preview metadata where public sharing seems intended (`generate.web/ClientApp/src/index.html` currently has neither).
- Lack of structured, machine-readable signals that help AI systems understand the purpose, owner, and scope of a public page or document.
- Internal or authenticated routes (`reports`, `settings`, and any route behind `LoginGuard` in `generate.web/ClientApp/src/app/app-routing.module.ts`) being judged as SEO failures when they are not intended for indexing. In those cases, prefer noting the product constraint over reporting a high-severity issue.
- Documentation pages with weak titles, opaque link text, or no discoverable linking/navigation structure in `docs/SUMMARY.md`.

## AI Discoverability Notes

- Treat AI discoverability as overlapping with classic SEO, but not identical.
- Favor clear public text, descriptive headings, stable URLs, explicit ownership, and machine-readable metadata over growth-oriented SEO tactics.
- Pay extra attention to the public `docs/` GitBook site because AI systems and search engines are far more likely to rely on that linked, crawlable reference content than on the authenticated Angular application itself.
- Because the Angular app is authentication-gated by design, say explicitly that the best AI discoverability work for Generate is around the public documentation site (`docs/`), the root `README.md`, and any other externally published material — not the app's internal reports/settings workflows.

## Output Format

Return the review as Markdown.

Use Markdown structure intentionally so findings are easy to scan.

- Start with a short `## Findings` heading.
- Give each finding its own `### <Priority>: <Short Title>` heading.
- Put supporting fields on separate lines with bold labels such as `**Impact:**`, `**Evidence:**`, `**Change Risk:**`, `**Business Decision:**`, and `**Recommended Change:**`.
- Use inline code for literals, identifiers, routes, and file paths where helpful.
- Use Markdown horizontal rules between findings.
- Do not wrap the entire review in a fenced code block.

Lead with findings. Do not use Markdown tables by default. In this app, review tables often force horizontal scrolling and are harder to read than stacked finding blocks.

Present confirmed findings as a priority-sorted sequence of compact finding blocks. Give each finding its own short heading, then place the supporting fields on separate lines underneath it.

Separate findings with a Markdown horizontal rule `---` on its own line so each issue stands out clearly. Do not put a divider before the first finding; place one between findings only.

Never label user-facing findings as `P0`, `P1`, `P2`, or `P3`. Always use the human-readable priority words from the rubric: `Critical`, `High`, `Medium`, or `Low`.

For normal user-facing reviews, do not emit `::code-comment` directives. The app surfaces them as separate finding cards, so they are not internal-only. Only emit `::code-comment` when the user explicitly wants inline review comments, line-specific callouts, or code annotations.

Use this block shape for each finding:

- `### High: Public doc page lacks crawlable title`
- `**Impact:** Search engines and AI systems receive weak signals about the page purpose.`
- `**Evidence:** path/to/file:line, path/to/other-file:line`
- `**Change Risk:** Low`
- `**Business Decision:** Yes`
- `**Recommended Change:** Add stable title and metadata aligned to the intended public content strategy.`

Example:

## Findings

### High: Public doc page lacks crawlable title
**Impact:** Search engines and AI systems receive weak signals about the page purpose.
**Evidence:** path/to/file:line
**Change Risk:** Low
**Business Decision:** Yes
**Recommended Change:** Add stable title and metadata aligned to the intended public content strategy.

---

### Medium: Public document links are broken
**Impact:** Shared links and search snippets provide weak or dead-end context.

Keep each field to one or two short sentences. Let text wrap naturally. If two evidence references are enough, prefer two over a longer list.

If multiple findings share context, add a short `## Notes` section after the findings. Insert a Markdown horizontal rule `---` before `## Notes` so it is clearly separated from the last finding. Only use a Markdown table when the user explicitly asks for one.

Always pair the recommended change with the change-risk level and business-decision flag. Treat change risk as the likelihood that implementing the fix will cause regressions, require broad coordination, or reshape shared behavior. Mark business decision as `Yes` when the best fix changes public-content strategy, indexing intent, branding or messaging, or the boundary between public and authenticated surfaces rather than simply correcting an implementation mistake.

If there are no confirmed findings, say that explicitly and mention residual risks or intentional product constraints.

## Review Notes

- Review both the Angular frontend and the ASP.NET Core hosting layer when both influence discoverability, but expect most confirmed findings to concentrate in `generate.web/ClientApp/src/index.html`, the unguarded home/about routes, and the `docs/` GitBook site.
- Do not assume every route should be indexed. Generate is primarily an authenticated reporting tool; only `docs/`, the root `README.md`, and the unguarded home/about routes are plausible discovery surfaces.
- Treat missing SEO features on clearly authenticated workflows (`reports`, `settings`, and anything behind `LoginGuard`) as low priority or non-findings unless the code signals an intent to expose them publicly.
- Pay special attention to `generate.web/ClientApp/src/index.html`, `generate.web/ClientApp/src/app/home/`, `generate.web/ClientApp/src/app/about/`, and `docs/` (especially `docs/README.md` and `docs/SUMMARY.md`) because those are the most plausible discovery surfaces in this stack.
- Keep summaries short. Do not bury findings under an architecture overview.
