(** The live game loop, built on Lwt.

    Owner: Wyatt (MS1 Tasks 4, 5). Three Lwt promises run at once, and the run
    ends as soon as one of them finishes:
    - the input reader, which parses and runs commands as they are typed;
    - the bot ticker, which moves quotes every [tick_interval] seconds;
    - the deadline watcher, which ends the run when the clock expires.

    The current game lives in a [ref] that all three share. Lwt runs on a single
    thread, so they never touch it at the same moment. *)

open Commodity_trader

val tick_interval : float
(** Seconds between bot quote updates (1.0). *)

val now : unit -> float
(** The current wall-clock time in seconds. *)

val run : Game.t ref -> Settlement.reason Lwt.t
(** [run game] plays until the player quits, input ends, or time runs out, and
    resolves to the reason the run ended. *)
