(* Tests for Headline. *)

open OUnit2
open Commodity_trader

(** [draw_n n d] draws [n] headlines from [d] and returns the deck left over. *)
let rec draw_n n d = if n = 0 then d else draw_n (n - 1) (snd (Headline.draw d))

let tests =
  "Headline"
  >::: [
         ( "there are at least 10 headlines (MS1)" >:: fun _ ->
           assert_bool "fewer than 10 headlines" (List.length Headline.all >= 10)
         );
         ( "draw from a full deck returns the first headline" >:: fun _ ->
           let h, rest = Headline.draw (Headline.new_deck ()) in
           assert_equal (List.hd Headline.all) h;
           assert_equal (List.length Headline.all - 1) (Headline.remaining rest)
         );
         ( "draw from an empty deck refills it first" >:: fun _ ->
           let n = List.length Headline.all in
           let empty = draw_n n (Headline.new_deck ()) in
           assert_equal 0 (Headline.remaining empty);
           let h, rest = Headline.draw empty in
           assert_equal (List.hd Headline.all) h;
           assert_equal (n - 1) (Headline.remaining rest) );
       ]
