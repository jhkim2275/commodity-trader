(* One quoting bot per commodity. Owner: Wyatt (Task 4). See bot.mli for the
   spec. *)

open Types

(* TODO (Task 4, Wyatt): choose a representation for a bot. *)
type t = unit

let max_deviation = 0.20
let create rng ~true_value = failwith "TODO (Task 4, Wyatt): Bot.create"
let tick rng b = failwith "TODO (Task 4, Wyatt): Bot.tick"
let reset rng ~true_value b = failwith "TODO (Task 4, Wyatt): Bot.reset"
let true_value b = failwith "TODO (Task 4, Wyatt): Bot.true_value"
let quote b = failwith "TODO (Task 4, Wyatt): Bot.quote"
