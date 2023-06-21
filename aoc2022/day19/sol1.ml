(* DEFINITIONS *)
type robot = Ore of int | Clay of int | Obs of int * int | Geo of int * int
type resources = int * int * int * int
let get_geo (_, _, _, g) = g;;

(* PRINTING *)

let print_robot r =
    (match r with
        | Ore o -> begin print_string "Ore ";print_int o end
        | Clay c -> begin print_string "Clay ";print_int c end
        | Obs (b1, b2) -> begin
            print_string "Obsidian (";
            print_int b1;
            print_string ", ";
            print_int b2;
            print_string ")"
        end
        | Geo (g1, g2) -> begin
            print_string "Geode (";
            print_int g1;
            print_string ", ";
            print_int g2;
            print_string ")"
        end);
;;

let print_res (o, c, b, g) =
    print_string "(";
    print_int o; print_char ' ';
    print_int c; print_char ' ';
    print_int b; print_char ' ';
    print_int g; print_string ")";
;;

(* READING *)

let zeros_blueprint = [Ore 0; Clay 0; Obs (0, 0); Geo (0, 0)];;
let read_blueprint () =
    let recp = List.hd (List.tl (String.split_on_char ':' (read_line ()))) in
    let recs = String.split_on_char '.' recp in
    let getn str = match String.split_on_char ' ' (String.trim str) with
    | _::_::_::_::n1::_::_::n2::_::[] -> [int_of_string n1; int_of_string n2]
    | _::_::_::_::num::_::[] -> [int_of_string num]
    | _ -> [] in
    let rec getns strs ns = match strs with
    | [] -> ns
    | []::rest -> getns rest ns
    | ls::rest -> getns rest (ls::ns)
    in match getns (List.map getn recs) [] with
    | [g1;g2]::[b1;b2]::[c]::[o]::[] -> [Ore o; Clay c; Obs (b1, b2); Geo (g1, g2)]
    | _ -> zeros_blueprint
;;

let rec get_blueprints bps =
    try match read_blueprint () with
        | [Ore 0;Clay 0;Obs (0, 0);Geo (0, 0)] -> get_blueprints bps
        | bp -> get_blueprints (bp::bps)
    with End_of_file -> List.rev bps
;;

(* SIMULATION *)

let minutes =
    if Array.length Sys.argv < 2 then 18 (* 24 *)
    else int_of_string Sys.argv.(1)
;;
let start_robots = (1, 0, 0, 0);;
let start_res = (0, 0, 0, 0);;
let initial_table_size =
    (* (int_of_float (float_of_int 2 ** float_of_int (max (minutes-1) 2))) *)
    (* 1 lsl (minutes / 2 + 1) *)
    1 lsl (minutes - 1)
;;

(* let tab: ((resources, resources), (int, int)) Hashtbl.t = Hashtbl.create initial_table_size;; *)

type r1 = resources * resources
type r2 = int * int
let tab: (r1, r2) Hashtbl.t = Hashtbl.create initial_table_size ;;

let produce ((bot_o, bot_c, bot_b, bot_g), (res_o, res_c, res_b, res_g)) t =
    match t with
    | Some Ore needed_ore ->
            if res_o < needed_ore then None
            else Some ((bot_o+1, bot_c, bot_b, bot_g),
                (res_o-needed_ore, res_c, res_b, res_g))
    | Some Clay needed_ore ->
            if res_o < needed_ore then None
            else Some ((bot_o, bot_c+1, bot_b, bot_g),
                (res_o-needed_ore, res_c, res_b, res_g))
    | Some Obs (needed_ore, needed_clay) ->
            if res_o < needed_ore || res_c < needed_clay then None
            else Some ((bot_o, bot_c, bot_b+1, bot_g),
                (res_o-needed_ore, res_c-needed_clay, res_b, res_g))
    | Some Geo (needed_ore, needed_obs) ->
            if res_o < needed_ore || res_b < needed_obs then None
            else Some ((bot_o, bot_c, bot_b, bot_g+1),
                (res_o-needed_ore, res_c, res_b-needed_obs, res_g))
    | None -> Some ((bot_o, bot_c, bot_b, bot_g), (res_o, res_c, res_b, res_g))
;;

let rec max_geo blueprint minute (robots, resources) =
    if minute >= minutes then begin
        (* print_int minute; print_string " "; *)
        (* print_res robots; print_string " "; *)
        (* print_res resources; print_newline (); *)
        get_geo resources
    end else begin
        let state = (robots, resources) in

        (* print_int minute; print_string " "; *)
        (* print_res robots; print_string " "; *)
        (* print_res resources; print_newline (); *)
        let comp () =
            let nmin = minute + 1 in
            let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) =
                (ro+wo, rc+wc, rb+wb, rg+wg)
            in
            let updated = update state in

            let base_max = max_geo blueprint (minute+1) (robots, updated) in
            let p1 = List.map (fun x -> produce state (Some x)) blueprint in
            let p2 = List.map Option.get (List.filter ((!=) None) p1) in
            let p3 = List.map (fun (w, r) -> (w, update (robots, r))) p2 in
            let p4 = List.map (max_geo blueprint nmin) p3 in
            (* let _ = List.map (fun x -> print_int x; print_string " ") p3 in *)
            (* print_endline ""; *)
            let p5 = List.fold_left max base_max p4 in
            Hashtbl.add tab state (minute, p5); p5
        in

        if Hashtbl.mem tab state then
            let mem = Hashtbl.find tab state in
            if fst mem == minutes then snd mem
            else if fst mem < minutes then 0
            else comp ()

        else comp ()
    end
;;

(* MAIN *)

let blueprints = get_blueprints [] in
let rec quality_sum blueprints id sum =
    match blueprints with
    | blueprint::rest -> begin
        print_string "[ ";
        List.iter (fun x -> print_robot x; print_string " ") blueprint;
        print_endline "] ";
        let cur_geo = max_geo blueprint 0 (start_robots, start_res) in
        print_endline (string_of_int cur_geo);
        quality_sum rest (id+1) (sum+cur_geo*id)
    end
    | [] -> sum
in print_int (quality_sum blueprints 1 0); print_newline ();;
