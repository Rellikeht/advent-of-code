let sum = ref 0;;
let item_code c =
    let code = Char.code c in
    if code >= 97 then code - 96
    else code - 64 + 26
;;

let gen_map str = 
    let len = String.length str in
    let items = Hashtbl.create (min len 52) in
    for i = 0 to len-1 do
        Hashtbl.replace items str.[i] true
    done;
    items
;;

let up_map map str =
    let len = String.length str in
    let items = Hashtbl.create (min len 52) in
    for i = 0 to len-1 do
        try
            let _ = Hashtbl.find map str.[i] in
            Hashtbl.replace items str.[i] true
        with
            Not_found -> ()
    done;
    items
;;

let find_code (l1, l2, l3) =
    let items = up_map (gen_map l1) l2 in

    let rec find_char i =
        try
            let _ = Hashtbl.find items l3.[i] in
            l3.[i]
        with
            Not_found -> find_char (i+1)
    in
    item_code (find_char 0)
;;

let up_val () =
    try
        let lines = (read_line (), read_line (), read_line ()) in
        sum := !sum + find_code lines;
        true
    with
        End_of_file -> false
;;

while up_val () do () done;;
print_string (string_of_int !sum);
print_string "\n"
