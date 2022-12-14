type cell = Empty | Wall | Sand
let cchar cell = match cell with | Empty -> '.' | Wall -> '#' | Sand -> 'o';;

let get_at map x y w = map.(y*w+x);;
let set_at map x y w c = map.(y*w+x) <- c;;

(* PRINTING *)

let print_pair (i1, i2) =
    print_int i1;print_char ' ';print_int i2;print_char '\n'
;;

let print_llist lns = List.iter print_pair lns ;;
let print_lines lines = 
    List.iter (fun ln -> print_llist ln;print_char '\n') lines
;;

let rec print_map map w h x y =
    if y == h then ()
    else if x == w then begin
        print_char '\n';
        print_map map w h 0 (y+1)
    end else begin
        print_char (cchar map.(y*w+x));
        print_map map w h (x+1) y
    end
;;

(* GENERATING *)

let get_num nspec = match String.split_on_char ',' nspec with
| n1::n2::[] -> (int_of_string n1, int_of_string n2)
| _ -> (0, 0)
;;

let rec get_lines lns =
    try
        let els = String.split_on_char ' ' (read_line ()) in
        let cmpf s = not (String.equal "->" s) in
        get_lines (List.map get_num (List.filter cmpf els)::lns)
    with End_of_file -> lns
;;

let rec gen_segment map w (x, y) (dx, dy) (ex, ey) =
    set_at map x y w Wall;
    if x == ex && y == ey then ()
    else gen_segment map w (x+dx,y+dy) (dx, dy) (ex, ey)
;;

let rec gen_line map w line prev bot = match line with
| cur::rest -> begin
    let (py, cy) = (snd prev, snd cur) in
    let (dx, dy) = (compare (fst prev) (fst cur), compare py cy)
    in gen_segment map w cur (dx, dy) prev;
    gen_line map w rest cur (max bot (min cy py))
end | [] -> bot
;;

let rec gen_lines map w lines bot = match lines with
| line::rest -> begin
    let nbot = gen_line map w (List.tl line) (List.hd line) bot in
    gen_lines map w rest nbot
end | [] -> bot
;;

(* SIMULATION *)

let rec drop map w (x, y) =
    let ny = y+1 in
    let nx = if get_at map x ny w == Empty then Some x
    else if get_at map (x-1) ny w == Empty then Some (x-1)
    else if get_at map (x+1) ny w == Empty then Some (x+1)
    else None in match nx with
    | None -> begin
        set_at map x y w Sand; (x, y)
    end
    | Some nx -> drop map w (nx, ny)
;;

let rec drops map w bot (stx, sty) count =
    let (dx, dy) = drop map w (stx, sty) in
    if dx == stx && dy == sty then count+1
    else drops map w bot (stx, sty) (count+1)
;;

(* MAIN *)

let width = 1000 in
let height = 250 in
let stp = (500, 0) in
let map = Array.make (width*height) Empty in
let bot = gen_lines map width (get_lines []) 0 + 2 in
for i = 0 to width-1 do
    set_at map i bot width Wall
done;
print_int (drops map width bot stp 0);print_char '\n'
