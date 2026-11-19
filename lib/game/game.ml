(* Game state and command handling. Owner: Junghoon (Tasks 1, 3, 9), except
   [tick_bots] (Wyatt, Task 4). See game.mli for the spec. *)

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
  failwith "TODO (Task 1, Junghoon): Game.create"

let quote g c = failwith "TODO (Task 1, Junghoon): Game.quote"
let quotes g = failwith "TODO (Task 1, Junghoon): Game.quotes"
let tick_bots g = failwith "TODO (Task 4, Wyatt): Game.tick_bots"
let apply cmd g = failwith "TODO (Task 1, Junghoon): Game.apply"
let final_cash g = failwith "TODO (Task 9, Junghoon): Game.final_cash"
