(* TYPES *)

type segment = {hx : int;hy : int;tx : int;ty : int}
type pos = int * int;;
module Pos = struct
    type t = pos
    let compare = compare
end
module Pset = Set.Make(Pos)
let moves = (-1,0)::(-1,1)::(0,1)::(1,1)::(1,0)::(1,-1)::(0,-1)::(-1,-1)::[];;

(* PRINTING *)

let soi = string_of_int;;
let seg_to_str r = "(("^(soi r.hx)^" "^(soi r.hy)^
    ") ("^(soi r.tx)^" "^(soi r.ty)^"))"
;;
let print_seg segment = print_string (seg_to_str segment) ;;
let pos_to_str (px, py) = "("^(soi px)^" "^(soi py)^")" ;;

let rec print_rope rope = match rope with
| [] -> ()
| seg::[] -> begin
    print_seg seg;
    print_newline ()
end
| seg::rest -> begin
    print_seg seg;
    print_char '-';
    print_rope rest
end
;;

(* CALCULATIONS *)

let pdst (x1, y1) (x2, y2) = abs (x1 - x2) + abs (y1 - y2);;
let htdist {hx;hy;tx;ty} = pdst (hx,hy) (tx,ty);;
let hdist {hx;hy;_} pt = pdst (hx,hy) pt;;

let rec closest {hx;hy;tx;ty} moves cp dst = match moves with
| [] -> cp
| (mx,my)::rest -> begin
    let np = (tx+mx,ty+my) in
    let ndst = pdst np (hx,hy) in
    if ndst < dst then closest {hx;hy;tx;ty} rest np ndst
    else closest {hx;hy;tx;ty} rest cp dst
end
;;

let align segment =
    let htd = htdist segment in
    if htd > 2 then begin
        let (clx, cly) = closest segment moves (0,0) (htd+1) in
        {hx=segment.hx;hy=segment.hy;tx=clx;ty=cly}
    end else if htd == 2 then
        if abs (segment.hx - segment.tx) == 2 then
            {hx=segment.hx;hy=segment.hy;
            tx=segment.tx + compare segment.hx segment.tx;ty=segment.ty}
        else if abs (segment.hy - segment.ty) == 2 then
            {hx=segment.hx;hy=segment.hy; tx=segment.tx;
            ty=segment.ty + compare segment.hy segment.ty}
        else segment
    else segment
;;

let rec align_segments rope pset nrope =
    match rope with
    | [] -> (nrope, pset)
    | seg::[] -> begin
        let alseg = align seg in
        let nrp = List.rev (alseg::nrope) in
        (nrp, Pset.add (alseg.tx, alseg.ty) pset)
    end
    | s1::s2::rest -> begin
        let alg = align s1 in
        let ns2 = {hx=alg.tx;hy=alg.ty;tx=s2.tx;ty=s2.ty} in
        align_segments (ns2::rest) pset (alg::nrope)
    end
;;

let calc_step d = compare d 0 ;;
let rec move rope (dx, dy) pset =
    if dx == 0 && dy == 0 then (rope, pset)
    else begin
        let xa = calc_step dx in
        let ya = calc_step dy in
        let {hx=hhx;hy=hhy;tx=htx;ty=hty} = List.hd rope in
        let nhd = {hx=hhx+xa;hy=hhy+ya;tx=htx;ty=hty} in
        let (nrope, npset) = align_segments (nhd::List.tl rope) pset [] in
        move nrope (dx-xa, dy-ya) npset
    end
;;

(* READING *)

let up_pos rope spec pset =
    let (mx, my) = match String.split_on_char ' ' spec with
    | l::n::[] -> begin
        let num = int_of_string n in match l with
        | "R" -> (num, 0)
        | "L" -> (-num, 0)
        | "U" -> (0, -num)
        | "D" -> (0, num)
        | _ -> (0, 0) end
    | _ -> (0, 0) in
    move rope (mx, my) pset
;;

let rec execute rope pset =
    try
        let (nrope, npset) = up_pos rope (read_line ()) pset in
        execute nrope npset
    with End_of_file -> (rope, pset)
;;

(* MAIN *)

let rec gen_rope amount cur_rope =
    if amount <= 0 then cur_rope
    else gen_rope (amount - 1) ({hx=0;hy=0;tx=0;ty=0}::cur_rope)
;;

let segments = 9;;
let pset = Pset.of_list [(0,0)] in
let rope = gen_rope segments [] in
let (nrope, npset) = execute rope pset in
print_string ((string_of_int (Pset.fold (fun _ x -> x+1) npset 0))^"\n")

(*
List.iter print_seg nrope;
print_newline ();
*)
