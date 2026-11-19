(* The Lwt game loop. Owner: Wyatt (Tasks 4, 5). See loop.mli for the spec. *)

open Commodity_trader
open Lwt.Syntax

let tick_interval = 1.0
let now () = failwith "TODO (Task 5, Wyatt): Loop.now"

(* TODO: build [run] from three Lwt promises combined with [Lwt.pick]: *)
(* - an input reader that runs [Command.parse] and [Game.apply] *)
(* - a bot ticker that calls [Game.tick_bots] every [tick_interval] *)
(* - a deadline watcher that checks [Clock.expired] *)
let run game = failwith "TODO (Tasks 4, 5, Wyatt): Loop.run"
