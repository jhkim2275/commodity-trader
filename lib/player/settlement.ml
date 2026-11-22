type reason =
  | Time_up
  | Player_quit
let reason_to_string = function
  | Time_up -> "Time ran out."
  | Player_quit -> "You ended the run."

let liquidate p ~sale_price =
  List.fold_left
    (fun acc (c, n) -> acc + (n * sale_price c))
    (Portfolio.cash p) (Portfolio.holdings p)
