let rec get_rows rows =
    let line = read_line () in
    if String.length line = 0 then rows
    else get_rows (line::rows)
;;

let rec top lst n = if n = 0 then lst else top (List.tl lst) (n-1) ;;
let puth_top stacks i e = stacks.(i) <- e::stacks.(i) ;;
let pop_top stacks n = let e = List.hd stacks.(n) in
    stacks.(n) <- List.tl stacks.(n); e
;;

let get_stacks rows =
    let stacks = Array.make ((String.length (List.hd rows))/4 + 1) [] in

    let rec add_tokens tokens i =
        if tokens = [] then ()
        else if (List.hd tokens) = "" then
                if (List.tl tokens) = [] then ()
                else add_tokens (top tokens 4) (i+1)
            else begin
                puth_top stacks i ((List.hd tokens).[1]);
                add_tokens (List.tl tokens) (i+1)
        end
    in

    let up_stack row =
        if (String.length row) = 0 then ()
        else let tokens = String.split_on_char ' ' row in
            add_tokens tokens 0
    in let _ = List.map up_stack (List.tl rows) in stacks
;;

let move_many stacks (src, dest, n) =
    for i = 1 to n do puth_top stacks dest (pop_top stacks src) done
;;

let parse_instr (_::n::_::src::_::dest::_) =
    (int_of_string src - 1, int_of_string dest - 1, int_of_string n)
;;

let rec execute stacks =
    try let ln = read_line () in
        move_many stacks (parse_instr (String.split_on_char ' ' ln));
        execute stacks
    with End_of_file -> ()
;;

let stacks = get_stacks (get_rows []) in execute stacks;
let _ = Array.map (fun s -> print_char (List.hd s)) stacks in print_char '\n'
