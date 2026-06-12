# Increment Checklist

Run before marking an increment done. Each item maps to `@agents/coding-philosphy.mdc`.

## Correctness
- [ ] Increment delivers what the plan promised for this slice
- [ ] Failures are visible—not swallowed or silently ignored

## Boundaries (tenet 8)
- [ ] Callers depend on stable contracts, not internals
- [ ] No framework/DB/HTTP types leaked across the seam you defined
- [ ] Domain logic does not import transport or persistence layers

## Cognitive load (tenet 1)
- [ ] Happy path is obvious at the call site
- [ ] Names and types make behavior clear without reading implementation
- [ ] No new knobs, modes, or callbacks unless the plan required them

## Less code (tenet 4)
- [ ] Dead code, unused imports, and orphaned helpers removed
- [ ] Nothing added "for later" that this increment doesn't use

## Abstraction (tenet 3)
- [ ] No new abstraction unless the pattern appeared a third time—or the plan explicitly introduced it at a boundary

## Effects
- [ ] Side effects (I/O, mutation, logging) are at edges or obviously named
- [ ] Core logic is testable without standing up every neighbor

## Repo fit (tenet 6)
- [ ] New code reads like it was written by the same team on the same day
