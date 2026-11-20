(** Helpers for the five commodities: names, parsing, and starting values.

    Owner: Shreya (MS1 Task 1). *)

type t = Types.commodity

val all : t list
(** Every commodity, in display order: wheat, oil, gold, lumber, cattle. *)

val to_string : t -> string
(** [to_string c] is the lowercase name, e.g. ["wheat"]. *)

val of_string : string -> t option
(** [of_string s] parses a name, ignoring case and surrounding spaces.
    [of_string "Oil"] is [Some Oil]; an unknown name is [None]. *)

val starting_value : t -> Types.price
(** [starting_value c] is the hidden true value of [c] on the first day. *)
