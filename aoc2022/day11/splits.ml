let rec spl () =
    try
        let _ = List.map (fun s -> print_string ("\""^s^"\" "))
        (String.split_on_char ' ' (read_line ())) in 
        print_char '\n';spl ()
    with End_of_file -> ()
;;
spl ()
