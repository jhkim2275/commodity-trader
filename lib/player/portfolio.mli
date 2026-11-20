(** The player's cash and holdings, and the buy/sell accounting.

    Owner: Shreya (MS1 Task 2). Every function is pure: a rejected trade returns
    [Error] and the old portfolio is unchanged. *)

type t
(** A player's cash plus how many whole units of each commodity they hold. *)

(** Why a trade was rejected. *)
type error =
  | Invalid_quantity  (** Quantity was zero or negative. *)
  | Insufficient_cash  (** Buying would make cash negative. *)
  | Insufficient_holdings  (** Selling more units than the player owns. *)

val create : cash:Types.price -> t
(** [create ~cash] is a portfolio with [cash] and no holdings. *)

val cash : t -> Types.price
(** [cash p] is the cash on hand. *)

val holding : t -> Types.commodity -> int
(** [holding p c] is how many units of [c] the player owns (0 if none). *)

val holdings : t -> (Types.commodity * int) list
(** [holdings p] lists every commodity with a nonzero holding. *)

val buy :
  t -> Types.commodity -> qty:int -> ask:Types.price -> (t, error) result
(** [buy p c ~qty ~ask] buys [qty] units of [c] at [ask] each. *)

val sell :
  t -> Types.commodity -> qty:int -> bid:Types.price -> (t, error) result
(** [sell p c ~qty ~bid] sells [qty] units of [c] at [bid] each. *)

val net_worth : t -> (Types.commodity -> Types.price) -> Types.price
(** [net_worth p price_of] is cash plus each holding valued at [price_of c] (the
    team still has to decide whether that is the bid or the true value). *)

val error_to_string : error -> string
(** [error_to_string e] is a message to show the player. *)
