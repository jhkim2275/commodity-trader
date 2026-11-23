(** The game clock: a countdown to the end of the run.

    The clock never reads the system time itself. Every function takes [~now]
    (seconds, e.g. from [Unix.gettimeofday]), so tests can use a fake,
    controllable time. *)

type t

val duration_seconds : Types.duration -> float
(** [duration_seconds d] is 120, 300, or 600. *)

val create : Types.duration -> now:float -> t
(** [create d ~now] is a clock that started at [now]. *)

val remaining : t -> now:float -> float
(** [remaining c ~now] is the seconds left, never below 0. *)

val expired : t -> now:float -> bool
(** [expired c ~now] is [true] at or after the deadline. *)
