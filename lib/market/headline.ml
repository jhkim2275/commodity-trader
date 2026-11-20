(* Headlines and the deck. Owner: Junghoon (Task 3). See headline.mli for the
   spec. *)

open Types

type impact = {
  commodity : commodity;
  pct_change : float;
}

type t = {
  text : string;
  effects : impact list;
}

(* Two examples of the format. TODO (Task 3, Junghoon): add at least 8 more (MS1
   requires 10), including some that lower prices. *)
let all =
  [
    {
      text = "Forest fires hit the Pacific Northwest";
      effects =
        [
          { commodity = Lumber; pct_change = 0.25 };
          { commodity = Cattle; pct_change = -0.03 };
        ];
    };
    {
      text = "OPEC announces surprise production cuts";
      effects =
        [
          { commodity = Oil; pct_change = 0.15 };
          { commodity = Wheat; pct_change = 0.02 };
        ];
    };
  ]

(* TODO (Task 3, Junghoon): choose a representation for a deck. *)
type deck = unit

let new_deck () = failwith "TODO (Task 3, Junghoon): Headline.new_deck"
let draw d = failwith "TODO (Task 3, Junghoon): Headline.draw"
let remaining d = failwith "TODO (Task 3, Junghoon): Headline.remaining"
