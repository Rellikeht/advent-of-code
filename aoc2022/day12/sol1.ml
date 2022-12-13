let get_map map (x, y) w = Bytes.get map (y*w+x);;
let set_map map (x, y) w ch = Bytes.set map (y*w+x) ch;;
let get_arr arr (x, y) w = Array.get arr (y*w+x);;
let set_arr arr (x, y) w v = Array.set arr (y*w+x) v;;
let poses = [|(1,0);(0,1);(0,-1);(-1,0)|];;
let endval = Array.length poses-1;;

let rec read_map cur_map height =
    try
        let ln = Bytes.of_string (read_line ()) in
        read_map (Bytes.cat cur_map ln) (height+1)
    with End_of_file -> (cur_map, height+1)
;;

let get_pos pos w = (pos mod w, pos / w);;
let upp (x, y) (dx, dy) = (x+dx,y+dy);;
let can_move map (w, h) (x, y) ch =
    if x >= 0 && x < w && y >= 0 && y < h then
        let chc = Char.code ch in
        let dc = Char.code (get_map map (x, y) w) in
        chc >= dc-1
    else false
;;

let rec mark map marks w h endp pos v moves inf =
    let cval = get_map map pos w in
    for i = 0 to endval do
        let npos = upp pos (poses.(i)) in
        if can_move map (w, h) npos cval &&
        get_arr marks npos w == inf then begin
            set_arr marks npos w (v+1);
            Queue.add (npos, (v+1)) moves
        end else ()
    done;
    if Queue.length moves > 0 then
        let (npos, nval) = Queue.take moves in
        mark map marks w h endp npos nval moves inf
    else ()
;;

let fline = read_line () in
let width = String.length fline in
let (map, height) = read_map (Bytes.of_string fline) 0 in
let stp = get_pos (Bytes.index map 'S') width in
let endp = get_pos (Bytes.index map 'E') width in
let inf = width*height+1 in
let marks = Array.make (width*height) inf in
let moves = Queue.create () in
set_arr marks stp width 0;
set_map map stp width 'a';
set_map map endp width 'z';
mark map marks width height endp stp 0 moves inf;
print_int (get_arr marks endp width);print_char '\n';
