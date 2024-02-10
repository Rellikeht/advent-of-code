open Yojson;;

let input_file =
    if Array.length Sys.argv < 2
    then "tinput"
    else Sys.argv.(1)
;;
if not @@ Sys.file_exists input_file then exit 1 ;;

let flow_rates = Hashtbl.create 100 ;;
let graph = Hashtbl.create 100 ;;

let parse_line line =
    let parts =
        List.map (String.split_on_char ' ') @@
        String.split_on_char ';' line
    in
    let name_part = List.hd parts in

    let name = List.nth name_part 1 in
    let value =
        List.nth name_part 4 |>
        String.split_on_char '=' |>
        fun x -> List.nth x 1 |>
        int_of_string
    in
    Hashtbl.replace flow_rates name value;

    let connections =
        match List.nth parts 1 with
        | _::_::_::_::_::parts ->
                List.map (fun s -> String.sub s 0 2) parts
        | _ -> failwith "KURWA"
    in
    Hashtbl.replace graph name connections;
;;

let channel = open_in input_file in
let rec parse_lines () =
    try
        parse_line @@ input_line channel;
        parse_lines ()
    with End_of_file -> ()
in
parse_lines ();
close_in channel;

let (names, values) =
    let (p1, p2) =
        Seq.unzip @@
        List.to_seq @@
        List.sort (fun x y -> String.compare (fst x) (fst y)) @@
        List.of_seq @@
        Hashtbl.to_seq flow_rates
    in
    (List.of_seq p1, List.of_seq p2)
in
let numbers =
    let tbl = Hashtbl.create (Hashtbl.length flow_rates) in
    List.iteri (fun i n -> Hashtbl.replace tbl n i) names;
    tbl
in
let paths =
    let make_connections l =
        List.map (Hashtbl.find numbers) l |>
        List.map (fun x -> `Int x)
    in
    List.map (Hashtbl.find graph) names |>
    List.map make_connections |>
    List.map (fun x -> `List x)
in

let number_list =
    List.map (Hashtbl.find numbers) names |>
    List.map (fun x -> `Int x)
in
let names = List.map (fun x -> `String x) names in
let values = List.map (fun x -> `Int x) values in
let json_data =
    `Assoc [
        ("N", `Int (Hashtbl.length flow_rates));
        ("names", `List names);
        ("numbers", `List number_list);
        ("flowRates", `List values);
        ("paths", `List paths)
    ]
in

let output_file =
    let parts = String.split_on_char '.' input_file in
    let main =
        if List.length parts == 1
        then [input_file]
        else List.rev @@ List.tl @@ List.rev parts
    in
    let name = String.concat "" @@ List.concat [main;[".json"]] in
    open_out name
in

Basic.pretty_to_channel output_file json_data;
close_out output_file;
