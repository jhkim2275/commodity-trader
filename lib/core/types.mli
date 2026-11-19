(** Shared types used by every module in the game.

    Owner: Shreya (MS1 Task 1). Changing a type here affects everyone, so agree
    on changes as a team first. *)

(** The five tradable commodities. *)
type commodity =
  | Wheat
  | Oil
  | Gold
  | Lumber
  | Cattle

type price = int
(** A price or amount of money in whole cents ([1234] is $12.34). Using ints
    instead of floats keeps all accounting exact. *)

type quote = {
  bid : price;  (** Highest price a bot will pay; the player SELLS here. *)
  ask : price;  (** Lowest price a bot will sell for; the player BUYS here. *)
}
(** The best bid and ask the player sees for one commodity. Invariant:
    [0 < bid < ask]. *)

(** Game lengths the player can choose before a run starts. *)
type duration =
  | Two_min
  | Five_min
  | Ten_min

val string_of_price : price -> string
(** [string_of_price p] formats cents as dollars, e.g. [123456] becomes
    ["$1234.56"] and [-50] becomes ["-$0.50"]. *)

val string_of_duration : duration -> string
(** [string_of_duration d] is ["2 min"], ["5 min"], or ["10 min"]. *)
