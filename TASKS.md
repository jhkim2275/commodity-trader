# Tasks

Who owns which part of the project, and how to work on it.

## Project layout

Game rules live in `lib/` as pure OCaml (no Lwt, no I/O), so every rule can
be unit tested. `lib/` is split into folders by topic (`core/`, `market/`,
`player/`, `game/`). The folders are only for organization: every module is
still used as `Commodity_trader.<Module>`, e.g. `Commodity_trader.Bot`.
The terminal app in `bin/` runs those rules live with Lwt.

| File | What it does | Owner |
| --- | --- | --- |
| `lib/core/types.ml` | Shared types: commodity, price (cents), quote, duration | Shreya |
| `lib/core/commodity.ml` | Names, parsing, starting values | Shreya |
| `lib/core/command.ml` | Parses what the player types | Connie |
| `lib/market/headline.ml` | Headlines and the deck | Junghoon |
| `lib/market/market.ml` | Hidden daily true values | Junghoon |
| `lib/market/bot.ml` | One bot per commodity quoting bid/ask | Wyatt |
| `lib/player/portfolio.ml` | Cash, holdings, buy/sell accounting | Shreya |
| `lib/player/settlement.ml` | End reasons and selling everything at the end | Shreya |
| `lib/game/clock.ml` | Countdown to the end of the run | Connie |
| `lib/game/game.ml` | Whole game state; ties every module together | Junghoon (`tick_bots`: Wyatt) |
| `bin/main.ml` | Entry point: pick a duration, play a run | Wyatt |
| `bin/loop.ml` | Lwt loop: input reader, bot ticker, deadline watcher | Wyatt |
| `bin/render.ml` | All terminal text | Danny |
| `test/test_<module>.ml` | One test suite per `lib` module | module owner |

## Working on your part

This is only a skeleton RIGHT NOW

- Each `.mli` file is the spec and the contract between teammates. Read it
  before you write the matching `.ml`. Discuss any change to an `.mli` with
  the team first, since other modules depend on it.
- In each `.ml`, every function body is a stub:
  `failwith "TODO (Task N, Name): ..."`. Search for `TODO` to find yours.
- Where a type is hidden in the `.mli` (e.g. `Portfolio.t`), the `.ml` has a
  placeholder `type t = unit`. Replace it with the representation you choose.
- Each `test/test_<module>.ml` has an empty `tests` list. Add your tests
  there.
- `dune build` and `dune test` pass with the stubs. `dune exec` will not play
  a game until the stubs are filled in.
- Prices are whole cents (`int`).
- Randomness always comes from a `Random.State.t` passed in, so tests can
  use a fixed seed and get the same result every time.
