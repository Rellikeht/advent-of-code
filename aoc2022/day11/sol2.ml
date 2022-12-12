type monkey = {
    mutable items : int list;
    div : int;
    operation : int -> int;
    mnum : int -> int;
    mutable inspected : int;
}

let trline () = String.trim (read_line ());;

let get_monkey ln = match String.split_on_char ' ' ln with
| _::_::_::_::"monkey"::num::[] -> int_of_string num
| _ -> 0
;;

let get_monkeys () =
    let m1 = get_monkey (trline ()) in
    let m2 = get_monkey (trline ()) in
    (m1, m2)
;;

let read_monkey () =
    let _ = read_line () in
    let items = match String.split_on_char ' ' (trline ()) with
    | _::"items:"::rest -> List.map
        (fun t -> int_of_string (List.hd (String.split_on_char ',' t))) rest
    | _ -> [] in
    let operation = match String.split_on_char ' ' (trline ()) with
    | _::_::_::"old"::op::second::[] ->
            let oper = match op with
            | "+" -> (+)
            | "*" -> ( * )
            | _ -> fun x y -> 0
            in begin match second with
            | "old" -> fun x -> oper x x
            | _ -> fun x -> oper x (int_of_string second)
            end
    | _ -> (fun x -> 0) in
    let num = match String.split_on_char ' ' (trline ()) with
    | _::_::"by"::num::[] -> int_of_string num
    | _ -> 1 in
    let (m1, m2) = get_monkeys () in 
    let mnum x = if x mod num == 0 then m1 else m2 in
    {items=items;div=num;operation=operation;mnum=mnum;inspected=0}
;;

let rec read_monkeys monkeys gdiv i =
    try
    	let mk = read_monkey () in
        Array.set monkeys i mk;
        let _ = read_line () in
        read_monkeys monkeys (gdiv*mk.div) (i+1)
    with End_of_file -> (i+1, gdiv*(monkeys.(i).div))
;;

let rec throw gdiv mks mk index =
    match mk.items with
    | item::rest -> begin
        let nitem = mk.operation item in
        let nm = mk.mnum nitem in
        mks.(nm).items <- (nitem mod gdiv)::mks.(nm).items;
        mk.items <- rest;
        mk.inspected <- mk.inspected+1;
        throw gdiv mks mk index end
    | [] -> ()
;;

let round monkeys gdiv =
    for i = 0 to Array.length monkeys - 1 do
        throw gdiv monkeys (monkeys.(i)) i
    done;
;;

let rec most_inspected monkeys (m1, m2) i =
    if i == Array.length monkeys then (m1, m2)
    else let mv = monkeys.(i).inspected in
        let (nm1, nm2) =
            if mv > m1 then (mv, m1)
            else if mv > m2 then (m1, mv)
            else (m1, m2)
        in most_inspected monkeys (nm1, nm2) (i+1)
;;

let insize = 20;;
let empty = {items=[];div=1;operation=(fun x -> 0);mnum=(fun x -> 0);inspected=0} in
let monkeys = Array.make insize empty in
let (num, gdiv) = read_monkeys monkeys 1 0 in
let monkeys = Array.sub monkeys 0 num in

for i = 1 to 10000 do
    round monkeys gdiv;
done;
let (i1, i2) = most_inspected monkeys (0, 0) 0 in
print_int (i1*i2);print_char '\n';

(*
let print_monkey monkey =
    print_string "Monkey:\n\titems: ";
    let _ = List.map
        (fun e -> begin print_int e;print_char ' ' end) monkey.items
    in print_string "\n\tdiv: ";
    print_int monkey.div;
    print_string "\n\toperation: ";
    print_int (monkey.operation 1); print_char ' ';
    print_int (monkey.operation 3); print_string "\n\tmnum: ";
    print_int (monkey.mnum 0); print_char ' ';
    print_int (monkey.mnum 1);
    print_string "\n\tinspected: ";
    print_int monkey.inspected; print_string "\n\n";
;;
*)

(*print_int i1;print_char ' ';print_int i2;print_char '\n';*)

(*let tm = {items=[69];operation=(fun x -> 69);mnum=(fun x -> 69);inspected=0} in
Array.set monkeys 0 tm;*)

    (*let _ = Array.map (fun x -> print_monkey x) monkeys in
    print_string "================================================================================\n\n";*)
