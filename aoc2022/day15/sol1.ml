(* This code is probably bad and incomplete, but it somehow
 managed to do test example and solve task *)

(* RANGE SUM *)

type range = {
    first : int;
    last : int;
}
type rsum = {
    ranges : range list;
    length : int;
}

(* PRINTING *)

let prange {first=f;last=l} =
    print_string "(";
    print_int f;print_string " ";
    print_int l;print_string ")";
;;
let print_rlist rlist = List.iter prange rlist ;;

let pfun ((sx, sy),(bx, by)) =
    print_string "((";print_int sx;
    print_string " ";print_int sy;
    print_string ") (";print_int bx;
    print_string " ";print_int by;
    print_string "))"
;;

(* GENERATING *)

let len {first=f;last=l} = l-f;;
let sum_ranges r1 r2 =
    {first=min (r1.first) (r2.first);
    last=max (r1.last) (r2.last)}
;;
let rec cat l1 l2 = match l1 with
| [] -> l2
| el::rest -> cat rest (el::l2)
;;

let rec adr rsum {first=f1;last=l1} rlist =
    match rsum.ranges with
    | [] -> {ranges={first=f1;last=l1}::rlist; length=rsum.length+l1-f1}
    | {first=f2;last=l2}::rest ->
            if f2 < f1 && l2 > f1 || f2 < l1 then
                let nrange = sum_ranges {first=f1;last=l1} {first=f2;last=l2}
                in let nlen = rsum.length - (l2 - f2)
                in adr {ranges=rest;length=nlen} nrange rlist
            else
                let nrsum = {ranges=rest;length=rsum.length} in
                adr nrsum {first=f1;last=l1} ({first=f2;last=l2}::rlist)
;;

let rec sub_point (x, y) rsum rlist =
    (* Probably needed to do task well, but who cares :) *)
    match rsum.ranges with
    | [] -> {ranges=rlist; length=rsum.length}
    | {first=f2;last=l2}::rest -> rsum
;;

(* PARSING *)

let get_num s =
    match String.split_on_char '=' (String.trim s) with
    | _::nums::[] -> int_of_string nums
    | _ -> 0
;;

let get_pair ln =
    let spart::bpart::[] = String.split_on_char ':' ln in
    let sxstart::sypart::[] = String.split_on_char ',' spart in
    let _::_::sxpart::[] = String.split_on_char ' ' sxstart in
    let bxstart::bypart::[] = String.split_on_char ',' bpart in
    let _::_::_::_::bxpart::[] =
        String.split_on_char ' ' (String.trim bxstart) in
    let spos = (get_num sxpart, get_num sypart) in
    let bpos = (get_num bxpart, get_num bypart) in
    (spos, bpos)
;;

let rec get_points plist =
    try get_points (get_pair (read_line ())::plist)
    with End_of_file -> plist
;;

(* CALCULATION *)

let dist (sx, sy) (bx, by) = abs (sx-bx) + abs (sy-by);;
let lrange (sx, sy) (bx, by) level =
    let dst = dist (sx, sy) (bx, by) in
    let span = dst - abs (sy-level) in
    if span < 1 then None
    else Some {first=sx-span;last=sx+span}
;;

let addp level ranges (sp, bp) =
    match lrange sp bp level with
    | None -> ranges
    | Some dst -> adr ranges dst []
;;

(* MAIN *)

let clevel = if Array.length (Sys.argv) > 1
    then int_of_string Sys.argv.(1) else 2000000 in
let ranges = {ranges=[];length=0} in
let pts = get_points [] in
let endr = List.fold_left (addp clevel) ranges pts in
print_int (endr.length)
