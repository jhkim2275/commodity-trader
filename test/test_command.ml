(* Tests for Command. *)

open OUnit2
open Commodity_trader
open Types

(** [parses name cases] is a test that [Command.parse input] gives [expected]
    for every [(input, expected)] in [cases]. *)
let parses name cases =
  name >:: fun _ ->
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
         parses "buy and sell take a commodity and a quantity"
           [
             ("buy wheat 5", Ok (Command.Buy (Wheat, 5)));
             ("  SELL   Oil  90 ", Ok (Command.Sell (Oil, 90)));
             ("buy\twheat \t5", Ok (Command.Buy (Wheat, 5)));
           ];
         parses "bad commodities and quantities are rejected"
           [
             ("buy coal 5", Error "Unknown commodity: coal");
             ("sell gold 0", Error "Quantity must be a positive whole number: 0");
             ( "buy gold -1",
               Error "Quantity must be a positive whole number: -1" );
             ( "buy gold 0x10",
               Error "Quantity must be a positive whole number: 0x10" );
             ( "buy gold 99999999999999999999",
               Error
                 "Quantity must be a positive whole number: \
                  99999999999999999999" );
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
