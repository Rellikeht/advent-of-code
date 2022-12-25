let wdirs = [(1,0,0);(0,1,0);(0,0,1);(-1,0,0);(0,-1,0);(0,0,-1)];;
let ios = int_of_string;;

let rec get_walls (cx, cy, cz) wdirs walls = match wdirs with
| [] -> walls
| (dx,dy,dz)::rest -> begin
    let wall = (2*cx+dx,2*cy+dy,2*cz+dz) in
    get_walls (cx, cy, cz) rest (wall::walls)
end
;;

let rec get_cubes cubes =
    try
        let ln = read_line () in
        let cnums = match String.split_on_char ',' ln with
        | x::y::z::[] -> (ios x, ios y, ios z)
        | _ -> (0,0,0) in
        let walls = get_walls cnums wdirs [] in
        get_cubes (walls::cubes)
    with End_of_file -> cubes
;;

let rec add_walls walls wall = match wall with
| [] -> ()
| w::rest -> begin
    if Hashtbl.mem walls w
    then Hashtbl.remove walls w
    else Hashtbl.add walls w true;
    add_walls walls rest
end
;;

let cubes = get_cubes [] in
let walls = Hashtbl.create 5000 in
List.iter (add_walls walls) cubes;
print_int (Hashtbl.length walls); print_newline ();
