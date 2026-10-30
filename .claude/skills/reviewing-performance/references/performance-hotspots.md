# Performance Hotspots

Use this reference when a suspected issue needs more concrete pattern guidance.

## Common Hotspots

- `N+1 data access`: Query once for a list, then query again for each row, item, or child entity (e.g., per school, per LEA, per student).
- `Cursor-driven dynamic SQL`: Build and execute one SQL statement per iteration of a `CURSOR` loop (report code, category set, organization level) instead of a single set-based statement — a recurring pattern in this repo's stored procedures.
- `Repeated cold work`: Parse config, compile regexes, construct clients, or compute immutable data inside hot paths.
- `Over-fetching`: Load full entities, files, or payloads when the caller only needs a subset — including EF Core queries that skip `AsNoTracking` or an explicit projection on read-only paths.
- `Chatty orchestration`: Make many small remote or database calls instead of batching or parallelizing.
- `Unbounded growth`: Keep appending to in-memory collections, caches, or buffered results without eviction or limits.
- `Hot-path logging`: Log large payloads, serialize complex objects, or emit noisy logs inside frequent loops.
- `Frontend recompute churn`: Recalculate derived state or rebuild large subtrees on every interaction, especially inside large report/pivot table components.
- `Startup drag`: Do expensive discovery, migration, preloading, or remote calls on application boot for non-critical features.

## Usage Notes

- Prefer the hotspot with the clearest scale factor and user impact.
- Map each finding to the specific trigger: per request, per row, per render, per startup, or per job run.
- Do not force micro-optimizations into findings unless they sit on a real hot path.
