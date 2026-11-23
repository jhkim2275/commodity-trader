# Commodity Trader

A single-player terminal game. Trade wheat, oil, gold, lumber, and cattle
against bots while news headlines move prices. Get through as many headlines
as you can before the clock runs out. Final cash breaks ties.

Team **Traders**, CS 3110. See [AUTHORS.md](AUTHORS.md).

## Build and run

Install the dependencies once:

```bash
opam install dune lwt ounit2 bisect_ppx
```

Then:

```bash
dune build
```

```bash
dune exec commodity_trader
```

```bash
dune test
```

## Test coverage

Run the tests with [bisect_ppx](https://github.com/aantron/bisect_ppx), then
make a report. Use `dune exec` rather than `dune test`, because `dune test`
runs in a sandbox and discards the coverage files.

```bash
dune exec --instrument-with bisect_ppx test/test_main.exe
bisect-ppx-report summary --per-file
bisect-ppx-report html
```

`summary` prints coverage per file. `html` writes a line-by-line report to
`_coverage/index.html`.

## How the game plays

1. Choose a 2, 5, or 10 minute game.
2. Each "day" shows a news headline. Bots quote a bid and an ask for every
   commodity, and the quotes move every second.
3. Type `buy <commodity> <qty>` or `sell <commodity> <qty>`, `status` to see
   the market, and `next` for the next headline.
4. When time runs out (or you `quit`), everything you hold is sold at the
   current bid. Your score is headlines reached, then final cash.

## Planned features

Pause/resume, price history, trading-term tips, a saved leaderboard, replay,
more bots, and a web version.
