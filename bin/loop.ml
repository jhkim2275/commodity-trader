(* The Lwt game loop. See loop.mli for the spec. *)

open Commodity_trader
open Lwt.Syntax

let tick_interval = 1.0

(* How often the deadline watcher checks the clock. *)
let deadline_poll = 0.25
let now () = Unix.gettimeofday ()

(* The note shown when a teammate's stub is reached. *)
let not_implemented msg = "Not implemented yet: " ^ msg
let safe_text f = try f () with Failure msg -> not_implemented msg

(* Prints each line, then flushes so it shows up right away. *)
let print_lines lines =
  let* () = Lwt_list.iter_s Lwt_io.printl lines in
  Lwt_io.flush Lwt_io.stdout

(* Prints the "> " input prompt. *)
let prompt () =
  let* () = Lwt_io.print "> " in
  Lwt_io.flush Lwt_io.stdout

(* Moves every bot's quote once per [tick_interval], forever. [Lwt.pick] cancels
   it when the run ends. It doesn't print anything, since that would scramble
   what the player is typing; new quotes show up on "status". *)
let rec ticker game =
  let* () = Lwt_unix.sleep tick_interval in
  game := Game.tick_bots !game;
  ticker game

(* Ends the run once the clock expires, even while the player is idle at the
   prompt. *)
let rec deadline_watcher game =
  let* () = Lwt_unix.sleep deadline_poll in
  if Clock.expired !game.Game.clock ~now:(now ()) then
    let* () = print_lines [ ""; "Time's up!" ] in
    Lwt.return Settlement.Time_up
  else deadline_watcher game

(* The current status screen (headline, time, market, portfolio). *)
let status game = safe_text (fun () -> Render.status ~now:(now ()) !game)

(* [respond game cmd] runs [cmd] (anything but [Quit]) and returns the lines to
   print. Trades use the quote at the moment the command is run. *)
let respond game (cmd : Command.t) =
  match cmd with
  | Help -> [ Render.help ]
  | Status -> [ status game ]
  | Buy _ | Sell _ | Next | Quit -> (
      match Game.apply cmd !game with
      | g, messages ->
          game := g;
          (* After a new headline, show the new prices and holdings. Not the
             full status, which would print the headline a second time. *)
          if cmd = Next then
            messages
            @ [
                "";
                safe_text (fun () -> Render.market !game);
                "";
                safe_text (fun () -> Render.portfolio !game);
              ]
          else messages
      | exception Failure msg -> [ not_implemented msg ])

(* [Command.parse line], turning an unfinished stub into an error message. *)
let parse line =
  try Command.parse line with Failure msg -> Error (not_implemented msg)

(* Reads and runs commands until the player quits, input ends, or time is up. *)
let rec input_loop game =
  let* () = prompt () in
  let* line = Lwt_io.read_line_opt Lwt_io.stdin in
  match line with
  | None -> Lwt.return Settlement.Player_quit
  | Some _ when Clock.expired !game.Game.clock ~now:(now ()) ->
      Lwt.return Settlement.Time_up
  | Some line -> (
      match parse line with
      | Ok Quit -> Lwt.return Settlement.Player_quit
      | Ok cmd ->
          let* () = print_lines (respond game cmd) in
          input_loop game
      | Error msg ->
          let* () = print_lines [ msg ] in
          input_loop game)

let run game = Lwt.pick [ input_loop game; deadline_watcher game; ticker game ]
