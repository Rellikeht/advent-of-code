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

let rec max_cals cur_max = 
        let cv = cals 0 in
        if cv > 0
        then if cv > cur_max
                then max_cals cv
                else max_cals cur_max
        else cur_max
;;

print_string (string_of_int (max_cals 0));
print_string "\n"
