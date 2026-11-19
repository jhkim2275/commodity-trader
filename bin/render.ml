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

let time_left secs = failwith "TODO (Task 5, Danny): Render.time_left"
let market g = failwith "TODO (Task 1, Danny): Render.market"
let portfolio g = failwith "TODO (Task 2, Danny): Render.portfolio"
let status ~now g = failwith "TODO (Task 1, Danny): Render.status"
let game_over reason g = failwith "TODO (Task 9, Danny): Render.game_over"
