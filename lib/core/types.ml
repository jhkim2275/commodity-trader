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

let string_of_price p =
  let sign = if p < 0 then "-" else "" in
  let a = abs p in
  Printf.sprintf "%s$%d.%02d" sign (a / 100) (a mod 100)

let string_of_duration = function
  | Two_min -> "2 min"
  | Five_min -> "5 min"
  | Ten_min -> "10 min"
