(*
 * This file is part of orpc, OCaml signature to ONC RPC generator
 * Copyright (C) 2008-9 Skydeck, Inc
 * Copyright (C) 2010 Jacob Donham
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the Free
 * Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA 02111-1307, USA
 *)

type obj =
  | Obool of bool
  | Onumber of float
  | Ostring of string
  | Oblock of int * obj array

val to_unit : obj -> unit
val to_int : obj -> int
val to_int32 : obj -> Int32.t
val to_int64 : obj -> Int64.t
val to_float : obj -> float
val to_bool : obj -> bool
val to_char : obj -> char
val to_string : obj -> string

val to_list : (obj -> 'a) -> obj -> 'a list
val to_option : (obj -> 'a) -> obj -> 'a option
val to_array : (obj -> 'a) -> obj -> 'a array
val to_ref : (obj -> 'a) -> obj -> 'a ref

val of_unit : unit -> obj
val of_int : int -> obj
val of_int32 : Int32.t -> obj
val of_int64 : Int64.t -> obj
val of_float : float -> obj
val of_bool : bool -> obj
val of_char : char -> obj
val of_string : string -> obj

val of_list : ('a -> obj) -> 'a list -> obj
val of_option : ('a -> obj) -> 'a option -> obj
val of_array : ('a -> obj) -> 'a array -> obj
val of_ref : ('a -> obj) -> 'a ref -> obj

val set_debug : (string -> unit) -> unit

module type Monad =
sig
  type 'a t
  val return : 'a -> 'a t
  val bind : 'a t -> ('a -> 'b t) -> 'b t
end

module Sync : Monad with type 'a t = 'a
module Async : Monad with type 'a t = ((unit -> 'a) -> unit) -> unit

module Handler (M : Monad) : sig
  val handler : (string * (obj -> obj M.t)) list -> (string -> string M.t)
end
