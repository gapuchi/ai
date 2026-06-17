# Plan Examples

## Good plan file (extract service behind a boundary)

Path: `.cursor/plans/billing-service-extract.md`

```markdown
# Plan: billing-service-extract

**Approved:** 2026-06-12

## Status

- [ ] Increment 1: Extract calculation into BillingService; handlers delegate
- [ ] Increment 2: Add unit tests for edge cases
- [ ] Increment 3: Delete duplicated inline helpers in handlers

## Goal

Move billing calculation out of HTTP handlers into a testable domain module.

## Architectural decisions

1. Boundary placement — chose in-process `internal/billing/` module over a standalone service. Same process keeps ops cost flat; the seam is the value, not the network hop.
2. Migration shape — chose extract-then-test over rewrite-with-tests. Behavior-unchanged first slice is easiest to review.

## Approach

Add `BillingService` with the existing calculation logic unchanged; handlers call one method and map errors at the seam.

## Boundaries

- `internal/billing/` — pure calculation, no HTTP or DB types
- `internal/handlers/` — request/response translation only
- Existing `BillingRepository` interface stays; handlers do not import SQL types

## Increments

1. Extract calculation into `BillingService`; handlers delegate (behavior unchanged)
2. Add unit tests for edge cases currently only covered by integration tests
3. Delete duplicated inline calculation helpers in handlers

## Files / areas

- `internal/handlers/billing.go` — thin delegation
- `internal/billing/service.go` — new module
- `internal/billing/service_test.go` — unit tests

## Tradeoffs & risks

- Increment 1 is a large diff but zero behavior change—easier review than mixed refactor + behavior
- Two call sites still duplicate input mapping until increment 3; acceptable per tenet 3

## Open questions

- Should failed calculations return 422 or 500? (currently inconsistent)

## Plan drift

none
```

**Why it's good:** One path, clear boundaries, shippable increments, open questions surfaced.

---

## Bad plan (vague refactor)

```markdown
## Goal
Clean up auth.

## Approach
Refactor auth to be cleaner and more modular.

## Increments
1. Refactor auth code
2. Add tests
3. Clean up leftovers
```

**Why it's bad:** No boundaries, no files, increments aren't shippable slices, "cleaner" isn't an approach. Would fail the gate—rewrite before asking for approval.
