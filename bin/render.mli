(** Turning game state into text for the terminal.

    Owner: Danny (MS1 Task 1). Teammates who need something new shown ask Danny
    to add it here. Every function returns a string; [Loop] does the printing.
*)

open Commodity_trader

val welcome : string
(** Shown once when the program starts. *)

val help : string
(** The list of commands, for the [help] command. *)

val time_left : float -> string
(** [time_left secs] formats seconds as ["m:ss"]. *)

val market : Game.t -> string
(** A table with one row per commodity: name, bid, ask. *)

val portfolio : Game.t -> string
(** Cash and nonzero holdings. *)

val status : now:float -> Game.t -> string
(** Headline, day, headlines reached, time left, market, and portfolio. *)

val game_over : Settlement.reason -> Game.t -> string
(** The end-of-run summary: why it ended, headlines reached, game length, and
    final cash ([Game.final_cash]). *)
