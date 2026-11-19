(* Cash, holdings, and trade accounting. Owner: Shreya (Task 2). See
   portfolio.mli for the spec. *)

open Types

(* TODO (Task 2, Shreya): choose a representation for a portfolio. *)
type t = unit

type error =
  | Invalid_quantity
  | Insufficient_cash
  | Insufficient_holdings

let create ~cash = failwith "TODO (Task 2, Shreya): Portfolio.create"
let cash p = failwith "TODO (Task 2, Shreya): Portfolio.cash"
let holding p c = failwith "TODO (Task 2, Shreya): Portfolio.holding"
let holdings p = failwith "TODO (Task 2, Shreya): Portfolio.holdings"
let buy p c ~qty ~ask = failwith "TODO (Task 2, Shreya): Portfolio.buy"
let sell p c ~qty ~bid = failwith "TODO (Task 2, Shreya): Portfolio.sell"
let net_worth p price_of = failwith "TODO (Task 2, Shreya): Portfolio.net_worth"

let error_to_string = function
  | Invalid_quantity -> "Quantity must be a positive whole number."
  | Insufficient_cash -> "Not enough cash for that trade."
  | Insufficient_holdings -> "You don't own that many units."
