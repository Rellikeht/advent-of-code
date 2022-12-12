let max_el = '9';;
let start_el = '/';;

let nhpos (x, y) step = (x+step, y);;
let nvpos (x, y) step = (x, y+step);;

let rec hvis line pos step max ext trees =
    if max == max_el || fst pos == ext then ()
    else begin let el = line.[fst pos] in
    let nmax = if el > max then begin
        Hashtbl.replace trees pos true; el end
    else max in hvis line (nhpos pos step) step nmax ext trees end
;;

let hvisible line trees ypos = 
    let slen = String.length line in
    hvis line (slen-1, ypos) (-1) start_el (-1) trees;
    hvis line (0, ypos) 1 start_el slen trees
;;

let rec set_visibility max cur pos trees =
    if fst pos == String.length cur then ()
    else begin if cur.[fst pos] > Bytes.get max (fst pos) then
        begin Hashtbl.replace trees pos true;
        Bytes.set max (fst pos) cur.[fst pos] end
    else Hashtbl.replace trees pos false;
    set_visibility max cur (nhpos pos 1) trees end
;;

let rec parse_line max cur pos trees =
    if fst pos == String.length cur then ()
    else begin if cur.[fst pos] > Bytes.get max (fst pos) then
        begin Hashtbl.replace trees pos true;
        Bytes.set max (fst pos) cur.[fst pos] end
    else (); parse_line max cur (nhpos pos 1) trees end
;;

let rec read_parse_lines max cur lines pos trees =
    set_visibility max cur (0, pos) trees;
    hvisible cur trees pos;
    try let next = read_line () in
        read_parse_lines max next (cur::lines) (pos+1) trees
    with End_of_file -> lines
;;

let rec parse_lines max lines pos trees = match lines with
| cur::rest -> parse_line max cur (0, pos) trees;
        parse_lines max rest (pos+1) trees
| [] -> ()
;;

let start_line = read_line ();;
let zeros = String.to_bytes (String.map (fun _ -> start_el) start_line);;
let hsize = String.length start_line + 1;;
let trees = Hashtbl.create (hsize*hsize);;
let lines = read_parse_lines zeros start_line [] 0 trees;;
let zeros = Bytes.map (fun _ -> start_el) zeros;;
parse_lines zeros lines (List.length lines - 1) trees;
let seen = Hashtbl.fold (fun _ e v -> if e then v+1 else v) trees 0 in
print_string ((string_of_int seen)^"\n")
