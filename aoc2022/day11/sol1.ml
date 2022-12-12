type monkey = {
    mutable items : int list;
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
    {items=items;operation=operation;mnum=mnum;inspected=0}
;;

let rec read_monkeys monkeys i =
    try
        Array.set monkeys i (read_monkey ());
        let _ = read_line () in
        read_monkeys monkeys (i+1)
    with End_of_file -> i+1
;;

let rec throw mks mk index =
    match mk.items with
    | item::rest -> begin
        let nitem = mk.operation item / 3 in
        let nm = mk.mnum nitem in
        mks.(nm).items <- nitem::mks.(nm).items;
        mk.items <- rest;
        mk.inspected <- mk.inspected+1;
        throw mks mk index end
    | [] -> ()
;;

let round monkeys =
    for i = 0 to Array.length monkeys - 1 do
        throw monkeys (monkeys.(i)) i
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
let empty = {items=[];operation=(fun x -> 0);mnum=(fun x -> 0);inspected=0} in
let monkeys = Array.make insize empty in
let num = read_monkeys monkeys 0 in
let monkeys = Array.sub monkeys 0 num in

for i = 0 to 19 do
    round monkeys;
done;
let (i1, i2) = most_inspected monkeys (0, 0) 0 in
print_int (i1*i2);print_char '\n';
