(* Shared types. Owner: Shreya (Task 1). See types.mli for the spec. *)

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

let string_of_price p = failwith "TODO (Task 1, Shreya): Types.string_of_price"

let string_of_duration = function
  | Two_min -> "2 min"
  | Five_min -> "5 min"
  | Ten_min -> "10 min"
