(* Tests for Bot. *)

open OUnit2
open Commodity_trader
open Types

(* A random state with a fixed seed, so tests repeat exactly. *)
let rng seed = Random.State.make [| seed |]

(* [check_quote b] fails unless the bot's quote has 0 < bid < ask and both are
   within [Bot.max_deviation] of the true value. *)
let check_quote b =
  let { bid; ask } = Bot.quote b in
  let tv = float_of_int (Bot.true_value b) in
  let show = Printf.sprintf "tv=%.0f bid=%d ask=%d" tv bid ask in
  assert_bool ("bid > 0: " ^ show) (bid > 0);
  assert_bool ("bid < ask: " ^ show) (bid < ask);
  assert_bool ("bid in band: " ^ show)
    (float_of_int bid >= tv *. (1. -. Bot.max_deviation));
  assert_bool ("ask in band: " ^ show)
    (float_of_int ask <= tv *. (1. +. Bot.max_deviation))

(* [check_centered tv b] fails unless [b] quotes around [tv]: bid < tv < ask. *)
let check_centered tv b =
  assert_equal tv (Bot.true_value b) ~printer:string_of_int;
  let { bid; ask } = Bot.quote b in
  assert_bool "bid below true value" (bid < tv);
  assert_bool "ask above true value" (ask > tv)

(* [quotes n seed tv] is the quotes of a new bot with true value [tv] after each
   of [n] ticks. *)
let quotes n seed tv =
  let r = rng seed in
  let rec go n b acc =
    if n = 0 then List.rev acc
    else
      let b = Bot.tick r b in
      go (n - 1) b (Bot.quote b :: acc)
  in
  go n (Bot.create r ~true_value:tv) []

(* True values to tick through: every starting value, plus 10 cents, the
   cheapest value whose band still fits a spread (so the mid often hits the
   edges of the band and gets clamped). *)
let tick_values = 10 :: List.map Commodity.starting_value Commodity.all

(* Every Bot test. *)
let tests =
  "Bot"
  >::: [
         ( "a new bot is centered on its true value" >:: fun _ ->
           List.iter
             (fun tv ->
               let b = Bot.create (rng 0) ~true_value:tv in
               check_centered tv b;
               check_quote b)
             tick_values );
         ( "ticks keep the quote valid and the true value fixed" >:: fun _ ->
           List.iter
             (fun tv ->
               let r = rng 7 in
               let b = ref (Bot.create r ~true_value:tv) in
               for _ = 1 to 1000 do
                 b := Bot.tick r !b;
                 check_quote !b
               done;
               assert_equal tv (Bot.true_value !b) ~printer:string_of_int)
             tick_values );
         ( "a 1-cent commodity still has 0 < bid < ask" >:: fun _ ->
           (* Too cheap for the 20% band (see bot.mli), but the quote must still
              be usable. *)
           List.iter
             (fun { bid; ask } ->
               assert_bool "bid > 0" (bid > 0);
               assert_bool "bid < ask" (bid < ask))
             (quotes 100 0 1) );
         ( "the quote stays near the true value on average" >:: fun _ ->
           (* The pull toward the true value keeps the average mid well inside
              the 20% band. *)
           let qs = quotes 2000 9 10_000 in
           let mids = List.map (fun { bid; ask } -> (bid + ask) / 2) qs in
           let avg = List.fold_left ( + ) 0 mids / List.length mids in
           assert_bool
             (Printf.sprintf "average mid %d is not within 5%% of 10000" avg)
             (abs (avg - 10_000) <= 500) );
         ( "the same seed gives the same quotes" >:: fun _ ->
           assert_equal (quotes 50 11 18_000) (quotes 50 11 18_000) );
         ( "different seeds give different quotes" >:: fun _ ->
           assert_bool "seeds matched"
             (quotes 50 11 18_000 <> quotes 50 12 18_000) );
         ( "reset re-centers on the new true value" >:: fun _ ->
           let r = rng 2 in
           let b = ref (Bot.create r ~true_value:50_000) in
           for _ = 1 to 30 do
             b := Bot.tick r !b
           done;
           check_centered 62_500 (Bot.reset r ~true_value:62_500 !b) );
       ]
