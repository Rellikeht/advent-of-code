let rec get_rows rows =
    let line = read_line () in
    if String.length line = 0 then rows
    else get_rows (line::rows)
;;

let rec ntl lst n =
    if n = 0 then lst
    else ntl (List.tl lst) (n-1)
;;

let add_token stacks i e = stacks.(i) <- e::stacks.(i);;

let get_stacks rows =
    let slen = (String.length (List.hd rows))/4 + 1 in
    let stacks = Array.make slen [] in

    let rec add_tokens tokens i =
        if tokens = [] then ()
        else begin
            if (List.hd tokens) = "" then
                if (List.tl tokens) = [] then ()
                else add_tokens (ntl tokens 4) (i+1)
            else begin
                add_token stacks i ((List.hd tokens).[1]);
                add_tokens (List.tl tokens) (i+1)
            end
        end
    in

    let rec up_stacks rows =
        if rows = [] then ()
        else begin
            let row = (List.hd rows) in
            if (String.length row) = 0 then ()
            else begin
                let tokens = String.split_on_char ' ' row in
                add_tokens tokens 0;
                up_stacks (List.tl rows)
            end
        end
    in

    up_stacks (List.tl rows);
    stacks
;;

let parse_instr ln =
    let s = String.split_on_char ' ' ln in
    let r1 = List.tl s in
    let n, r2 = List.hd r1, List.tl (List.tl r1) in
    let src, r3 = List.hd r2, List.tl (List.tl r2) in
    let dest = List.hd r3 in
    (int_of_string src - 1, int_of_string dest - 1, int_of_string n)
;;

let rec get_instrs instrs =
    try
        let ln = read_line () in
        Queue.add (parse_instr ln) instrs;
        get_instrs instrs
    with End_of_file -> ()
;;

let pop_top stacks n =
    let e = List.hd stacks.(n) in
    stacks.(n) <- List.tl stacks.(n);
    e
;;

let rec pop stacks src n els =
    if n = 0 then els
    else pop stacks src (n-1) (pop_top stacks src::els)
;;

let rec push stacks els dest =
    if els = [] then ()
    else begin
        add_token stacks dest (List.hd els);
        push stacks (List.tl els) dest
    end
;;

let move_many stacks (src, dest, n) =
    push stacks (pop stacks src n []) dest
;;

let rec execute stacks instrs =
    if Queue.is_empty instrs then ()
    else begin
        move_many stacks (Queue.take instrs);
        execute stacks instrs
    end
;;

let rec print_tops stacks i =
    if i >= (Array.length stacks) then print_char '\n'
    else begin
        print_char (List.hd stacks.(i));
        print_tops stacks (i+1)
    end
;;

let rows = get_rows [];;
let stacks = get_stacks rows;;
let instrs = Queue.create ();;

get_instrs instrs;
execute stacks instrs;
print_tops stacks 0;
