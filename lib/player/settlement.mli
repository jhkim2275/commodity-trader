(** Ending a run: why it ended, and selling every holding for cash.

    Owner: Shreya (MS1 Task 9). When a run ends, every holding is sold at the
    current bid, so the player finishes with only cash. *)

(** Why a run ended. *)
type reason =
  | Time_up  (** The clock reached 0. *)
  | Player_quit  (** The player typed [quit]. *)

val reason_to_string : reason -> string

val liquidate :
  Portfolio.t -> sale_price:(Types.commodity -> Types.price) -> Types.price
(** [liquidate p ~sale_price] is the final cash after selling every holding in
    [p] at [sale_price c] per unit. The game passes the current bid as
    [sale_price]. *)
