(** Parsing what the player types into commands.

    Add a constructor here when a feature needs a new command, then handle it in
    [Game.apply] or [bin/loop.ml]. *)

type t =
  | Buy of Types.commodity * int  (** [buy wheat 5]: buy 5 at the ask. *)
  | Sell of Types.commodity * int  (** [sell oil 2]: sell 2 at the bid. *)
  | Next  (** Move on to the next headline. *)
  | Status  (** Show market, portfolio, and clock. *)
  | Help  (** List commands. *)
  | Quit  (** End the run early. *)

val parse : string -> (t, string) result
(** [parse s] turns one line of input into a command. Words are separated by
    spaces or tabs, and case is ignored. Quantities must be positive whole
    numbers. Returns [Error msg] with a message to show the player for empty,
    unknown, or malformed input. *)
