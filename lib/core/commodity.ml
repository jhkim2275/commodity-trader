open Types

type t = commodity

(** [all] is every commodity in display order: wheat, oil, gold, lumber, and
    cattle. *)
let all = [ Wheat; Oil; Gold; Lumber; Cattle ]

(** [to_string c] is the lowercase name of [c] that the player sees and types,
    e.g. ["wheat"]. *)
let to_string = function
  | Wheat -> "wheat"
  | Oil -> "oil"
  | Gold -> "gold"
  | Lumber -> "lumber"
  | Cattle -> "cattle"

(** [of_string s] is [Some c] if [s], ignoring case and surrounding
    whitespace, is the name of [c], or [None] if the player typed something
    that is not a commodity. *)
let of_string s =
  let name = String.lowercase_ascii (String.trim s) in
  List.find_opt (fun c -> to_string c = name) all

(** [starting_value c] is the hidden true value of [c] in cents on the first
    day, before any headline has moved it. *)
let starting_value = function
  | Wheat -> 600
  | Oil -> 7_500
  | Gold -> 200_000
  | Lumber -> 50_000
  | Cattle -> 18_000
