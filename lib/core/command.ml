type t =
  | Buy of Types.commodity * int
  | Sell of Types.commodity * int
  | Next
  | Status
  | Help
  | Quit

(** [quantity n] is [Some q] if [n] is a positive whole number written with
    digits only, so inputs like ["-1"], ["+5"], or ["0x10"] are rejected. *)
let quantity n =
  if String.for_all (fun ch -> '0' <= ch && ch <= '9') n then
    match int_of_string_opt n with
    | Some q when q > 0 -> Some q
    | _ -> None
  else None

(** [trade make c n] is [Ok (make com q)] when [c] names a commodity [com] and
    [n] is a valid quantity [q]. Otherwise it is [Error msg] naming the bad
    commodity, or else the bad quantity. *)
let trade make c n =
  match (Commodity.of_string c, quantity n) with
  | None, _ -> Error ("Unknown commodity: " ^ c)
  | _, None -> Error ("Quantity must be a positive whole number: " ^ n)
  | Some com, Some q -> Ok (make com q)

let parse s =
  let words =
    String.lowercase_ascii s
    |> String.map (fun ch -> if ch = '\t' then ' ' else ch)
    |> String.split_on_char ' '
    |> List.filter (( <> ) "")
  in
  match words with
  | [] -> Error "Type a command, or help to see them all."
  | [ "buy"; c; n ] -> trade (fun com q -> Buy (com, q)) c n
  | [ "sell"; c; n ] -> trade (fun com q -> Sell (com, q)) c n
  | "buy" :: _ -> Error "Usage: buy <commodity> <qty>"
  | "sell" :: _ -> Error "Usage: sell <commodity> <qty>"
  | [ "next" ] -> Ok Next
  | [ "status" ] -> Ok Status
  | [ "help" ] -> Ok Help
  | [ "quit" ] -> Ok Quit
  | _ -> Error ("Unknown command: " ^ String.trim s ^ ". Type help.")
