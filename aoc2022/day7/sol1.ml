type file = {name: string; size: int}
type directory = {
    name: string;
    size: int ref;
    files: file list;
    dirs: dht;
    parent: directory option
} and dht = (string, directory) Hashtbl.t
let dir name size files dirs parent =
    {name=name;size=size;files=files;dirs=dirs;parent=parent}
;;

let rec fsizes (files : file list) sum = match files with
    | [] -> sum
    | file::rest -> fsizes rest (sum+file.size)
;;

let rec calc_sizes dir =
    let sf _ dir sum = sum + calc_sizes dir
    in let sizes = fsizes (dir.files) 0 + Hashtbl.fold sf dir.dirs 0
    in dir.size := sizes; sizes
;;

let rec at_most dir size sum =
    let sumf _ dir isum = at_most dir size isum in
    let chval = Hashtbl.fold sumf dir.dirs sum in
    if !(dir.size) <= size then chval + !(dir.size)
    else chval
;;

let insize = 128;;
let empty = dir "" (ref 0) [] (Hashtbl.create 0) None;;
let take_dir dir = match dir with | Some dir -> dir | None -> empty ;;
let get_ln () =
    try String.split_on_char ' ' (read_line ())
    with End_of_file -> []
;;

let populate cdir name =
    let nht = Hashtbl.create insize in
    let rec get_contents fl dirs =
        try
            match get_ln () with
            | "$"::_::name::[] -> (fl, "$"::"cd"::name::[])
            | "dir"::name::[] -> begin
                Hashtbl.replace dirs name empty;
                get_contents fl dirs end
            | s::n::[] ->
                    get_contents ({name = n; size = int_of_string s}::fl) dirs
            | _ -> (fl, [])
        with End_of_file -> (fl, "end"::[])
    in let (flist, nhop) = get_contents [] nht in
    let ndir = dir name (ref 0) flist nht (Some cdir) in
    Hashtbl.replace (cdir.dirs) name ndir; nhop
;;

let rec parse_commands line name curdir = match line with
    | "$"::"ls"::[] -> parse_commands (populate curdir name) name curdir
    | "$"::"cd"::".."::[] ->
            parse_commands (get_ln ()) (curdir.name) (take_dir (curdir.parent))
    | "$"::"cd"::nname::[] ->
            parse_commands (get_ln ()) nname (Hashtbl.find (curdir.dirs) name)
    | _ -> ()
;;

read_line ();;read_line ();;parse_commands (populate empty "/") "/" empty;
let root = Hashtbl.find (empty.dirs) "/" in let _ = calc_sizes root in
print_string ((string_of_int (at_most root 100000 0))^"\n")
