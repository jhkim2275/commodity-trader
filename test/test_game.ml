(* Tests for Game. Owner: Junghoon (Tasks 1, 3, 9). *)

open OUnit2
open Commodity_trader
open Types

(* A fresh game with a fixed seed, so every run is the same. *)
let new_game () = Game.create ~seed:42 ~duration:Two_min ~now:0.

(* Game calls Bot, Portfolio, Clock, and [Types.string_of_price]. Until those
   are filled in they raise [Failure "TODO ..."], so these tests are skipped
   instead of failing [dune test] for the whole team. They run automatically
   once every module they use is implemented. *)
let deps_ready =
  try
    let g = new_game () in
    let g, _ = Game.apply (Buy (Wheat, 1)) g in
    let g, _ = Game.apply (Sell (Wheat, 1)) g in
    let g, _ = Game.apply Next g in
    ignore (Game.final_cash g);
    true
  with Failure _ -> false

(* [test name f] is a test that is skipped until Game's dependencies exist. *)
let test name f =
  name >:: fun _ ->
  skip_if (not deps_ready) "waiting on Bot, Portfolio, Clock, Types";
  f ()

let tests =
  "Game"
  >::: [
         test "a new game starts on day 0 with only cash" (fun () ->
             let g = new_game () in
             assert_equal 0 g.day;
             assert_equal 0 g.headlines_reached;
             assert_equal None g.headline;
             assert_equal Commodity.all (List.map fst (Game.quotes g));
             assert_equal Game.starting_cash (Game.final_cash g));
         test "buying and selling move cash at the ask and bid" (fun () ->
             let g = new_game () in
             let { ask; _ } = Game.quote g Wheat in
             let g, msgs = Game.apply (Buy (Wheat, 2)) g in
             assert_equal 1 (List.length msgs);
             assert_equal
               (Game.starting_cash - (2 * ask))
               (Portfolio.cash g.portfolio);
             assert_equal 2 (Portfolio.holding g.portfolio Wheat);
             let { bid; _ } = Game.quote g Wheat in
             assert_equal
               (Portfolio.cash g.portfolio + (2 * bid))
               (Game.final_cash g);
             let g, _ = Game.apply (Sell (Wheat, 2)) g in
             assert_equal 0 (Portfolio.holding g.portfolio Wheat));
         test "a rejected trade leaves the game unchanged" (fun () ->
             let g = new_game () in
             (* 1000 ounces of gold costs far more than $10,000. *)
             let g', msgs = Game.apply (Buy (Gold, 1000)) g in
             assert_equal 1 (List.length msgs);
             assert_bool "game changed" (g' == g));
         test "next shows a headline and moves the market and bots" (fun () ->
             let g, msgs = Game.apply Next (new_game ()) in
             let h = List.hd Headline.all in
             assert_equal 1 g.day;
             assert_equal 1 g.headlines_reached;
             assert_equal (Some h) g.headline;
             assert_equal [ "Day 1: " ^ h.text ] msgs;
             (* The first headline raises lumber 25%, from $500.00 to
                $625.00. *)
             assert_equal 62_500 (Market.true_value g.market Lumber);
             assert_equal 62_500 (Bot.true_value (List.assoc Lumber g.bots)));
         test "display-only commands do not change the game" (fun () ->
             let g = new_game () in
             List.iter
               (fun cmd ->
                 let g', msgs = Game.apply cmd g in
                 assert_bool "game changed" (g' == g);
                 assert_equal [] msgs)
               [ Command.Status; Help; Quit ]);
         test "tick_bots ticks each commodity's own bot once" (fun () ->
             (* Bot behavior is tested in test_bot.ml; this only checks that
                every bot is ticked with the game's rng and stays with its
                commodity. *)
             let g = new_game () in
             let expected = new_game () in
             let expected =
               List.map
                 (fun (c, b) -> (c, Bot.quote (Bot.tick expected.rng b)))
                 expected.bots
             in
             assert_equal expected (Game.quotes (Game.tick_bots g)));
       ]
