(* Runs every test suite. When you add a test_<module>.ml file, add its [tests]
   to this list. *)

open OUnit2

let () =
  run_test_tt_main
    ("commodity_trader"
    >::: [
           Test_types.tests;
           Test_commodity.tests;
           Test_command.tests;
           Test_portfolio.tests;
           Test_headline.tests;
           Test_market.tests;
           Test_bot.tests;
           Test_clock.tests;
           Test_settlement.tests;
           Test_game.tests;
           Test_integration.tests;
         ])
