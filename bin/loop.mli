(** The live game loop, built on Lwt.

    Three Lwt promises run at once, and the run ends as soon as one of them
    finishes:
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

val safe_text : (unit -> string) -> string
(** [safe_text f] is [f ()], or a "Not implemented yet" note if [f] reaches a
    teammate's unfinished stub ([Failure "TODO ..."]). This lets the game run
    while parts are still being written. *)

val run : Game.t ref -> Settlement.reason Lwt.t
(** [run game] plays until the player quits, input ends, or time runs out, and
    resolves to the reason the run ended. Bot quotes keep moving while the
    player is typing. *)
