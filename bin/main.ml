(* Entry point.

   Run with: dune exec commodity_trader *)

open Commodity_trader
open Lwt.Syntax

(* Asks for a 2, 5, or 10 minute game until the player gives a valid answer.
   [None] means input ended before they chose. *)
let rec choose_duration () =
  let* () = Lwt_io.printl "Choose a game length: 2, 5, or 10 (minutes)" in
  let* () = Lwt_io.print "> " in
  let* () = Lwt_io.flush Lwt_io.stdout in
  let* line = Lwt_io.read_line_opt Lwt_io.stdin in
  match Option.map String.trim line with
  | None -> Lwt.return None
  | Some "2" -> Lwt.return (Some Types.Two_min)
  | Some "5" -> Lwt.return (Some Types.Five_min)
  | Some "10" -> Lwt.return (Some Types.Ten_min)
  | Some _ ->
      let* () = Lwt_io.printl "Please type 2, 5, or 10." in
      choose_duration ()

(* Plays one run: create the game, run the live loop, show the result. *)
let play duration =
  let start = Loop.now () in
  match Game.create ~seed:(int_of_float start) ~duration ~now:start with
  | exception Failure msg ->
      Lwt_io.printl ("The game can't start yet. Not implemented yet: " ^ msg)
  | g ->
      let game = ref g in
      let* () =
        Lwt_io.printl (Loop.safe_text (fun () -> Render.status ~now:start g))
      in
      let* () = Lwt_io.printl "Type \"help\" for commands." in
      let* reason = Loop.run game in
      Lwt_io.printl (Loop.safe_text (fun () -> Render.game_over reason !game))

(* Shows the welcome screen, asks for a game length, and plays one run. *)
let main () =
  let* () = Lwt_io.printl Render.welcome in
  let* duration = choose_duration () in
  match duration with
  | None -> Lwt.return_unit
  | Some d -> play d

(* Starts the Lwt event loop. *)
let () = Lwt_main.run (main ())
