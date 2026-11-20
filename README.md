# Commodity Trader

A single-player terminal game. Trade wheat, oil, gold, lumber, and cattle
against bots while news headlines move prices. Get through as many headlines
as you can before the clock runs out. Final cash breaks ties.

Team **Traders**, CS 3110. See [AUTHORS.md](AUTHORS.md).

## Build and run

Install the dependencies once:

```bash
opam install dune lwt ounit2
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
