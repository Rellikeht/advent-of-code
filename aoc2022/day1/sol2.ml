let line_int () =
    try read_int ()
    with _ -> -1
;;

let rec cals cur_cals = 
    let nv = (line_int ()) in
        if nv > -1
        then (cals (cur_cals+nv))
        else cur_cals
;;

let up_cals (c1, c2, c3) cn =
    if c1 > cn then
        if c2 > cn then
            if c3 > cn then (c1, c2, c3)
            else (c1, c2, cn)
        else (c1, cn, c2)
    else (cn, c1, c2)
;;

let rec max_cals cur_max = 
    let cv = cals 0 in
        if cv > 0
        then max_cals (up_cals cur_max cv)
        else cur_max
;;

let sum_cals (c1, c2, c3) = c1+c2+c3;;

print_string (string_of_int (sum_cals (max_cals (0, 0, 0))));
print_string "\n"
