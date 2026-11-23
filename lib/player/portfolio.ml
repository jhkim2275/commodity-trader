open Types

type t = {
  cash : price;
  held : (commodity * int) list;
}

type error =
  | Invalid_quantity
  | Insufficient_cash
  | Insufficient_holdings

let create ~cash = { cash; held = List.map (fun c -> (c, 0)) Commodity.all }
let cash p = p.cash
let holding p c = List.assoc c p.held
let holdings p = List.filter (fun (_, n) -> n <> 0) p.held

(** [update_holding p c f] is [p] after one trade of [c]: the number of units of
    [c] changes from [n] to [f n] and everything else stays the same. *)
let update_holding p c f =
  {
    p with
    held =
      List.map (fun (c', n) -> if c' = c then (c', f n) else (c', n)) p.held;
  }

let buy p c ~qty ~ask =
  if qty <= 0 then Error Invalid_quantity
  else
    let cost = qty * ask in
    if cost > p.cash then Error Insufficient_cash
    else
      let p' = update_holding p c (fun n -> n + qty) in
      Ok { p' with cash = p.cash - cost }

let sell p c ~qty ~bid =
  if qty <= 0 then Error Invalid_quantity
  else if qty > holding p c then Error Insufficient_holdings
  else
    let p' = update_holding p c (fun n -> n - qty) in
    Ok { p' with cash = p.cash + (qty * bid) }

let net_worth p price_of =
  List.fold_left (fun acc (c, n) -> acc + (n * price_of c)) p.cash p.held

let error_to_string = function
  | Invalid_quantity -> "Quantity must be a positive whole number."
  | Insufficient_cash -> "Not enough cash for that trade."
  | Insufficient_holdings -> "You don't own that many units."
