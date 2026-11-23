open Types

type impact = {
  commodity : commodity;
  pct_change : float;
}

type t = {
  text : string;
  effects : impact list;
}

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
    {
      text = "Farmers have a very high crop yield";
      effects =
        [
          { commodity = Wheat; pct_change = -0.20 };
          { commodity = Cattle; pct_change = -0.04 };
        ];
    };
    {
      text = "People are looking for assets other than cash";
      effects = [ { commodity = Gold; pct_change = 0.12 } ];
    };
    {
      text = "Fewer new houses are being built";
      effects = [ { commodity = Lumber; pct_change = -0.18 } ];
    };
    {
      text = "Disease kills thousands of cattle";
      effects =
        [
          { commodity = Cattle; pct_change = 0.22 };
          { commodity = Wheat; pct_change = -0.05 };
        ];
    };
    {
      text = "A huge new oil field starts operating";
      effects = [ { commodity = Oil; pct_change = -0.15 } ];
    };
    {
      text = "Drought dries up wheat fields";
      effects =
        [
          { commodity = Wheat; pct_change = 0.25 };
          { commodity = Cattle; pct_change = 0.08 };
        ];
    };
    {
      text = "A giant new gold mine opens";
      effects = [ { commodity = Gold; pct_change = -0.12 } ];
    };
    {
      text = "A hurricane destroys thousands of homes";
      effects = [ { commodity = Lumber; pct_change = 0.20 } ];
    };
  ]

(* A deck is the headlines not yet shown, top first. *)
type deck = t list

let new_deck () = all

let draw d =
  match if d = [] then new_deck () else d with
  | h :: rest -> (h, rest)
  | [] -> failwith "Headline.draw: [all] is empty"

let remaining d = List.length d
