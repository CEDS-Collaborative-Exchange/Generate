# Generate SEO And AI Discoverability Focus

Use this reference to adapt an SEO and AI discoverability review to the Generate repository structure.

## App Shell And Global Behavior

- `generate.web/ClientApp/src/index.html`: Global HTML shell. Contains a static `<title>Generate</title>`, a single generic `<meta name="description" content="Generate">`, an outdated `<meta name="keywords" ...>` tag, `<base href="/">`, and a favicon/manifest reference — but no canonical tag, no Open Graph or Twitter card metadata, and no per-route variation.
- `generate.web/ClientApp/src/app/app.component.ts`: Global shell behavior.
- `generate.web/ClientApp/src/app/app-routing.module.ts`: Top-level route map. `''` (`HomeComponent`), `login`, and `about` (`AboutComponent`) have no `canActivate` guard; `settings` and `reports` require `canActivate: [LoginGuard]`.

## Public Versus Guarded Surfaces

- The Angular router itself has no dedicated "public" module — reachability without a route guard is not the same as intentional public SEO content. `HomeComponent` (`generate.web/ClientApp/src/app/home/home.component.ts`) renders a dashboard shell that prompts anonymous visitors to log in (`gotoReportsEdFacts`, `gotoReportsSppApr`, `gotoReportsLibrary`, `gotoSummary` all check `UserService.isLoggedIn()` and show a "You must be logged in..." snackbar otherwise) rather than standalone public marketing or help copy.
- `AboutComponent` (`generate.web/ClientApp/src/app/about/about.component.ts`) is the other unguarded route and is the closest thing to static public content in the Angular app.
- `reports` and `settings` (and everything lazy-loaded under them) require `LoginGuard` and should not automatically be treated as SEO targets.
- `generate.web/Controllers/Api/UserController.cs` and most controllers under `generate.web/Controllers/Api/` carry `[Authorize]`, with narrow `[AllowAnonymous]` exceptions (e.g. login) — a strong signal that the API, and by extension most app content, is intentionally private.

## Repo-Specific Hotspots

- `generate.web/ClientApp/src/app/home/`: The unguarded landing route; evaluate whether its copy is genuinely public-facing or only makes sense post-login.
- `generate.web/ClientApp/src/app/about/`: Static public-facing content candidate.
- `docs/`: The public GitBook documentation site (published at https://center-for-the-integration-of-id.gitbook.io/generate-documentation per the root `README.md`). `docs/README.md` is the site's landing page; `docs/SUMMARY.md` defines its navigation tree; content lives under `docs/user-guide/`, `docs/developer-guides/`, `docs/data-integration-toolkit/`, `docs/release-notes/`, and similar folders. At last review, `docs/README.md` contained multiple broken `{% content-ref %}` links pointing at `/broken/pages/<id>` placeholders — a concrete, high-value discoverability defect on the one surface search engines and AI systems are most likely to actually reach.
- Root `README.md`: the GitHub-facing entry point and the source of the public GitBook link; also worth reviewing for broken links or thin descriptions since it is itself a public, indexable page.

## Hosting And Delivery

- `generate.web/Program.cs`: SPA hosting through `app.UseSpa(...)`, with `app.UseAuthentication()` and `app.UseAuthorization()` applied globally, and no `@angular/ssr` or prerender step in the build. `angular.json` and `generate.web/ClientApp/package.json` were checked and contain no SSR/prerender configuration as of this review.
- `generate.web/ClientApp/package.json` scripts (`ng build`, `ng test --watch=false`, `ng lint`, `ng e2e`) confirm a standard client-rendered Angular 20.3.x build with no static-generation step.
- Global `[Authorize]` usage across `generate.web/Controllers/Api/*` is a strong signal that most APIs — and the data they back — are intentionally private.

## Practical Review Heuristics

- Assume the repo is primarily an authenticated B2G reporting application for SEA staff, not a content-first public site — most SEO concerns on `reports`, `settings`, and other guarded routes should be treated as low priority or non-findings.
- Treat the public `docs/` GitBook site as the highest-value SEO and AI-discoverability review surface in this repo; it is where broken links, thin content, and unclear titles have the most real-world impact.
- Treat missing canonical, robots, sitemap, or share metadata on the Angular app as lower urgency than on `docs/`, unless code or configuration signals explicit public-search intent for a specific route.
- For guarded routes, prioritize clarity about intentional non-indexability over generic SEO criticism.
- For AI discoverability, look for public explanatory content that could answer "what is Generate?" or "how do I use Generate?" without requiring sign-in — today that content lives almost entirely in `docs/` and the root `README.md`, not in the authenticated app.
