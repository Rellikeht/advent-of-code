let msg = read_line ();;

let rec chk msg start len i =
    if i = (start+len) then true
    else let rec chc c j =
            if j = i then true
            else if msg.[j] = c then false
                else chc c (j+1)
        in if chc (msg.[i]) start then chk msg start len (i+1)
        else false
;;

let rec fnd_start msg len i =
    if chk msg i len i then i+len
    else fnd_start msg len (i+1)
;;

let len =
    if Array.length Sys.argv > 1 then int_of_string Sys.argv.(1) else 4
in print_string ((string_of_int (fnd_start msg len 0))^"\n")
