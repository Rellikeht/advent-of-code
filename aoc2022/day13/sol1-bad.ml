(*type vtree = Tree of vtree * vtree * int list*)
type vtree = {
    mutable parent : vtree option;
    mutable children : vtree list;
    mutable elements : int list
}
type telem = C of char | S of string | I of int

(*
let rec str_rev str out i j =
    if i == Bytes.length out then out
    else begin
        Bytes.set out i (str.[j]);
        str_rev str out (i+1) (j-1)
    end
;;
*)

let slen = String.length;;

let rec ladd2 l1 l2 = match l1 with
    | [] -> l2
    | s::r -> ladd2 r (s::l2)
;;

let ladd3 l1 l2 l3 = ladd2 l1 (ladd2 l2 l3);;

let rec print_tokens tokens = match tokens with
| (S elem)::rest ->
        print_string elem;
        print_char ' ';
        print_tokens rest
| (C elem)::rest ->
        print_char elem;
        print_char ' ';
        print_tokens rest
| _ -> print_char '\n'
;;

let rec tokens_ends elem cur stop step ch tks =
    if cur == stop then tks
    else if elem.[cur] == ch then
        tokens_ends elem (cur+step) stop step ch ((C ch)::tks)
        else begin
            let minmax a b = if a > b then (b, a) else (a, b) in
            let (b, e) = minmax cur (abs (stop-cur)) in
            (S (String.sub elem b e))::tks
        end
;;


let tokens_elem elem =
    match tokens_ends elem 0 (slen elem) 1 '[' [] with
    | (S start)::r1 -> begin
        let rr1 = List.rev r1 in
        match tokens_ends start (slen start - 1) ~-1 ~-1 ']' [] with
        | (S start)::r2 -> ladd3 rr1 [S start] (List.rev r2)
        | l -> ladd2 rr1 l
        end
    | l -> l
;;

let rec tokenize elems tokens = match elems with
    | [] -> tokens
    | (elem::rest) -> begin
        let tks = List.rev (tokens_elem elem) in
        tokenize rest (ladd2 tks tokens)
    end
;;

let get_tokens () =
    let ln = read_line () in
    tokenize (String.split_on_char ',' ln) []
;;

    (*
    let ln_len = String.length ln in
    let rev = str_rev ln (Bytes.make ln_len ' ') 0 (ln_len-1) in
(*(String.split_on_char ',' (read_line ()))*)
    tokenize (String.of_bytes rev) 0 []
    *)

let rec get_item tokens item =
    print_tokens tokens; print_char '\n';
    if tokens == [] then item
    else begin
        item
    end
;;

let rec get_items items =
        let i1 = {parent=None;children=[];elements=[]} in
        let i2 = {parent=None;children=[];elements=[]} in
        let i1 = get_item (get_tokens ()) i1 in
        let i2 = get_item (get_tokens ()) i2 in
    try
        let _ = read_line () in
        get_items ((i1, i2)::items)
    with End_of_file -> (i1, i2)::items
;;

get_items []
(*
*)
