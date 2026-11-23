(** The whole state of one run, and how commands change it.

    This module ties the others together: it is the only place that should know
    about all of them. It is pure. Timers, input, and printing live in [bin/].
*)

type t = {
  duration : Types.duration;  (** The length the player picked. *)
  day : int;  (** 0 before the first headline, then 1, 2, ... *)
  headlines_reached : int;  (** Score: headlines the player has seen. *)
  headline : Headline.t option;  (** Today's headline ([None] on day 0). *)
  deck : Headline.deck;  (** Headlines not yet shown. *)
  market : Market.t;  (** Hidden true values for today. *)
  bots : (Types.commodity * Bot.t) list;  (** One bot per commodity. *)
  portfolio : Portfolio.t;  (** Player's cash and holdings. *)
  clock : Clock.t;  (** Countdown to the end of the run. *)
  rng : Random.State.t;
      (** All randomness comes from here. A fixed seed gives the same results
          for the same sequence of calls. In a live game the bot ticker runs on
          a timer, so how many ticks happen between commands can vary. *)
}

val starting_cash : Types.price
(** Cash at the start of every run ($10,000). *)

val create : seed:int -> duration:Types.duration -> now:float -> t
(** [create ~seed ~duration ~now] is a fresh run: starting cash, no holdings,
    day 0, clock started at [now]. *)

val quote : t -> Types.commodity -> Types.quote
(** [quote g c] is the bid and ask the player can trade [c] at right now. *)

val quotes : t -> (Types.commodity * Types.quote) list
(** [quotes g] is the current quote for every commodity, in display order. *)

val tick_bots : t -> t
(** [tick_bots g] moves every bot's quote once. [bin/loop.ml] calls this every
    second. *)

val apply : Command.t -> t -> t * string list
(** [apply cmd g] runs a command that changes the game ([Buy], [Sell], [Next])
    and returns the new state plus messages to show the player. Display-only
    commands ([Status], [Help], [Quit]) are handled by the terminal, and return
    [g] unchanged. *)

val final_cash : t -> Types.price
(** [final_cash g] is the player's cash after selling every holding at its
    current bid (uses [Settlement.liquidate]). Shown when the run ends. *)
