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

let rec cv lines el elv pos step =
    if snd pos == el then true
    else if at lines pos >= elv then false
    else cv lines el elv (upposv pos step) step
;;

let checkv el lines = let ev = lines.(snd el).[fst el] in
    cv lines (snd el) ev (fst el, 0) 1 ||
    cv lines (snd el) ev (fst el, Array.length lines - 1) (-1)
;;

let rec ch line el elv pos step =
    if pos == el then true
    else if line.[pos] >= elv then false
    else ch line el elv (pos+step) step
;;

let checkh el line = ch line el (line.[el]) 0 1 ||
    ch line el (line.[el]) (String.length line - 1) (-1)
;;

let rec check_index pos lines =
    if checkh (fst pos) lines.(snd pos) then true
    else checkv pos lines
;;

let rec calcl lines line lnum pos count =
    if pos == String.length line then count
    else calcl lines line lnum (pos+1)
    (count + if check_index (pos, lnum) lines then 1 else 0)
;;

let rec calca lines line count =
    if line == Array.length lines then count
    else calca lines (line+1) (calcl lines (lines.(line)) line 0 count)
;;

let slines = Array.make start_size "";;
let len = get_lines slines 0;;
let lines = Array.make len "";;
make_lines lines slines 0 len;
let res = calca lines 0 0 in
print_string ((string_of_int res)^"\n")
