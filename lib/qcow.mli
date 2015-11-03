(*
 * Copyright (C) 2015 David Scott <dave@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)
module Error = Qcow_error
module Header = Qcow_header

module Make(B: Qcow_s.RESIZABLE_BLOCK) : sig
  include V1_LWT.BLOCK

  val create: B.t -> int64 -> [ `Ok of t | `Error of error ] io
  (** [create block size] initialises a qcow-formatted image on [block]
      with virtual size [size]. *)

  val connect: B.t -> [ `Ok of t | `Error of error ] io
  (** [connect block] connects to an existing qcow-formatted image on
      [block]. *)

  val resize: t -> int64 -> [ `Ok of unit | `Error of error ] io
  (** [resize block new_size_sectors] changes the size of the qcow-formatted
      image to be [new_size_sectors] 512-byte sectors. *)

  val seek_unmapped: t -> int64 -> [ `Ok of int64 | `Error of error ] io
  (** [seek_unmapped t start] returns the offset of the next "hole": a region
      of the device which is guaranteed to be full of zeroes (typically
      guaranteed because it is unmapped) *)

  val seek_mapped: t -> int64 -> [ `Ok of int64 | `Error of error ] io
  (** [seek_mapped t start] returns the offset of the next region of the
      device which may have data in it (typically this is the next mapped
      region) *)
end
