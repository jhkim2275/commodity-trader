open Types

type t = {
  duration : duration;
  day : int;
  headlines_reached : int;
  headline : Headline.t option;
  deck : Headline.deck;
  market : Market.t;
  bots : (commodity * Bot.t) list;
  portfolio : Portfolio.t;
  clock : Clock.t;
  rng : Random.State.t;
}

let starting_cash = 1_000_000

let create ~seed ~duration ~now =
  let rng = Random.State.make [| seed |] in
  let market = Market.init () in
  let bots =
    List.map
      (fun c -> (c, Bot.create rng ~true_value:(Market.true_value market c)))
      Commodity.all
  in
  {
    duration;
    day = 0;
    headlines_reached = 0;
    headline = None;
    deck = Headline.new_deck ();
    market;
    bots;
    portfolio = Portfolio.create ~cash:starting_cash;
    clock = Clock.create duration ~now;
    rng;
  }

let quote g c = Bot.quote (List.assoc c g.bots)
let quotes g = List.map (fun c -> (c, quote g c)) Commodity.all

let tick_bots g =
  { g with bots = List.map (fun (c, b) -> (c, Bot.tick g.rng b)) g.bots }

(** [trade_message verb c qty price] is e.g. "Bought 5 wheat at $6.12 each." *)
let trade_message verb c qty price =
  Printf.sprintf "%s %d %s at %s each." verb qty (Commodity.to_string c)
    (string_of_price price)

(** [after_trade g c qty price verb result] is the game after a buy or sell: the
    new portfolio on success, or [g] unchanged with the reason on failure. *)
let after_trade g c qty price verb = function
  | Ok portfolio -> ({ g with portfolio }, [ trade_message verb c qty price ])
  | Error e -> (g, [ Portfolio.error_to_string e ])

(** [next_day g] draws the next headline, moves the hidden market, and
    re-centers every bot on its commodity's new true value. *)
let next_day g =
  let headline, deck = Headline.draw g.deck in
  let market = Market.apply_headline g.rng headline g.market in
  let bots =
    List.map
      (fun (c, b) ->
        (c, Bot.reset g.rng ~true_value:(Market.true_value market c) b))
      g.bots
  in
  let day = g.day + 1 in
  ( {
      g with
      day;
      headlines_reached = g.headlines_reached + 1;
      headline = Some headline;
      deck;
      market;
      bots;
    },
    [ Printf.sprintf "Day %d: %s" day headline.text ] )

let apply (cmd : Command.t) g =
  match cmd with
  | Buy (c, qty) ->
      let { ask; _ } = quote g c in
      after_trade g c qty ask "Bought" (Portfolio.buy g.portfolio c ~qty ~ask)
  | Sell (c, qty) ->
      let { bid; _ } = quote g c in
      after_trade g c qty bid "Sold" (Portfolio.sell g.portfolio c ~qty ~bid)
  | Next -> next_day g
  | Status | Help | Quit -> (g, [])

let final_cash g =
  Settlement.liquidate g.portfolio ~sale_price:(fun c -> (quote g c).bid)
