let sum = ref 0;;
let item_code c =
    let code = Char.code c in
    if code >= 97 then code - 96
    else code - 64 + 26
;;

let find_code str =
    let len = (String.length str)/2 in
    let items = Hashtbl.create (min len 52) in

    for i = 0 to len-1 do
        Hashtbl.replace items str.[i] true
    done;

    let rec find_char i =
        try
            let _ = Hashtbl.find items str.[i] in
            str.[i]
        with
            Not_found -> find_char (i+1)
    in
    item_code (find_char len)
;;

let up_val () =
    try
        let str = read_line () in
        sum := !sum + find_code str;
        true
    with
        End_of_file -> false
;;

while up_val () do () done;;
print_string (string_of_int !sum);
print_string "\n"
