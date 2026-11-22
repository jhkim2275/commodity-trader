open Types

type t = commodity

let all = [ Wheat; Oil; Gold; Lumber; Cattle ]

let to_string = function
  | Wheat -> "wheat"
  | Oil -> "oil"
  | Gold -> "gold"
  | Lumber -> "lumber"
  | Cattle -> "cattle"

let of_string s =
  let name = String.lowercase_ascii (String.trim s) in
  List.find_opt (fun c -> to_string c = name) all

let starting_value = function
  | Wheat -> 600
  | Oil -> 7_500
  | Gold -> 200_000
  | Lumber -> 50_000
  | Cattle -> 18_000
