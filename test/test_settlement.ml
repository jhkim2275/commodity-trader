open OUnit2
open Commodity_trader
open Types

(** [ok r] is the portfolio in [r] for a trade the test expects to succeed,
    and fails the test with the error message if [r] is [Error]. *)
let ok = function
  | Ok p -> p
  | Error e -> assert_failure (Portfolio.error_to_string e)

(** [assert_cents expected actual] checks that the final cash [actual] is
    [expected] cents. *)
let assert_cents expected actual =
  assert_equal expected actual ~printer:string_of_int

let tests =
  "Settlement"
  >::: [
         "no holdings is just cash" >:: (fun _ ->
           let p = Portfolio.create ~cash:5_000 in
           assert_cents 5_000 (Settlement.liquidate p ~sale_price:(fun _ -> 999)));
         "each holding sells at its own price" >:: (fun _ ->
           let p = Portfolio.create ~cash:100_000 in
           let p = ok (Portfolio.buy p Wheat ~qty:2 ~ask:600) in
           let p = ok (Portfolio.buy p Oil ~qty:1 ~ask:7_500) in
           let sale_price = function Wheat -> 500 | Oil -> 7_000 | _ -> 0 in
           assert_cents 99_300 (Settlement.liquidate p ~sale_price));
         "selling at a loss lowers final cash" >:: (fun _ ->
           let p = Portfolio.create ~cash:10_000 in
           let p = ok (Portfolio.buy p Gold ~qty:1 ~ask:10_000) in
           assert_cents 8_000 (Settlement.liquidate p ~sale_price:(fun _ -> 8_000)));
         "commodities not held do not count" >:: (fun _ ->
           let p = ok (Portfolio.buy (Portfolio.create ~cash:1_000) Cattle ~qty:1 ~ask:1_000) in
           let sale_price = function Cattle -> 1_200 | _ -> 1_000_000 in
           assert_cents 1_200 (Settlement.liquidate p ~sale_price));
         "matches net worth at the same prices" >:: (fun _ ->
           let p = ok (Portfolio.buy (Portfolio.create ~cash:50_000) Lumber ~qty:3 ~ask:9_000) in
           let price_of _ = 8_500 in
           assert_cents (Portfolio.net_worth p price_of)
             (Settlement.liquidate p ~sale_price:price_of));
         "reasons have different messages" >:: (fun _ ->
           assert_bool "same message"
             (Settlement.reason_to_string Settlement.Time_up
             <> Settlement.reason_to_string Settlement.Player_quit));
       ]
