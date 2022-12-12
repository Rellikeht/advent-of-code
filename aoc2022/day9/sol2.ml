type segment = {hx : int ref;hy : int ref;tx : int ref;ty : int ref}
type pos = int * int;;
module Pos = struct
    type t = pos
    let compare = compare
end
module Pset = Set.Make(Pos)
let segments = 10;;

let soi = string_of_int;;

let rope_to_str r = "("^(soi !(r.hx))^" "^(soi !(r.hy))^
    ") ("^(soi !(r.tx))^" "^(soi !(r.ty))^")"
;;
let print_rope rope = print_string ((rope_to_str rope)^"\n") ;;
let pos_to_str (px, py) = "("^(soi px)^" "^(soi py)^")" ;;

let htdist {hx;hy;tx;ty} = abs (!hx - !tx) + abs (!hy - !ty);;
let calc_step d = compare d 0 ;;
let hdist {hx;hy;_} (px, py) =
    abs (!hx - px) + abs (!hy - py)
;;

(* TODO move & align *)
let move_segment segment xa ya =
    let hd = htdist segment in
    if hd < 2 then begin
        segment.hx := !(segment.hx) + xa;
        segment.hy := !(segment.hy) + ya;
        if abs (!(segment.hx) - !(segment.tx)) == 2 ||
            abs (!(segment.hy) - !(segment.ty)) == 2 then begin
            segment.tx := !(segment.tx) + xa;
            segment.ty := !(segment.ty) + ya;
        end else ()
    end else begin
        let (phx, phy) = (!(segment.hx), !(segment.hy)) in
        segment.hx := !(segment.hx) + xa;
        segment.hy := !(segment.hy) + ya;
        if (htdist segment) > 2 then begin
            segment.tx := phx;
            segment.ty := phy;
        end else ()
    end;
;;

(* TODO move & align *)
let rec align_segments rope xa ya =
    match rope with
    | [] -> ()
    | seg::rest -> begin
        move_segment seg xa ya
    end
;;

(* TODO rec? *)
let rec move rope (dx, dy) pset =
    if dx == 0 && dy == 0 then (rope, pset)
    else begin
        for i = 1 to segments do
            () (* TODO *)
        done;
        (rope, pset)
    end
;;

(*
        let xa = calc_step dx in
        let ya = calc_step dy in
        move_step rope xa ya;
        (*print_rope rope;*)
        move rope (dx-xa,dy-ya) (Pset.add (!(rope.tx), !(rope.ty)) pset)
*)

(*
Reszta raczej dobra
*)

let up_pos rope spec pset =
    let mv = match String.split_on_char ' ' spec with
    | l::n::[] -> begin
        let num = int_of_string n in match l with
        | "R" -> (num, 0)
        | "L" -> (-num, 0)
        | "U" -> (0, -num)
        | "D" -> (0, num)
        | _ -> (0, 0) end
    | _ -> (0, 0) in
    move rope mv pset
;;

let rec execute rope pset =
    try let (nrope, npset) = up_pos rope (read_line ()) pset in
        execute nrope npset
    with End_of_file -> pset
;;

let pset = Pset.of_list [(0,0)] in

let rec gen_rope curx cury amount cur_rope =
    let nr = (curx, cury)::cur_rope in
    if amount == 0 then nr
    else gen_rope (ref 0) (ref 0) (amount - 1) nr
in
let rope = gen_rope (ref 0) (ref 0) (segments - 1) [] in
let npset = execute rope pset in
print_string ((string_of_int (Pset.fold (fun _ x -> x+1) npset 0))^"\n")

(*
let rope = {hx=ref 0;hy=ref 0;tx=ref 0;ty=ref 0} in

print_rope rope
*)
