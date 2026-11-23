open OUnit2
open Commodity_trader
open Types

(** [ok r] is the portfolio in [r] for a trade the test expects to succeed, and
    fails the test with the error message if [r] is [Error]. *)
let ok = function
  | Ok p -> p
  | Error e -> assert_failure (Portfolio.error_to_string e)

(** [error_of r] is [Some e] if the trade was rejected with [e], or [None] if it
    succeeded. *)
let error_of = function
  | Ok _ -> None
  | Error e -> Some e

(** [error_printer o] is ["Ok"] for [None] or the error message for [Some e],
    for showing what went wrong when a trade test fails. *)
let error_printer = function
  | None -> "Ok"
  | Some e -> Portfolio.error_to_string e

(** [holdings_printer l] is [l] as a string, e.g. ["[wheat 5; oil 2]"], for
    showing what went wrong when a holdings test fails. *)
let holdings_printer l =
  "["
  ^ String.concat "; "
      (List.map (fun (c, n) -> Commodity.to_string c ^ " " ^ string_of_int n) l)
  ^ "]"

(** [assert_cash expected p] checks that the player's cash in [p] is [expected],
    so a trade moved the right amount of money. *)
let assert_cash expected p =
  assert_equal expected (Portfolio.cash p) ~printer:string_of_int

(** [assert_error expected r] checks that the trade [r] was rejected with
    [Error expected], so it failed for the right reason. *)
let assert_error expected r =
  assert_equal (Some expected) (error_of r) ~printer:error_printer

let p0 = Portfolio.create ~cash:10_000

let create_tests =
  [
    ("create sets cash" >:: fun _ -> assert_cash 10_000 p0);
    ( "create has no holdings" >:: fun _ ->
      assert_equal [] (Portfolio.holdings p0) ~printer:holdings_printer );
    ( "create holds 0 of every commodity" >:: fun _ ->
      List.iter
        (fun c ->
          assert_equal 0 (Portfolio.holding p0 c) ~printer:string_of_int)
        Commodity.all );
  ]

let buy_tests =
  [
    ( "buy takes cash and adds units" >:: fun _ ->
      let p = ok (Portfolio.buy p0 Wheat ~qty:5 ~ask:600) in
      assert_cash 7_000 p;
      assert_equal 5 (Portfolio.holding p Wheat) ~printer:string_of_int );
    ( "buy only changes that commodity" >:: fun _ ->
      let p = ok (Portfolio.buy p0 Wheat ~qty:5 ~ask:600) in
      assert_equal
        [ (Wheat, 5) ]
        (Portfolio.holdings p) ~printer:holdings_printer );
    ( "buying twice adds up" >:: fun _ ->
      let p = ok (Portfolio.buy p0 Oil ~qty:1 ~ask:2_000) in
      let p = ok (Portfolio.buy p Oil ~qty:2 ~ask:1_000) in
      assert_cash 6_000 p;
      assert_equal 3 (Portfolio.holding p Oil) ~printer:string_of_int );
    ( "buy can spend exactly all cash" >:: fun _ ->
      assert_cash 0 (ok (Portfolio.buy p0 Wheat ~qty:10 ~ask:1_000)) );
    ( "buy one cent too much" >:: fun _ ->
      assert_error Portfolio.Insufficient_cash
        (Portfolio.buy p0 Wheat ~qty:1 ~ask:10_001) );
    ( "buy negative" >:: fun _ ->
      assert_error Portfolio.Invalid_quantity
        (Portfolio.buy p0 Wheat ~qty:(-3) ~ask:600) );
    ( "bad quantity is reported before cash" >:: fun _ ->
      assert_error Portfolio.Invalid_quantity
        (Portfolio.buy p0 Gold ~qty:0 ~ask:1_000_000) );
    ( "holdings are in display order" >:: fun _ ->
      let p = ok (Portfolio.buy p0 Cattle ~qty:1 ~ask:100) in
      let p = ok (Portfolio.buy p Wheat ~qty:2 ~ask:100) in
      assert_equal
        [ (Wheat, 2); (Cattle, 1) ]
        (Portfolio.holdings p) ~printer:holdings_printer );
  ]

let p5 = ok (Portfolio.buy p0 Wheat ~qty:5 ~ask:600)

let sell_tests =
  [
    ( "sell adds cash and removes units" >:: fun _ ->
      let p = ok (Portfolio.sell p5 Wheat ~qty:2 ~bid:700) in
      assert_cash 8_400 p;
      assert_equal 3 (Portfolio.holding p Wheat) ~printer:string_of_int );
    ( "selling everything clears the holding" >:: fun _ ->
      let p = ok (Portfolio.sell p5 Wheat ~qty:5 ~bid:500) in
      assert_cash 9_500 p;
      assert_equal [] (Portfolio.holdings p) ~printer:holdings_printer );
    ( "sell more than owned" >:: fun _ ->
      assert_error Portfolio.Insufficient_holdings
        (Portfolio.sell p5 Wheat ~qty:6 ~bid:600) );
    ( "sell something not owned" >:: fun _ ->
      assert_error Portfolio.Insufficient_holdings
        (Portfolio.sell p5 Oil ~qty:1 ~bid:600) );
    ( "sell zero" >:: fun _ ->
      assert_error Portfolio.Invalid_quantity
        (Portfolio.sell p5 Wheat ~qty:0 ~bid:600) );
    ( "sell negative" >:: fun _ ->
      assert_error Portfolio.Invalid_quantity
        (Portfolio.sell p5 Wheat ~qty:(-1) ~bid:600) );
    ( "rejected trades leave the portfolio unchanged" >:: fun _ ->
      ignore (Portfolio.sell p5 Wheat ~qty:99 ~bid:600);
      ignore (Portfolio.buy p5 Gold ~qty:1 ~ask:1_000_000);
      assert_cash 7_000 p5;
      assert_equal 5 (Portfolio.holding p5 Wheat) ~printer:string_of_int );
  ]

let other_tests =
  [
    ( "net worth of cash only" >:: fun _ ->
      assert_equal 10_000
        (Portfolio.net_worth p0 (fun _ -> 999))
        ~printer:string_of_int );
    ( "net worth counts holdings" >:: fun _ ->
      let p = ok (Portfolio.buy p5 Oil ~qty:1 ~ask:1_000) in
      let price_of = function
        | Wheat -> 800
        | Oil -> 2_000
        | _ -> 0
      in
      assert_equal 12_000
        (Portfolio.net_worth p price_of)
        ~printer:string_of_int );
    ( "error messages are distinct" >:: fun _ ->
      let msgs =
        List.map Portfolio.error_to_string
          Portfolio.
            [ Invalid_quantity; Insufficient_cash; Insufficient_holdings ]
      in
      assert_equal 3 (List.length (List.sort_uniq compare msgs)) );
  ]

let tests = "Portfolio" >::: create_tests @ buy_tests @ sell_tests @ other_tests
