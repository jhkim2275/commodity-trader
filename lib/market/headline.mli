(** News headlines and the deck they are drawn from.

    Owner: Junghoon (MS1 Task 3). A headline carries the numbers that move the
    hidden true value of each commodity it mentions. *)

type impact = {
  commodity : Types.commodity;
  pct_change : float;
      (** Change to the true value: [0.25] is +25%, [-0.10] is -10%. *)
}

type t = {
  text : string;  (** What the player reads, e.g. "Forest fires hit ...". *)
  effects : impact list;  (** Commodities this headline moves. *)
}

val all : t list
(** Every headline in the game. MS1 requires at least 10. *)

type deck
(** The headlines not yet shown in the current pass through [all]. *)

val new_deck : unit -> deck
(** [new_deck ()] is a full deck of [all], in the order they are listed. *)

val draw : deck -> t * deck
(** [draw d] is the top headline and the rest of the deck. When [d] is empty it
    is refreshed with [new_deck ()] first, so play never runs out. *)

val remaining : deck -> int
(** [remaining d] is how many headlines are left before a refresh. *)
