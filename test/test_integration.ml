(* Integration tests: whole runs that use every module together through [Game],
   the way the terminal app does. Owner: Connie. Each module's own behavior is
   tested in its test_<module>.ml; these check that the pieces connect. *)

open OUnit2
open Commodity_trader
open Types

(* A fresh 2 minute game with a fixed seed, started at time 0. *)
let new_game () = Game.create ~seed:42 ~duration:Two_min ~now:0.

(* [play g lines] types each line in [lines] into [g], like a player at the
   prompt: [Command.parse] the line, then [Game.apply] the command. Fails the
   test if a line doesn't parse. *)
let play g lines =
  List.fold_left
    (fun g line ->
      match Command.parse line with
      | Ok cmd -> fst (Game.apply cmd g)
      | Error msg -> assert_failure msg)
    g lines

(* [check_quotes g] fails unless every quote is valid ([0 < bid < ask]) and
   inside [Bot.max_deviation] of that commodity's hidden market value. *)
let check_quotes (g : Game.t) =
  List.iter
    (fun (c, { bid; ask }) ->
      let tv = float_of_int (Market.true_value g.market c) in
      assert_bool "0 < bid < ask" (0 < bid && bid < ask);
      assert_bool "quote in band"
        (float_of_int bid >= tv *. (1. -. Bot.max_deviation)
        && float_of_int ask <= tv *. (1. +. Bot.max_deviation)))
    (Game.quotes g)

let tests =
  "Integration"
  >::: [
         ( "typed trades move cash at the live quote, and final cash matches"
         >:: fun _ ->
           let g = new_game () in
           let { ask; _ } = Game.quote g Wheat in
           let g = play g [ "buy wheat 3"; "next"; "SELL wheat 1" ] in
           let { bid; _ } = Game.quote g Wheat in
           assert_equal 1 g.headlines_reached;
           assert_equal 2 (Portfolio.holding g.portfolio Wheat);
           assert_equal
             (Game.starting_cash - (3 * ask) + bid)
             (Portfolio.cash g.portfolio);
           assert_equal
             (Portfolio.net_worth g.portfolio (fun c -> (Game.quote g c).bid))
             (Game.final_cash g) );
         ( "quotes follow the market through every headline and a deck refill"
         >:: fun _ ->
           let days = List.length Headline.all + 1 in
           let g =
             List.fold_left
               (fun g _ ->
                 let g = play g [ "next" ] in
                 check_quotes g;
                 let g = Game.tick_bots (Game.tick_bots g) in
                 check_quotes g;
                 g)
               (new_game ())
               (List.init days Fun.id)
           in
           assert_equal days g.headlines_reached;
           assert_equal (Some (List.hd Headline.all)) g.headline );
         ( "a new game's clock runs for the chosen length" >:: fun _ ->
           List.iter
             (fun d ->
               let g = Game.create ~seed:1 ~duration:d ~now:50. in
               let secs = Clock.duration_seconds d in
               assert_equal secs (Clock.remaining g.clock ~now:50.);
               assert_bool "expired early"
                 (not (Clock.expired g.clock ~now:(50. +. secs -. 1.)));
               assert_bool "not expired" (Clock.expired g.clock ~now:(50. +. secs)))
             [ Two_min; Five_min; Ten_min ] );
       ]
