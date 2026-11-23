open OUnit2
open Commodity_trader
open Types

(** [price_test name expected p] is a test named [name] checking that
    [string_of_price p] formats the price as [expected]. *)
let price_test name expected p =
  name >:: fun _ -> assert_equal expected (string_of_price p) ~printer:Fun.id

(** [duration_test name expected d] is a test named [name] checking that
    [string_of_duration d] shows the game length as [expected]. *)
let duration_test name expected d =
  name >:: fun _ -> assert_equal expected (string_of_duration d) ~printer:Fun.id

let tests =
  "Types"
  >::: [
         price_test "dollars and cents" "$1234.56" 123456;
         price_test "zero" "$0.00" 0;
         price_test "single cent pads to two digits" "$0.05" 5;
         price_test "whole dollar" "$1.00" 100;
         price_test "just under a dollar" "$0.99" 99;
         price_test "negative cents" "-$0.50" (-50);
         price_test "negative dollars" "-$1234.56" (-123456);
         price_test "starting cash" "$10000.00" 1_000_000;
         duration_test "two minutes" "2 min" Two_min;
       ]
