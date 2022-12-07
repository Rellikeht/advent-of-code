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

let rec min_element dir target cur_min =
    if !(dir.size) < target then cur_min
    else let minf _ cdir minv = min_element cdir target minv
        in let new_min = Hashtbl.fold minf dir.dirs cur_min
        in min new_min !(dir.size)
;;

let space = 70000000;; let needed = 30000000;;
read_line ();;read_line ();;parse_commands (populate empty "/") "/" empty;
let root = Hashtbl.find (empty.dirs) "/" in let _ = calc_sizes root in
let target = needed + !(root.size) - space in
print_string ((string_of_int (min_element root target space))^"\n")

(*
let rec print_dirs parent dir =
    print_string (parent^" -> "^dir.name^" : "^(string_of_int !(dir.size))^" \\ \n");
    let rec print_files (flist : file list) = match flist with
    | file::rest -> begin
        print_string ("- "^file.name^" : "^(string_of_int file.size)^"\n");
        print_files rest end
    | [] -> ()
    in print_files (dir.files);
    Hashtbl.iter (fun _ ndir -> print_dirs (dir.name) ndir) (dir.dirs)
;;
*)
