(* Tests for Clock. Owner: Connie (Task 5). *)

open OUnit2
open Commodity_trader
open Types

(* A 2 minute clock started at time 100, so its deadline is 220. *)
let clock = Clock.create Two_min ~now:100.

let tests =
  "Clock"
  >::: [
         ( "each duration has the right length in seconds" >:: fun _ ->
           assert_equal [ 120.; 300.; 600. ]
             (List.map Clock.duration_seconds [ Two_min; Five_min; Ten_min ])
         );
         ( "remaining counts down and never goes below 0" >:: fun _ ->
           assert_equal [ 120.; 60.; 0.; 0. ]
             (List.map
                (fun now -> Clock.remaining clock ~now)
                [ 100.; 160.; 220.; 500. ]) );
         ( "expired is true at or after the deadline" >:: fun _ ->
           assert_equal [ false; false; true; true ]
             (List.map
                (fun now -> Clock.expired clock ~now)
                [ 100.; 219.9; 220.; 500. ]) );
       ]
