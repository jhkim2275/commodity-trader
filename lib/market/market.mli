(** The hidden "true value" of each commodity for the current day.

    The player never sees these numbers. Bots quote bids and asks around them
    (see [Bot]). *)

type t

val init : unit -> t
(** [init ()] sets every true value to [Commodity.starting_value]. *)

val true_value : t -> Types.commodity -> Types.price
(** [true_value m c] is today's hidden value of [c]. Always positive. *)

val apply_headline : Random.State.t -> Headline.t -> t -> t
(** [apply_headline rng h m] is the next day's market. Commodities in
    [h.effects] move by their [pct_change]; every other commodity gets a smaller
    random drift from [rng]. True values must stay positive. *)
