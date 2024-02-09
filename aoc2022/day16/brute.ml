module Vset = Set.Make(String);;

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

let rec parse_lines () =
    try
        parse_line @@ read_line ();
        parse_lines ()
    with End_of_file -> ()
in parse_lines ();

let max_time =
    if Array.length Sys.argv > 1
    then int_of_string Sys.argv.(1)
    else 20
in
let nonzero = 
    Seq.filter (fun x -> x > 0) @@
    Hashtbl.to_seq_values flow_rates
in
let closed_amount = Seq.length nonzero in
let opened = ref Vset.empty in

let rec optimize vert time speed pres left =
    let time_left = max_time - time in
    if time >= max_time then pres
    else if left = 0 then pres + speed*time_left
    else begin

        let pres_next = pres + speed in
        let (speed_next, left_next) =
            if Vset.mem vert !opened then (speed, left)
            else
                let cur_val = Hashtbl.find flow_rates vert in
                if cur_val == 0 then (speed, left)
                else (speed+cur_val, left-1)
        in

        let not_opened =
            if left_next == left then 0
            else
                List.fold_left max 0 @@
                List.map
                (fun v -> optimize v (time+1) speed pres_next left) @@
                Hashtbl.find graph vert
        in

        opened := Vset.add vert !opened;
        let max_res =
            List.fold_left max not_opened @@
            List.map
            (fun v -> optimize v (time+1) speed_next pres_next left_next) @@
            Hashtbl.find graph vert
        in
        opened := Vset.remove vert !opened;
        max_res
    end
in

print_int @@ optimize "AA" 0 0 0 closed_amount;
print_newline ()
