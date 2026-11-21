(* Tests for Command. Owner: Connie (Task 1). *)

open OUnit2
open Commodity_trader
open Types

(* Buy and sell call [Commodity.of_string], which is still a stub (Shreya). Until
   it lands, tests that need it are skipped instead of failing. TODO (Connie):
   once [Commodity.of_string] is merged, remove this guard and
   [~needs_of_string] so those tests always run. *)
let of_string_ready =
  match Commodity.of_string "wheat" with
  | _ -> true
  | exception Failure _ -> false

(* [parses name cases] is a test that [Command.parse input] gives [expected] for
   every [(input, expected)] in [cases]. With [~needs_of_string:true] it is
   skipped until [Commodity.of_string] is implemented. *)
let parses ?(needs_of_string = false) name cases =
  name >:: fun _ ->
  skip_if
    (needs_of_string && not of_string_ready)
    "waiting on Commodity.of_string (Shreya)";
  List.iter
    (fun (input, expected) ->
      assert_equal ~msg:input expected (Command.parse input))
    cases

let tests =
  "Command"
  >::: [
         parses "one-word commands ignore case and extra spaces"
           [
             ("next", Ok Command.Next);
             ("STATUS", Ok Command.Status);
             ("  Help  ", Ok Command.Help);
             ("quit", Ok Command.Quit);
           ];
         parses ~needs_of_string:true
           "buy and sell take a commodity and a quantity"
           [
             ("buy wheat 5", Ok (Command.Buy (Wheat, 5)));
             ("  SELL   Oil  12 ", Ok (Command.Sell (Oil, 12)));
           ];
         parses ~needs_of_string:true
           "bad commodities and quantities are rejected"
           [
             ("buy coal 5", Error "Unknown commodity: coal");
             ("sell gold 0", Error "Quantity must be a positive whole number: 0");
             ("buy gold -1", Error "Quantity must be a positive whole number: -1");
             ( "buy gold 0x10",
               Error "Quantity must be a positive whole number: 0x10" );
             ( "buy gold 99999999999999999999",
               Error
                 "Quantity must be a positive whole number: 99999999999999999999"
             );
           ];
         parses "empty, incomplete, and unknown input is rejected"
           [
             ("", Error "Type a command, or help to see them all.");
             ("   ", Error "Type a command, or help to see them all.");
             ("buy wheat", Error "Usage: buy <commodity> <qty>");
             ("sell", Error "Usage: sell <commodity> <qty>");
             (" Dance ", Error "Unknown command: Dance. Type help.");
             ("next now", Error "Unknown command: next now. Type help.");
           ];
       ]
