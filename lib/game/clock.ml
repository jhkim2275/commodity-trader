(* Game clock. Owner: Connie (Task 5). See clock.mli for the spec. *)

(* TODO (Task 5, Connie): choose a representation for the clock. *)
type t = unit

let duration_seconds = function
  | Types.Two_min -> 120.
  | Types.Five_min -> 300.
  | Types.Ten_min -> 600.

let create d ~now = failwith "TODO (Task 5, Connie): Clock.create"
let remaining c ~now = failwith "TODO (Task 5, Connie): Clock.remaining"
let expired c ~now = failwith "TODO (Task 5, Connie): Clock.expired"
