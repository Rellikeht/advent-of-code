(* DEFINITIONS *)

type robot = Ore of int | Clay of int | Obs of int * int | Geo of int * int
type rtype = ROre | RClay | RObs | RGeo

(* PRINTING *)

let print_rob r = match r with
| ROre -> print_string "Ore Robot"
| RClay -> print_string "Clay Robot"
| RObs -> print_string "Obsidian Robot"
| RGeo -> print_string "Geode Robot"
;;

let print_robot r = match r with
| Ore o -> begin print_string "Ore ";print_int o end
| Clay c -> begin print_string "Clay ";print_int c end
| Obs (b1, b2) -> begin
    print_string "Obsidian ("; print_int b1;
    print_string ","; print_int b2; print_string ")"
end
| Geo (g1, g2) -> begin
    print_string "Geode ("; print_int g1;
    print_string ","; print_int g2; print_string ")"
end
;;

let print_rbs rbs =
    print_string "[ ";
    let rec rpr rbs = match rbs with
    | [] -> ()
    | rb::[] -> print_robot rb
    | rb::rest -> print_robot rb; print_string " : "; rpr rest;
    in rpr rbs;
    print_endline " ]"
;;

let print_res (o, c, b, g) =
    print_string "(";
    print_int o;print_char ' ';
    print_int c;print_char ' ';
    print_int b;print_char ' ';
    print_int g;print_string ")";
;;

(* READING *)

let read_blueprint () =
    let recp = List.hd (List.tl (String.split_on_char ':' (read_line ()))) in
    let recs = String.split_on_char '.' recp in
    let getn str = match String.split_on_char ' ' (String.trim str) with
    | _::_::_::_::n1::_::_::n2::_::[] -> [int_of_string n1;int_of_string n2]
    | _::_::_::_::num::_::[] -> [int_of_string num]
    | _ -> [] in
    let rec getns strs ns = match strs with
    | [] -> ns
    | []::rest -> getns rest ns
    | ls::rest -> getns rest (ls::ns)
    in match getns (List.map getn recs) [] with
    | [g1;g2]::[b1;b2]::[c]::[o]::[] -> [Geo (g1, g2);Obs (b1, b2);Clay c;Ore o]
    | _ -> []
;;

let rec get_blueprints bps =
    try match read_blueprint () with
        | [] -> get_blueprints bps
        | bp -> get_blueprints (bp::bps)
    with End_of_file -> List.rev bps
;;

(* SIMULATION *)

let add_res (o1,c1,b1,g1) (o2,c2,b2,g2) = (o1+o2,c1+c2,b1+b2,g1+g2);;
let getg (o, c, b, g) = g;;
let upgr (ro, rc, rb, rg) rob = match rob with
| ROre -> (ro+1, rc, rb, rg)
| RClay -> (ro, rc+1, rb, rg)
| RObs -> (ro, rc, rb+1, rg)
| RGeo -> (ro, rc, rb, rg+1)
;;

let rec creation (o, c, b, g) recs robs =
    match recs with
    | [] -> robs
    | rob::rest -> begin
        match rob with
        | Geo (no, nb) ->
                if no <= o && nb <= b then
                    creation (o, c, b, g) rest (((o-no, c, b-nb, g), RGeo)::robs)
                else creation (o, c, b, g) rest robs
        | Obs (no, nc) -> 
                if no <= o && nc <= c then
                    creation (o, c, b, g) rest (((o-no, c-nc, b, g), RObs)::robs)
                else creation (o, c, b, g) rest robs
        | Clay no -> 
                if no <= o then
                    creation (o, c, b, g) rest (((o-no, c, b, g), RClay)::robs)
                else creation (o, c, b, g) rest robs
        | Ore no -> 
                if no <= o then
                    creation (o, c, b, g) rest (((o-no, c, b, g), ROre)::robs)
                else creation (o, c, b, g) rest robs
    end
;;

let rec qual recipes robots res cnt =
    if cnt <= 0 then getg res
    else begin
        let nrobots = creation res recipes [] in
        let maxf q (nres, rob) =
            max q
            (qual recipes (upgr robots rob) (add_res robots nres) (cnt-1))
        in
        let nq = qual recipes robots (add_res robots res) (cnt-1) in
        List.fold_left maxf nq nrobots
    end
;;

let rec quality recipes robots res cnt rtable =
    if cnt <= 0 then getg res
    else begin
        let maxf q (nres, rob) =
            max q (
                quality recipes (upgr robots rob)
                (add_res robots nres) (cnt-1) rtable
                )
        in
        if Hashtbl.mem rtable (res, robots) then
            Hashtbl.find rtable (res, robots)
        else begin
            let nrobots = creation res recipes [] in
            let nq = quality recipes robots (add_res robots res) (cnt-1) rtable
            in
            let mq = List.fold_left maxf nq nrobots in
            Hashtbl.replace rtable (res, robots) mq; mq
        end
    end
;;

(* MAIN *)

let clen = 19 in
let srobots = (1, 0, 0, 0) in
let sres = (0, 0, 0, 0) in
let blueprints = get_blueprints [] in
let qfun (bn, bc) b =
    (*
    let nb = qual b srobots sres clen in
    *)
    let restable =
        Hashtbl.create (int_of_float (float_of_int 2 ** float_of_int clen))
    in
    let nb = quality b srobots sres clen restable in
    print_rbs b;print_char ' ';
    print_int bn;print_char ' ';print_int nb;print_newline ();
    (bn+1, bc+bn*nb)
in
let qc = List.fold_left qfun (1, 0) blueprints in
()
(*
print_int (snd qc);print_newline ()
*)

(*
    if cnt <= 0 then
        let cmax = getg res in
        if Hashtbl.mem rtable (res, robots) then
            max cmax (Hashtbl.find rtable (res, robots))
        else cmax

*)

(*
print_rbs (List.hd blueprints); print_newline ();

*)
