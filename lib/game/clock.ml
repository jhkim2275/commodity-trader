(* The time the run ends, in the same seconds as [~now]. *)
type t = float

let duration_seconds = function
  | Types.Two_min -> 120.
  | Types.Five_min -> 300.
  | Types.Ten_min -> 600.

let create d ~now = now +. duration_seconds d
let remaining deadline ~now = Float.max 0. (deadline -. now)
let expired deadline ~now = now >= deadline
