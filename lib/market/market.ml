(* Each commodity paired with its hidden true value, in cents. *)
type t = (Types.commodity * Types.price) list

let init () = List.map (fun c -> (c, Commodity.starting_value c)) Commodity.all
let true_value m c = List.assoc c m

(** Largest daily random move, as a fraction, for a commodity the headline does
    not mention: [0.03] is up to 3% either way. *)
let max_drift = 0.03

let apply_headline rng (h : Headline.t) m =
  List.map
    (fun (c, v) ->
      let pct =
        match
          List.find_opt (fun (e : Headline.impact) -> e.commodity = c) h.effects
        with
        | Some e -> e.pct_change
        | None -> Random.State.float rng (2. *. max_drift) -. max_drift
      in
      (c, max 1 (int_of_float (float_of_int v *. (1. +. pct)))))
    m
