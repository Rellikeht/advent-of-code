(* HELPERS *)

let wdirs = [(1,0,0);(0,1,0);(0,0,1);(-1,0,0);(0,-1,0);(0,0,-1)];;
let ios = int_of_string;;
let ppos ch (x, y, z) =
    print_char '(';print_int x;
    print_char ' ';print_int y;
    print_char ' ';print_int z;
    print_char ')';print_char ch
;;
let hpos ch hp _ = ppos ch hp;;

(* READING *)

let rec get_walls (cx, cy, cz) wdirs walls = match wdirs with
| [] -> walls
| (dx,dy,dz)::rest -> begin
    let wall = (2*cx+dx, 2*cy+dy, 2*cz+dz) in
    get_walls (cx, cy, cz) rest (wall::walls)
end
;;

let rec get_cubes cubes points = match cubes with
| [] -> points
| cube::rest -> begin
    let walls = get_walls cube wdirs [] in
    get_cubes rest (walls::points)
end
;;

let rec get_points points (mx, my, mz) (xx, xy, xz) =
    try
        let ln = read_line () in
        let (cx, cy, cz) = match String.split_on_char ',' ln with
        | x::y::z::[] -> (ios x, ios y, ios z) | _ -> (1, 1, 1) in
        let nmin = (min cx mx, min cy my, min cz mz) in
        let nmax = (max cx xx, max cy xy, max cz xz) in
        get_points ((cx, cy, cz)::points) nmin nmax
    with End_of_file -> (points, (mx-2, my-2, mz-2), (xx+2, xy+2, xz+2))
;;

(* ANALYSING *)

let rec add_walls walls wall = match wall with
| [] -> ()
| w::rest -> begin
    if Hashtbl.mem walls w
    then Hashtbl.remove walls w
    else Hashtbl.add walls w true;
    add_walls walls rest
end
;;

let rec mark_pts points moves (mx, my, mz) (xx, xy, xz) =
    if Queue.length moves == 0 then ()
    else begin
        let (cx, cy, cz) = Queue.take moves in
        let ufun (dx, dy, dz) =
            let (nx, ny, nz) = (cx+dx,cy+dy,cz+dz) in
            if Hashtbl.mem points (nx, ny, nz) ||
            nx == mx || ny == my || nz == mz ||
            nx == xx || ny == xy || nz == xz then ()
            else begin
                Queue.add (nx, ny, nz) moves;
                Hashtbl.add points (nx, ny, nz) false; 
            end
        in List.iter ufun wdirs;
        mark_pts points moves (mx, my, mz) (xx, xy, xz)
    end
;;

(* MAIN *)

let (spoints, (mx, my, mz), (xx, xy, xz)) = get_points [] (1, 1, 1) (0, 0, 0) in
let sstart_point = (mx+1, my+1, mz+1) in
let points = Hashtbl.create 20000 in
let movs = Queue.create () in
List.iter (fun p -> Hashtbl.add points p true) spoints;
Hashtbl.add points sstart_point false;
Queue.add sstart_point movs;
mark_pts points movs (mx, my, mz) (xx, xy, xz);

let ipoints =
    let ip = ref [] in
    for i = mx+1 to xx-1 do
        for j = my+1 to xy-1 do
            for k = mz+1 to xz-1 do
                if Hashtbl.mem points (i, j, k) then ()
                else ip := (i, j, k)::!ip
            done
        done
    done; !ip
in

let walls = Hashtbl.create 20000 in
List.iter (add_walls walls) (get_cubes spoints (get_cubes ipoints []));
print_int (Hashtbl.length walls);
print_newline ();
