(* Terminal text. Owner: Danny (Task 1). See render.mli for the spec. *)

open Commodity_trader

let welcome =
  String.concat "\n"
    [
      "=== Commodity Trader ===";
      "Trade wheat, oil, gold, lumber, and cattle as the news breaks.";
      "Reach as many headlines as you can before the clock runs out.";
    ]

(* Keep this in sync with [Command.t] when commands are added. *)
let help =
  String.concat "\n"
    [
      "Commands:";
      "  buy <commodity> <qty>    buy at the current ask";
      "  sell <commodity> <qty>   sell at the current bid";
      "  next                     move on to the next headline";
      "  status                   show market, portfolio, and time left";
      "  help                     show this list";
      "  quit                     end the run";
      "Commodities: wheat, oil, gold, lumber, cattle";
    ]

(* Rounds up, so "0:00" shows only once time is up. NaN also shows "0:00". *)
let time_left secs =
  let total = if not (secs > 0.) then 0 else int_of_float (Float.ceil secs) in
  Printf.sprintf "%d:%02d" (total / 60) (total mod 60)

(* [row name bid ask] is one line of the market table. *)
let row name bid ask = Printf.sprintf "  %-8s %10s %10s" name bid ask

(* Shows only the bots' quotes, never the hidden true values. *)
let market g =
  let rows =
    List.map
      (fun (c, ({ bid; ask } : Types.quote)) ->
        row (Commodity.to_string c)
          (Types.string_of_price bid)
          (Types.string_of_price ask))
      (Game.quotes g)
  in
  String.concat "\n"
    ("Market (you sell at the bid, buy at the ask):" :: row "" "Bid" "Ask"
   :: rows)

(* Lists holdings in [Commodity.all] order, so they stay put between trades. *)
let portfolio (g : Game.t) =
  let lines =
    List.filter_map
      (fun c ->
        match Portfolio.holding g.portfolio c with
        | 0 -> None
        | qty ->
            Some
              (Printf.sprintf "  %-8s %d %s" (Commodity.to_string c) qty
                 (if qty = 1 then "unit" else "units")))
      Commodity.all
  in
  String.concat "\n"
    (("Cash: " ^ Types.string_of_price (Portfolio.cash g.portfolio))
    :: (if lines = [] then [ "Holdings: none" ] else "Holdings:" :: lines))

(* [headline_line g] is today's headline, or a hint to type next on day 0. *)
let headline_line (g : Game.t) =
  match g.headline with
  | None -> "No headline yet. Type next for the first one."
  | Some h -> "Headline: " ^ h.text

let status ~now (g : Game.t) =
  String.concat "\n"
    [
      headline_line g;
      Printf.sprintf "Day %d | Headlines reached: %d | Time left: %s" g.day
        g.headlines_reached
        (time_left (Clock.remaining g.clock ~now));
      "";
      market g;
      "";
      portfolio g;
    ]

let game_over reason (g : Game.t) =
  String.concat "\n"
    [
      "=== Game over ===";
      Settlement.reason_to_string reason;
      Printf.sprintf "Headlines reached: %d" g.headlines_reached;
      "Game length: " ^ Types.string_of_duration g.duration;
      Printf.sprintf
        "Final cash: %s (everything sold at the bid; you started with %s)"
        (Types.string_of_price (Game.final_cash g))
        (Types.string_of_price Game.starting_cash);
    ]
