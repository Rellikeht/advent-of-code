#!/bin/ocaml
(* TYPES AND HELPERS *)

type leaf = V of int | T of vtree
and vtree = { parent : vtree; mutable children : leaf list; }
type token = C of char | I of int
type result = Yes | No | Continue

let ch0 = Char.chr 0;;
let zero bs = Bytes.map (fun _ -> ch0) bs;;
let slen = String.length;;
let digit c = Char.code c - Char.code '0';;

(* LEXER *)

let rec getn ln i num = match ln.[i] with
| ']' -> (num, i)
| '[' -> (num, i)
| ',' -> (num, i+1)
| c -> getn ln (i+1) (num * 10 + digit c)
;;

let rec tokenize ln i tks =
    if i == slen ln then tks
    else match ln.[i] with
    | '[' -> tokenize ln (i+1) (C '['::tks)
    | ']' -> tokenize ln (i+1) (C ']'::tks)
    | ',' -> tokenize ln (i+1) tks
    | c -> let (num, j) = getn ln i 0 in
        tokenize ln j (I num::tks)
;;

let get_tokens str = List.rev (tokenize (str) 0 []) ;;

(* PARSER *)

let rec empty = {parent=eh;children=[]} and eh = {parent=empty;children=[]};;
let get_tree leaf = match leaf with | T t -> t | V _ -> empty ;;

let rec get_item parent tokens ch = match tokens with
    | (C '[')::rest ->
            let nitem = {parent=parent;children=[]} in
            let nch, nrest = get_item nitem rest [] in
            nitem.children <- nch;
            get_item parent nrest ((T nitem)::ch);
    | (I num)::rest -> get_item parent rest ((V num)::ch)
    | (C ']')::rest -> (List.rev ch, rest)
    | _ -> (ch, [])
;;

let read_item str =
    get_tree (List.hd (fst (get_item empty (get_tokens str) [])))
;;

let rec get_items items =
    let i1 = read_item (read_line ()) in
    let i2 = read_item (read_line ()) in
    let endval = i2::i1::items in
    try let _ = read_line () in get_items endval
    with End_of_file -> endval
;;

(* COMPARASION *)

let rec compare t1 t2 =
    let rval v = (v, [], []) in
    match (t1, t2) with
    | [], [] -> rval Continue
    | [], _ -> rval Yes
    | _, [] -> rval No
    | (V v1)::r1, (V v2)::r2 ->
            if v2 < v1 then rval No
            else if v1 < v2 then rval Yes
            else compare r1 r2
    | (T t1)::r1, (T t2)::r2 ->
        let res, _, _ = compare (t1.children) (t2.children) in
        if res == Continue then compare r1 r2 else rval res
    | (V v1)::r1, (T t2)::r2 ->
        let res, _, nr2 = compare ((V v1)::[]) (t2.children) in
        if res == Continue then compare r1 (List.append nr2 r2)
        else rval res
    | (T t1)::r1, (V v2)::r2 ->
        let res, nr1, _ = compare (t1.children) ((V v2)::[]) in
        if res == Continue then compare (List.append nr1 r1) r2
        else rval res
;;

let tcmp t1 t2 =
    let res, _, _ = compare (t1.children) (t2.children) in
    match res with
    | Yes -> 0
    | No | Continue -> 1
;;

let same t1 t2 =
    let res, _, _ = compare (t1.children) (t2.children) in
    match res with
    | Continue -> true
    | _ -> false
;;

(* MAIN *)

let pos tr ls =
    let rec ps ls i = match ls with
    | [] -> -1
    | e::r -> if same e tr then i else ps r (i+1)
    in ps ls 1
;;

let e1 = read_item "[[2]]" in
let e2 = read_item "[[6]]" in
let its = List.rev (get_items []) in
let sorted = List.stable_sort tcmp (List.append [e1;e2] its) in

let e1p = pos e1 sorted in
let e2p = pos e2 sorted in
print_int (e1p*e2p);print_newline ()

(* List.iter (fun x -> print_elems [T x];print_newline ()) sorted; *)

(* PRINT *)

let print_res res = match res with
| Yes -> print_endline "Yes"
| No -> print_endline "No"
| Continue -> print_endline "Continue"
;;

let rec print_tokens tokens =
    let rest = match tokens with
    | (C elem)::rest -> print_char elem; rest
    | (I elem)::rest -> print_int elem; rest
    | [] -> []
    in
    if rest == [] then ()
    else begin
        print_char ' ';
        print_tokens rest
    end
;;

let rec print_elems vals =
    match vals with
    | [] -> ()
    | (V v)::rest -> begin
        print_int v;
        match rest with
        | [] -> print_char ' '
        | _ -> print_char ' '; print_elems rest
    end
    | (T t)::rest -> begin
        print_string "[ ";
        print_elems t.children;
        print_string "] ";
        print_elems rest;
    end;
;;


