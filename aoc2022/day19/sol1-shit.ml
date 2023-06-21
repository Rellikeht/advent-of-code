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

let print_blueprint blueprint =
    print_string "[ ";
    List.iter (fun x -> print_robot x; print_string " ; ") blueprint;
    print_endline "] ";
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
    if Array.length Sys.argv < 2 then 19 (* 24 *)
    else int_of_string Sys.argv.(1)
;;
let start_robots = (1, 0, 0, 0);;
let start_res = (0, 0, 0, 0);;
let initial_table_size =
    1 lsl (minutes + 4)
;;

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

(*
18 0 0 0
19 1 1 3
20 2 2 6
21 3 4 11
22 5 6 17
23 7 9 25
24 9 12 33
*)

let maximum_geodes cur_max blueprint robots resources =
    let rec max_geo minute (robots, resources) =
        if minute >= minutes then
            let geodes = get_geo resources in
            if !cur_max < geodes then cur_max := geodes
            else (); geodes

        else
            let time_left = (minutes - minute + 1) in
            let upper =
                time_left * (get_geo robots + 1) +
                time_left * (time_left - 1)/2
            in

            if upper < !cur_max then 0
            else
                let state = (robots, resources) in
                let nmin = minute + 1 in
                let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) =
                    (ro+wo, rc+wc, rb+wb, rg+wg)
                in
                let updated = update state in

                let p1 =
                    List.map (fun x -> produce state (Some x)) blueprint
                in
                let p2 = List.map Option.get (List.filter ((!=) None) p1) in
                let p3 =
                    List.map (fun (w, r) -> (w, update (robots, r))) p2
                in

                let p4 = List.map (max_geo nmin) p3 in
                let p5 = List.fold_left max 0 p4 in
                let total = max (max_geo nmin (robots, updated)) p5 in
                total
    in

    max_geo 0 (robots, resources)
;;


(* MAIN *)

let blueprints = get_blueprints [] in
let rec quality_sum blueprints id sum =
    match blueprints with
    | blueprint::rest -> begin
        (* let tab: (t1, t2) Hashtbl.t = Hashtbl.create initial_table_size in *)
        let cur_max = ref 0 in
        let cur_geo = maximum_geodes cur_max blueprint start_robots start_res in
        print_endline (string_of_int cur_geo);
        quality_sum rest (id+1) (sum+cur_geo*id)
    end
    | [] -> sum
in print_int (quality_sum blueprints 1 0); print_newline ();;

(* THAT WAS GOOD *)
(*======================================================================*)
(* type t1 = resources * resources *)
(* type t2 = int * int *)

(* let maximum_geodes tab cur_max blueprint robots resources = *)
(*     let rec max_geo minute (robots, resources) = *)
(*         if minute >= minutes then *)
(*             begin *)
(*                 let geodes = get_geo resources in *)
(*                 if !cur_max < geodes then cur_max := geodes *)
(*                 else (); geodes *)
(*             end *)

(*         else *)
(*             begin *)
(*                 let state = (robots, resources) in *)
(*                 let comp () = *)
(*                     let nmin = minute + 1 in *)
(*                     let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) = *)
(*                         (ro+wo, rc+wc, rb+wb, rg+wg) *)
(*                     in *)
(*                     let updated = update state in *)

(*                     let p1 = List.map (fun x -> produce state (Some x)) blueprint in *)
(*                     let p2 = List.map Option.get (List.filter ((!=) None) p1) in *)
(*                     let p3 = List.map (fun (w, r) -> (w, update (robots, r))) p2 in *)
(*                     let p4 = List.map (max_geo nmin) p3 in *)
(*                     let p5 = List.fold_left max 0 p4 in *)
(*                     let total = max (max_geo (minute+1) (robots, updated)) p5 in *)
(*                     Hashtbl.replace tab state (minute, total); total *)
(*                 in *)

(*                 try *)
(*                     let time_left = (minutes - minute + 1) in *)
(*                     let upper = *)
(*                         time_left * (get_geo robots + 1) + *)
(*                         time_left * (time_left + 1)/2 *)
(*                     in *)
(*                     if upper < !cur_max then 0 *)
(*                     else *)
(*                         let (mmin, mresult) = Hashtbl.find tab state in *)
(*                         if mmin > minute then raise Exit *)
(*                         else mresult *)
(*                 with _ -> comp() *)
(*             end *)
(*     in *)

