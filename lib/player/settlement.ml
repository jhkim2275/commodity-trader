type reason =
  | Time_up
  | Player_quit

(** [reason_to_string r] is ["Time ran out."] or ["You ended the run."], the
    message shown when the run ends for reason [r]. *)
let reason_to_string = function
  | Time_up -> "Time ran out."
  | Player_quit -> "You ended the run."

(** [liquidate p ~sale_price] is the player's final cash at the end of a run:
    the cash in [p] plus every holding of [c] sold at [sale_price c] per
    unit. *)
let liquidate p ~sale_price =
  List.fold_left
    (fun acc (c, n) -> acc + (n * sale_price c))
    (Portfolio.cash p) (Portfolio.holdings p)
