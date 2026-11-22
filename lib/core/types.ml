type commodity =
  | Wheat
  | Oil
  | Gold
  | Lumber
  | Cattle

type price = int

type quote = {
  bid : price;
  ask : price;
}

type duration =
  | Two_min
  | Five_min
  | Ten_min

(** [string_of_price p] is [p] cents written as dollars with exactly two digits
    of cents and the minus sign before the ["$"] indicating a negative value, e.g. [123456] is
    ["$1234.56"] and [-50] is ["-$0.50"]. *)
let string_of_price p =
  let sign = if p < 0 then "-" else "" in
  let a = abs p in
  Printf.sprintf "%s$%d.%02d" sign (a / 100) (a mod 100)

(** [string_of_duration d] is ["2 min"], ["5 min"], or ["10 min"], indicating game length options. *)
let string_of_duration = function
  | Two_min -> "2 min"
  | Five_min -> "5 min"
  | Ten_min -> "10 min"
