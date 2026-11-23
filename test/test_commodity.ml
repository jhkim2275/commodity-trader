open OUnit2
open Commodity_trader
open Types

(** [opt_printer o] is [o] as a string, e.g. ["Some wheat"] or ["None"], for
    showing what went wrong when a parsing test fails. *)
let opt_printer = function
  | None -> "None"
  | Some c -> "Some " ^ Commodity.to_string c

(** [parse_test name expected s] is a test named [name] checking that
    [Commodity.of_string s] reads the player's input [s] as [expected]. *)
let parse_test name expected s =
  name >:: fun _ ->
  assert_equal expected (Commodity.of_string s) ~printer:opt_printer

let tests =
  "Commodity"
  >::: [
         ( "to_string names every commodity in display order" >:: fun _ ->
           assert_equal
             [ "wheat"; "oil"; "gold"; "lumber"; "cattle" ]
             (List.map Commodity.to_string Commodity.all)
             ~printer:(String.concat ", ") );
         parse_test "lowercase" (Some Wheat) "wheat";
         parse_test "capitalized" (Some Oil) "Oil";
         parse_test "uppercase with spaces" (Some Gold) "  GOLD  ";
         parse_test "mixed case" (Some Lumber) "LuMbEr";
         parse_test "unknown name" None "copper";
         parse_test "empty string" None "";
         parse_test "only spaces" None "   ";
         parse_test "space inside the word" None "cat tle";
         ( "of_string inverts to_string" >:: fun _ ->
           List.iter
             (fun c ->
               assert_equal (Some c)
                 (Commodity.of_string (Commodity.to_string c))
                 ~printer:opt_printer)
             Commodity.all );
         ( "starting values are positive" >:: fun _ ->
           List.iter
             (fun c ->
               assert_bool (Commodity.to_string c)
                 (Commodity.starting_value c > 0))
             Commodity.all );
       ]
