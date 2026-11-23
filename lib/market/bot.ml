(* One quoting bot per commodity. See bot.mli for the spec.

   How it works: the bot keeps a private "mid" price. Its bid is a little below
   the mid and its ask a little above it (the spread). Every tick the mid takes
   a small random step, with a slight pull back toward the true value, and is
   then clamped so that the bid and ask both stay inside the allowed band around
   the true value. *)

open Types

(* AF: [{ true_value; mid }] is a bot quoting a bid just below [mid] and an ask
   just above it, for a commodity whose hidden value today is [true_value].

   RI: [true_value > 0], and [mid] is inside [mid_range] (or equals [true_value]
   when [mid_range] is [None]). *)
type t = {
  true_value : price;
  mid : price;
}

let max_deviation = 0.20

(* Half of the bid-ask spread, as a fraction of the true value (so the full
   spread is about 2%). *)
let half_spread_frac = 0.01

(* Largest random step the mid can take in one tick, as a fraction of the true
   value. *)
let max_step_frac = 0.02

(* Each tick, the mid moves 1/[pull_divisor] of the way back toward the true
   value, so it drifts around the true value instead of sticking at the edges of
   the band. *)
let pull_divisor = 10

(* [frac_of tv f] is [f] of [tv] in whole cents, at least 1 cent. *)
let frac_of tv f = max 1 (int_of_float (float_of_int tv *. f))

(* [half_spread b] is half of [b]'s bid-ask spread, in cents. *)
let half_spread b = frac_of b.true_value half_spread_frac

(* The lowest and highest mid that keep the bid and ask inside the band
   [true_value * (1 - max_deviation), true_value * (1 + max_deviation)]. When
   the true value is only a few cents, the band is too narrow to fit a spread,
   and [None] is returned. *)
let mid_range b =
  let tv = float_of_int b.true_value in
  let half = half_spread b in
  let lo = int_of_float (Float.ceil (tv *. (1. -. max_deviation))) + half in
  let hi = int_of_float (Float.floor (tv *. (1. +. max_deviation))) - half in
  if lo <= hi then Some (lo, hi) else None

(* [clamp b mid] is [mid] moved inside [mid_range b], or the true value itself
   when no mid fits. *)
let clamp b mid =
  match mid_range b with
  | Some (lo, hi) -> max lo (min hi mid)
  | None -> b.true_value

(* A new bot starts with its mid exactly at the true value. *)
let create _rng ~true_value = { true_value; mid = true_value }

(* One random step of the mid, pulled toward the true value and clamped. *)
let tick rng b =
  let max_step = frac_of b.true_value max_step_frac in
  let step = Random.State.int rng ((2 * max_step) + 1) - max_step in
  let pull = (b.true_value - b.mid) / pull_divisor in
  { b with mid = clamp b (b.mid + step + pull) }

(* A new day starts the quote fresh, centered on the new true value. *)
let reset rng ~true_value _b = create rng ~true_value
let true_value b = b.true_value

(* The bid is half a spread below the mid (at least 1 cent), and the ask is half
   a spread above it, pushed up if needed so it stays above the bid. *)
let quote b =
  let half = half_spread b in
  let bid = max 1 (b.mid - half) in
  { bid; ask = max (bid + 1) (b.mid + half) }