(*     max_geo 0 (robots, resources) *)
(* ;; *)
(*======================================================================*)


(* type t1 = resources * resources *)
(* type t2 = int * int *)
(* let maximum_geodes tab blueprint robots resources = *)
(*     let rec max_geo minute (robots, resources) = *)
(*         if minute >= minutes then get_geo resources *)
(*         else begin *)
(*             let state = (robots, resources) in *)
(*             let comp () = *)
(*                 let nmin = minute + 1 in *)
(*                 let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) = *)
(*                     (ro+wo, rc+wc, rb+wb, rg+wg) *)
(*                 in *)
(*                 let updated = update state in *)

(*                 let base_max = max_geo (minute+1) (robots, updated) in *)
(*                 let p1 = List.map (fun x -> produce state (Some x)) blueprint in *)
(*                 let p2 = List.map Option.get (List.filter ((!=) None) p1) in *)
(*                 let p3 = List.map (fun (w, r) -> (w, update (robots, r))) p2 in *)
(*                 let p4 = List.map (max_geo nmin) p3 in *)
(*                 let p5 = List.fold_left max base_max p4 in *)
(*                 Hashtbl.replace tab state (minute, p5); p5 *)
(*             in *)

(*             try *)
(*                 let (mmin, mresult) = Hashtbl.find tab state in *)
(*                 if mmin > minute then raise Exit *)
(*                 else mresult *)
(*             with _ -> comp() *)
(*         end *)
(*     in max_geo 0 (robots, resources) *)
(* ;; *)


(* type t1 = (resources * resources) * int *)
(* type t2 = int *)
(* let maximum_geodes tab blueprint robots resources = *)
(*     let rec max_geo minute (robots, resources) = *)
(*         if minute >= minutes then get_geo resources *)
(*         else begin *)
(*             let state = (robots, resources) in *)
(*             let comp () = *)
(*                 let nmin = minute + 1 in *)
(*                 let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) = *)
(*                     (ro+wo, rc+wc, rb+wb, rg+wg) *)
(*                 in *)
(*                 let updated = update state in *)

(*                 let base_max = max_geo (minute+1) (robots, updated) in *)
(*                 let p1 = List.map (fun x -> produce state (Some x)) blueprint in *)
(*                 let p2 = List.map Option.get (List.filter ((!=) None) p1) in *)
(*                 let p3 = List.map (fun (w, r) -> (w, update (robots, r))) p2 in *)
(*                 let p4 = List.map (max_geo nmin) p3 in *)
(*                 let p5 = List.fold_left max base_max p4 in *)
(*                 Hashtbl.replace tab (state, minute) p5; p5 *)
(*             in *)

(*             if Hashtbl.mem tab (state, minute) then *)
(*                 let mem = Hashtbl.find tab (state, minute) in mem *)
(*             else comp () *)
(*         end *)
(*     in max_geo 0 (robots, resources) *)
(* ;; *)

(* let rec max_geo blueprint minute (robots, resources) = *)
(*     if minute >= minutes then begin *)
(*         (1* print_int minute; print_string " "; *1) *)
(*         (1* print_res robots; print_string " "; *1) *)
(*         (1* print_res resources; print_newline (); *1) *)
(*         get_geo resources *)
(*     end else begin *)
(*         let state = (robots, resources) in *)

(*         (1* print_int minute; print_string " "; *1) *)
(*         (1* print_res robots; print_string " "; *1) *)
(*         (1* print_res resources; print_newline (); *1) *)
(*         let comp () = *)
(*             let nmin = minute + 1 in *)
(*             let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) = *)
(*                 (ro+wo, rc+wc, rb+wb, rg+wg) *)
(*             in *)
(*             let updated = update state in *)

(*             let base_max = max_geo blueprint (minute+1) (robots, updated) in *)
(*             let p1 = List.map (fun x -> produce state (Some x)) blueprint in *)
(*             let p2 = List.map Option.get (List.filter ((!=) None) p1) in *)
(*             let p3 = List.map (fun (w, r) -> (w, update (robots, r))) p2 in *)
(*             let p4 = List.map (max_geo blueprint nmin) p3 in *)
(*             (1* let _ = List.map (fun x -> print_int x; print_string " ") p3 in *1) *)
(*             (1* print_endline ""; *1) *)
(*             let p5 = List.fold_left max base_max p4 in p5 *)
(*         in comp () *)
(*     end *)
(* ;; *)
