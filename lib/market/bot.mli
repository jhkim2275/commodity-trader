(** A bot that quotes a bid and an ask for ONE commodity around its hidden true
    value.

    Owner: Wyatt (MS1 Task 4). We start with one bot per commodity, so the
    player trades directly at this bot's quote. The bot only changes when [tick]
    or [reset] is called; the 1-second timer that calls [tick] lives in
    [bin/loop.ml] (Lwt), which keeps this module pure and testable with a seeded
    [Random.State.t]. *)

type t

val max_deviation : float
(** How far the bid or ask may wander from the true value, as a fraction: [0.20]
    means within 20%. *)

val create : Random.State.t -> true_value:Types.price -> t
(** [create rng ~true_value] is a bot quoting around [true_value]. *)

val tick : Random.State.t -> t -> t
(** [tick rng b] moves the quote randomly, as one "few seconds" update. The true
    value does not change. *)

val reset : Random.State.t -> true_value:Types.price -> t -> t
(** [reset rng ~true_value b] re-centers the bot on a new day's true value
    (called right after a new headline). *)

val true_value : t -> Types.price
(** [true_value b] is the value the bot is quoting around. Hidden from the
    player; exposed for tests and settlement. *)

val quote : t -> Types.quote
(** [quote b] is the bot's current bid and ask. Invariants: [0 < bid < ask], and
    both are within [max_deviation] of [true_value b]. *)
