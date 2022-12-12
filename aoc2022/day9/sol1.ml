type rope = {hx : int ref;hy : int ref;tx : int ref;ty : int ref}
type pos = int * int;;
module Pos = struct
    type t = pos
    let compare = compare
end
module Pset = Set.Make(Pos)

let soi = string_of_int;;
let pos_to_str (px, py) = "("^(soi px)^" "^(soi py)^")" ;;
let rope_to_str r = "("^(soi !(r.hx))^" "^(soi !(r.hy))^
    ") ("^(soi !(r.tx))^" "^(soi !(r.ty))^")"
;;
let print_rope rope = print_string ((rope_to_str rope)^"\n") ;;
let htdist {hx;hy;tx;ty} = abs (!hx - !tx) + abs (!hy - !ty);;
let calc_step d = compare d 0 ;;
let hdist {hx;hy;_} (px, py) =
    abs (!hx - px) + abs (!hy - py)
;;

let rec move rope (dx, dy) pset =
    if dx == 0 && dy == 0 then pset
    else begin
        let xa = calc_step dx in
        let ya = calc_step dy in
        let hd = htdist rope in
        if hd < 2 then begin
            rope.hx := !(rope.hx) + xa;
            rope.hy := !(rope.hy) + ya;
            if abs (!(rope.hx) - !(rope.tx)) == 2 ||
                abs (!(rope.hy) - !(rope.ty)) == 2 then begin
                rope.tx := !(rope.tx) + xa;
                rope.ty := !(rope.ty) + ya;
            end else ()
        end else begin
            let (phx, phy) = (!(rope.hx), !(rope.hy)) in
            rope.hx := !(rope.hx) + xa;
            rope.hy := !(rope.hy) + ya;
            if (htdist rope) > 2 then begin
                rope.tx := phx;
                rope.ty := phy;
            end else ()
        end;
        move rope (dx-xa,dy-ya) (Pset.add (!(rope.tx), !(rope.ty)) pset)
    end
;;

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
    try execute rope (up_pos rope (read_line ()) pset)
    with End_of_file -> pset
;;

let pset = Pset.of_list [(0,0)] in
let rope = {hx=ref 0;hy=ref 0;tx=ref 0;ty=ref 0} in
let npset = execute rope pset in
print_string ((string_of_int (Pset.fold (fun _ x -> x+1) npset 0))^"\n")
