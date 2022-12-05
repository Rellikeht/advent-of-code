let rec id (x::rest) n =
    match n with 
    | 0 -> x
    | _ -> id rest (n-1)
;;

let get_pair () =
    try
        let pairs = String.split_on_char ',' (read_line ()) in
        let get_range str = 
            let ns = String.split_on_char '-' str in
            (int_of_string (id ns 0), int_of_string (id ns 1))
        in
        Some (get_range (id pairs 0), get_range (id pairs 1))
    with
        End_of_file -> None
;;

let soi = string_of_int;;

let rec conut_pairs c =
    let pair = get_pair () in
    match pair with
    | None -> c
    | Some ((f1, f2), (s1, s2)) ->
            if (f1 = s1) || (f2 = s2) then conut_pairs (c+1)
            else if f1 < s1 then
                    if f2 > s2 then conut_pairs (c+1)
                    else conut_pairs c
                else if f2 < s2 then conut_pairs (c+1)
                    else conut_pairs c
;;

print_string ((soi (conut_pairs 0))^"\n")
