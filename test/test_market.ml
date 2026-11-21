(* Tests for Market. Owner: Junghoon (Task 3). *)

open OUnit2
open Commodity_trader
open Types

(* [lumber_after pct] is Lumber's true value after a headline that moves only
   Lumber by [pct], starting from [Market.init ()]. *)
let lumber_after pct =
  let h : Headline.t =
    { text = "Test"; effects = [ { commodity = Lumber; pct_change = pct } ] }
  in
  Market.true_value
    (Market.apply_headline (Random.State.make [| 42 |]) h (Market.init ()))
    Lumber

let tests =
  "Market"
  >::: [
         ( "a headline moves what it mentions; the rest drift a little"
         >:: fun _ ->
           let m = Market.init () in
           assert_equal
             (Commodity.starting_value Lumber)
             (Market.true_value m Lumber);
           let h : Headline.t =
             {
               text = "Test";
               effects = [ { commodity = Lumber; pct_change = 0.25 } ];
             }
           in
           let m' = Market.apply_headline (Random.State.make [| 42 |]) h m in
           assert_equal 62_500 (Market.true_value m' Lumber);
           let wheat = Market.true_value m' Wheat in
           assert_bool "wheat drifts at most 3%" (wheat >= 582 && wheat <= 618)
         );
         ( "a negative headline lowers the value" >:: fun _ ->
           assert_equal 40_000 (lumber_after (-0.20)) );
         ( "a value never drops below 1 cent" >:: fun _ ->
           assert_equal 1 (lumber_after (-1.0)) );
       ]
