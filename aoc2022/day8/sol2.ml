let max_el = '9';;
let start_el = '/';;
let start_size = 100;;

let rec get_lines lines i =
    try
        let ln = read_line () in
        Array.set lines i ln;
        get_lines lines (i+1)
    with End_of_file -> i
;;

let rec make_lines lines slines i e =
    if i = e then ()
    else begin Array.set lines i (slines.(i));
        make_lines lines slines (i+1) e end
;;

let at lines (px, py) = lines.(py).[px];;
let upposv (px, py) step = (px, py+step);;
let pret v = print_string ((string_of_int v)^"\n");v;;
let ppos (px, py) = print_string ((string_of_int px)^" "^(string_of_int py)^"\n");;

let rec cv lines endv elv pos step count =
    if snd pos == endv then count
    else if at lines pos >= elv then count+1
    else cv lines endv elv (upposv pos step) step (count+1)
;;

let valv el lines = let elv = at lines el in
    cv lines (-1) elv (upposv el (-1)) (-1) 0 *
    cv lines (Array.length lines) elv (upposv el 1) 1 0
;;

let rec ch line endv elv pos step count =
    if pos == endv then count
    else if line.[pos] >= elv then count+1
    else ch line endv elv (pos+step) step (count+1)
;;

let valh el line = 
    ch line (-1) (line.[el]) (el-1) (-1) 0 *
    ch line (String.length line) (line.[el]) (el+1) 1 0
;;

let rec calc_index pos lines =
    valh (fst pos) lines.(snd pos) * valv pos lines
;;

let rec calcl lines line lnum pos maxval =
    if pos == String.length line then maxval
    else calcl lines line lnum (pos+1)
    (max maxval (calc_index (pos, lnum) lines))
;;

let rec calca lines line maxval =
    if line == Array.length lines then maxval
    else calca lines (line+1) (calcl lines (lines.(line)) line 0 maxval)
;;

let slines = Array.make start_size "";;
let len = get_lines slines 0;;
let lines = Array.make len "";;
make_lines lines slines 0 len;
let res = calca lines 0 0 in
print_string ((string_of_int res)^"\n")
