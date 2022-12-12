module IS = Set.Make(Int);;
let vals = IS.of_list [20;60;100;140;180;220];;
let screenx = 40;;
let screeny = 6;;
let screen = Array.make (screenx*screeny) '.';;

let pix_at cycle xreg =
    let ppos = cycle mod screenx in
    if ppos >= (xreg-1) && ppos <= (xreg+1) then '#' else '.'
;;

let rec execute cycle register ln =
    let nc = cycle+1 in
    let pos = cycle-1 in
    try match String.split_on_char ' ' ln with
    | "noop"::[] -> begin
        Array.set screen pos (pix_at pos register);
        execute nc register (read_line ()) end
    | "addx"::n::[] -> begin
        let num = int_of_string n in
        Array.set screen pos (pix_at pos register);
        execute nc register (string_of_int num) end
    | n::[] -> begin
        let num = int_of_string n in
        Array.set screen pos (pix_at pos register);
        execute nc (register+num) (read_line ()) end
    | _ -> ()
    with End_of_file -> ()
;;

execute 1 1 (read_line ());
for i = 0 to screeny-1 do
    for j = 0 to screenx-1 do
        print_char (screen.(i*screenx + j))
    done;
    print_char '\n'
done
