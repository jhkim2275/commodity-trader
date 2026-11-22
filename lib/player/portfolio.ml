open Types

type t = {
  cash : price;
  held : (commodity * int) list;
}

type error =
  | Invalid_quantity
  | Insufficient_cash
  | Insufficient_holdings

(** [create ~cash] is a new player's portfolio with [cash] cents and 0 units
    of every commodity. *)
let create ~cash = { cash; held = List.map (fun c -> (c, 0)) Commodity.all }

(** [cash p] is the cash in [p], in cents, that the player has left to
    spend. *)
let cash p = p.cash

(** [holding p c] is how many units of [c] the player owns in [p], which is
    the most they can sell. *)
let holding p c = List.assoc c p.held

(** [holdings p] is every [(c, n)] in [p] with [n > 0] in display order, so
    only the commodities the player actually owns. *)
let holdings p = List.filter (fun (_, n) -> n <> 0) p.held

(** [update_holding p c f] is [p] after one trade of [c]: the number of units
    of [c] changes from [n] to [f n] and everything else stays the same. *)
let update_holding p c f =
  {
    p with
    held = List.map (fun (c', n) -> if c' = c then (c', f n) else (c', n)) p.held;
  }

(** [buy p c ~qty ~ask] is [Ok] of [p] after buying [qty] units of [c] at the
    ask, with [qty * ask] less cash, or [Error Invalid_quantity] if
    [qty <= 0], or [Error Insufficient_cash] if the player cannot afford
    [qty * ask]. *)
let buy p c ~qty ~ask =
  if qty <= 0 then Error Invalid_quantity
  else
    let cost = qty * ask in
    if cost > p.cash then Error Insufficient_cash
    else
      let p' = update_holding p c (fun n -> n + qty) in
      Ok { p' with cash = p.cash - cost }

(** [sell p c ~qty ~bid] is [Ok] of [p] after selling [qty] units of [c] at
    the bid, with [qty * bid] more cash, or [Error Invalid_quantity] if
    [qty <= 0], or [Error Insufficient_holdings] if the player owns fewer than
    [qty] units of [c]. *)
let sell p c ~qty ~bid =
  if qty <= 0 then Error Invalid_quantity
  else if qty > holding p c then Error Insufficient_holdings
  else
    let p' = update_holding p c (fun n -> n - qty) in
    Ok { p' with cash = p.cash + (qty * bid) }

(** [net_worth p price_of] is the total value of the player's cash and
    holdings, with each unit of [c] valued at [price_of c]. *)
let net_worth p price_of =
  List.fold_left (fun acc (c, n) -> acc + (n * price_of c)) p.cash p.held

(** [error_to_string e] is the message telling the player why their trade was
    rejected with [e]. *)
let error_to_string = function
  | Invalid_quantity -> "Quantity must be a positive whole number."
  | Insufficient_cash -> "Not enough cash for that trade."
  | Insufficient_holdings -> "You don't own that many units."
