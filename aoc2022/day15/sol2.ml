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
    let (sx, sy) = (get_num sxpart, get_num sypart) in
    let (bx, by) = (get_num bxpart, get_num bypart) in
    ((sx, sy), abs (sx-bx) + abs (sy-by))
;;

let rec get_points plist =
    try get_points (get_pair (read_line ())::plist)
    with End_of_file -> plist
;;

(* GENERATING *)

let len f l = l - f + 1;;
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
    | [] -> {ranges={first=f1;last=l1}::rlist; length=rsum.length+len f1 l1}
    | {first=f2;last=l2}::rest -> begin
        if f1 == f2 || l1 == l2 ||
        (f2 < f1 && f1 <= l2+1) ||
        (f2 > f1 && f2 <= l1+1)
        then 
                let nrange = sum_ranges {first=f1;last=l1} {first=f2;last=l2}
                in let nlen = rsum.length - (len f2 l2)
                in adr {ranges=rest;length=nlen} nrange rlist
        else
            let nrsum = {ranges=rest;length=rsum.length} in
            adr nrsum {first=f1;last=l1} ({first=f2;last=l2}::rlist)
    end
;;


(* CALCULATION *)

let addp level ranges ((sx, sy), dst) =
    let span = dst - abs (sy-level) in
    if span < 0 then ranges
    else adr ranges {first=sx-span;last=sx+span} []
;;

let rec check_lev rlist maxval level =
    match rlist with
    | [] -> None
    | rng::rest ->
            if rng.first > 0 then Some (rng.first-1, level)
            else if rng.last < maxval then Some (rng.last+1, level)
            else check_lev rest maxval level
;;

let rec find_empty pts maxval level =
    if level > maxval then (-1, -1)
    else begin
        let ranges = List.fold_left (addp level) {ranges=[];length=0} pts in
        match check_lev (ranges.ranges) maxval level with
        | Some pos -> pos
        | None -> find_empty pts maxval (level+1)
    end
;;

(* MAIN *)

let maxlevel = if Array.length (Sys.argv) > 1
    then int_of_string Sys.argv.(1) else 4000000 in
let pts = get_points [] in

let (ex, ey) = find_empty pts maxlevel 0 in
print_int (4000000*ex+ey);print_newline ()
