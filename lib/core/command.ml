(* Command parsing. Owner: Connie (Task 1). See command.mli for the spec. *)

type t =
  | Buy of Types.commodity * int
  | Sell of Types.commodity * int
  | Next
  | Status
  | Help
  | Quit

let parse s = failwith "TODO (Task 1, Connie): Command.parse"
