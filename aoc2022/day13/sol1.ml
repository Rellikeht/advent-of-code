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

let get_tokens () = List.rev (tokenize (read_line ()) 0 []) ;;

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

let rec get_items items =
    let i1t, i2t = (get_tokens (), get_tokens ()) in
    let i1 = get_tree (List.hd (fst (get_item empty i1t []))) in
    let i2 = get_tree (List.hd (fst (get_item empty i2t []))) in
    let endval = (i2, i1)::items in
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
    | (T t1)::r1, (T t2)::r2 -> begin
        let res, _, _ = compare (t1.children) (t2.children) in
        if res == Continue then compare r1 r2 else rval res
    end
    | (V v1)::r1, (T t2)::r2 -> begin
        let res, r1, r2 = compare ((V v1)::[]) (t2.children) in
        if res == Continue then compare r1 r2
        else rval res
    end
    | (T t1)::r1, (V v2)::r2 -> begin
        let res, r1, r2 = compare (t1.children) ((V v2)::[]) in
        if res == Continue then compare r1 r2
        else rval res
    end
;;

let rec ctrees tlist index count =
    match tlist with
    | [] -> count
    | (t1, t2)::rest -> begin
        let res, _, _ = compare (t1.children) (t2.children) in
        if res == Yes then ctrees rest (index+1) (count+index)
        else ctrees rest (index+1) count
    end
;;

(* MAIN *)

let its = List.rev (get_items []) in
print_int (ctrees its 1 0);print_char '\n'

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


