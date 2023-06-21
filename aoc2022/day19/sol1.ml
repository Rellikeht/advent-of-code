(* DEFINITIONS *)
type recipe = {ore: int; clay: int; obs: int * int; geo: int * int}

(* READING *)

let zeros_blueprint = {ore=0; clay=0; obs=(0, 0); geo=(0, 0)};;
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
    | [g1;g2]::[b1;b2]::[c]::[o]::[] -> {ore=o; clay=c; obs=(b1, b2); geo=(g1, g2)}
    | _ -> zeros_blueprint
;;

let rec get_blueprints bps =
    try match read_blueprint () with
        | {ore=0;clay=0;obs=(0, 0);geo=(0, 0)} -> get_blueprints bps
        | bp -> get_blueprints (bp::bps)
    with End_of_file -> List.rev bps
;;

(* SIMULATION *)

let minutes =
    if Array.length Sys.argv < 2 then 19 (* 24 *)
    else int_of_string Sys.argv.(1)
;;

let get_ore (o, _, _, _) = o;;
let get_clay (_, c, _, _) = c;;
let get_obs (_, _, b, _) = b;;
let get_geo (_, _, _, g) = g;;

let maximum_geodes tab cur_max blueprint =
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
            let state = (robots, resources) in

            if upper < !cur_max then 0
            else
                try
                    let (prev_time, prev_score) = Hashtbl.find tab state in
                    match compare prev_time minutes with
                    | 1 -> raise Exit
                    | _ -> prev_score
                with _ ->
                    let nmin = minute + 1 in
                    let update ((wo, wc, wb, wg), (ro, rc, rb, rg)) =
                        (ro+wo, rc+wc, rb+wb, rg+wg)
                    in
                    let updated = update state in
                    let cur_max = max_geo nmin (robots, updated) in

                    let cur_max =
                        if get_ore resources < blueprint.ore then cur_max
                        else 
                            let new_ore = get_ore resources - blueprint.ore in
                            let new_bot = get_ore robots + 1 in
                            let (new_bots, new_ores) =
                                match (robots, resources) with
                                | ((_, wc, wb, wg), (_, rc, rb, rg)) ->
                                        ((new_bot, wc, wb, wg),
                                        (new_ore, rc, rb, rg))
                            in
                            let
                                new_state = (new_bots, update (robots, new_ores))
                            in
                            max cur_max (max_geo nmin new_state)
                    in

                    let cur_max =
                        if get_ore resources < blueprint.clay then cur_max
                        else 
                            let new_ore = get_ore resources - blueprint.clay in
                            let new_bot = get_clay robots + 1 in
                            let (new_bots, new_ores) =
                                match (robots, resources) with
                                | ((wo, _, wb, wg), (_, rc, rb, rg)) ->
                                        ((wo, new_bot, wb, wg),
                                        (new_ore, rc, rb, rg))
                            in
                            let
                                new_state = (new_bots, update (robots, new_ores))
                            in
                            max cur_max (max_geo nmin new_state)
                    in

                    let cur_max =
                        let (o1, o2) = blueprint.obs in
                        if get_ore resources < o1 || get_clay resources < o2 then cur_max
                        else 
                            let new_ore = get_ore resources - o1 in
                            let new_clay = get_clay resources - o2 in
                            let new_bot = get_obs robots + 1 in
                            let (new_bots, new_ores) =
                                match (robots, resources) with
                                | ((wo, wc, _, wg), (_, _, rb, rg)) ->
                                        ((wo, wc, new_bot, wg),
                                        (new_ore, new_clay, rb, rg))
                            in
                            let
                                new_state = (new_bots, update (robots, new_ores))
                            in
                            max cur_max (max_geo nmin new_state)
                    in

                    let cur_max =
                        let (g1, g2) = blueprint.geo in
                        if get_ore resources < g1 || get_obs resources < g2 then cur_max
                        else 
                            let new_ore = get_ore resources - g1 in
                            let new_obs = get_obs resources - g2 in
                            let new_bot = get_geo robots + 1 in
                            let (new_bots, new_ores) =
                                match (robots, resources) with
                                | ((wo, wc, wb, _), (_, rc, _, rg)) ->
                                        ((wo, wc, wb, new_bot),
                                        (new_ore, rc, new_obs, rg))
                            in
                            let
                                new_state = (new_bots, update (robots, new_ores))
                            in
                            max cur_max (max_geo nmin new_state)
                    in

                    Hashtbl.replace tab state (minute, cur_max);
                    cur_max

    in
    max_geo 0 ((1, 0, 0, 0), (0, 0, 0, 0))
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

(* MAIN *)

let initial_table_size = 1 lsl (minutes + 4);;
let blueprints = get_blueprints [] in

let rec quality_sum blueprints id sum =
    match blueprints with
    | blueprint::rest -> begin
        let cur_max = ref 0 in
        let tab = Hashtbl.create initial_table_size in
        let cur_geo = maximum_geodes tab cur_max blueprint in
        print_endline (string_of_int cur_geo);
        quality_sum rest (id+1) (sum+cur_geo*id)
    end
    | [] -> sum
in print_int (quality_sum blueprints 1 0); print_newline ();;
