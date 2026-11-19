(* Commodity helpers. Owner: Shreya (Task 1). See commodity.mli for the spec. *)

open Types

type t = commodity

let all = [ Wheat; Oil; Gold; Lumber; Cattle ]

let to_string = function
  | Wheat -> "wheat"
  | Oil -> "oil"
  | Gold -> "gold"
  | Lumber -> "lumber"
  | Cattle -> "cattle"

let of_string s = failwith "TODO (Task 1, Shreya): Commodity.of_string"

(* Rough real-world prices, in cents. Retune as a team if needed. *)
let starting_value = function
  | Wheat -> 600 (* $6.00 / bushel *)
  | Oil -> 7_500 (* $75.00 / barrel *)
  | Gold -> 200_000 (* $2000.00 / ounce *)
  | Lumber -> 50_000 (* $500.00 / 1000 board feet *)
  | Cattle -> 18_000 (* $180.00 / hundredweight *)
