(* https://dsheets.github.io/codoc/yojson.1.2.0/yojson/ *)
open Yojson

let input_file =
    if Array.length Sys.argv < 2
    then "tinput"
    else Sys.argv.(1)
;;
if not @@ Sys.file_exists input_file then exit 1 ;;

let get_blueprint line =
    let (num, parts) =
        let parts = String.split_on_char ':' line in
        (
            int_of_string @@
            (fun x -> List.nth x 1) @@
            String.split_on_char ' ' @@
            List.hd parts
            ,
            String.split_on_char '.' @@
            List.nth parts 1
        )
    in

    (*
        All of that is hardcoded shit, but file needs it
        and that's the easiest and simplest way
    *)
    let one_res_part part =
        let words = String.split_on_char ' ' part in
        int_of_string @@ List.nth words 5
    in
    let two_res_part part =
        let words = String.split_on_char ' ' part in
        (int_of_string @@ List.nth words 5, int_of_string @@ List.nth words 8)
    in

    let l1 = List.hd parts in
    let parts = List.tl parts in
    let l2 = List.hd parts in
    let parts = List.tl parts in
    let l3 = List.hd parts in
    let parts = List.tl parts in
    let l4 = List.hd parts in

    let (v1, v2) = two_res_part l3 in
    let (v3, v4) = two_res_part l4 in
    [num;one_res_part l1;one_res_part l2;v1;v2;v3;v4]
;;

let data =
    let channel = open_in input_file in
    (* Non tail recursive version failed :( *)
    let rec get_lines lines =
        try get_lines @@ (input_line channel) :: lines
        with End_of_file -> close_in channel; List.rev lines
    in
    List.map get_blueprint @@ get_lines []
;;

let make_record (data: int list) =
    `List (List.map (fun x -> (`Int x)) (List.tl data))
;;
let json_data =
    `Assoc [
        ("N", `Int (List.length data));
        ("blueprints", `List (List.map make_record data))
    ]
;;

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
(* print_endline @@ pretty_to_string json_data;; *)
