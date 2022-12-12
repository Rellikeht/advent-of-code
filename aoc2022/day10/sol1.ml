module IS = Set.Make(Int);;
let vals = IS.of_list [20;60;100;140;180;220];;

let rec execute cycle register sum =
    try match String.split_on_char ' ' (read_line ()) with
    | "noop"::[] ->
            if IS.exists ((==) cycle) vals then
                execute (cycle+1) register (sum+(register*cycle))
            else execute (cycle+1) register sum
    | "addx"::n::[] ->
            let num = int_of_string n in
            let addv = register * 
                if IS.exists ((==) cycle) vals then cycle
                else if IS.exists ((==) (cycle+1)) vals then cycle+1 else 0
            in execute (cycle+2) (register+num) (sum+addv)
    | _ -> execute cycle register sum
    with End_of_file -> sum
;;

print_int (execute 1 1 0);
print_char '\n'
