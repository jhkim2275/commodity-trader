(* End-of-run liquidation. Owner: Shreya (Task 9). See settlement.mli for the
   spec. *)

type reason =
  | Time_up
  | Player_quit

let reason_to_string = function
  | Time_up -> "Time ran out."
  | Player_quit -> "You ended the run."

let liquidate p ~sale_price =
  failwith "TODO (Task 9, Shreya): Settlement.liquidate"
