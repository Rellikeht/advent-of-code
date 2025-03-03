use std::collections::HashSet;
use std::fs::File;
use std::io::BufRead;
use std::{env, io};

type Itype = i64;
type Vert = usize;
// type MMaze<'a> = Vec<&'a mut Vec<vert>>;
type Maze = Vec<Vec<Vert>>;

fn find_marker(grid: &Vec<&[u8]>, marker: u8) -> (usize, usize) {
    for (i, row) in grid.iter().enumerate() {
        match row.iter().position(|c| *c == marker) {
            Some(j) => return (i, j),
            None => {}
        }
    }
    panic!("No marker {} in grid!!!", marker);
}

fn gen_path(
    grid: &Vec<&[u8]>,
    maze: &mut Maze,
    start: (Itype, Itype),
    end: (Itype, Itype),
    dir: (Itype, Itype),
) {
    // TODO
}

fn gen_maze(grid: &Vec<&[u8]>) -> Maze {
    let start = find_marker(grid, b'S');
    let start = (start.0 as Itype, start.1 as Itype);
    let end = find_marker(grid, b'E');
    let end = (end.0 as Itype, end.1 as Itype);
    let mut maze = vec![];
    let mut verts = HashSet::<(Itype, Itype)>::with_capacity(
        grid.len() * grid[0].len(),
    );

    gen_path(grid, &mut maze, start, end, (1, 0));
    gen_path(grid, &mut maze, start, end, (-1, 0));
    gen_path(grid, &mut maze, start, end, (0, 1));
    gen_path(grid, &mut maze, start, end, (0, -1));
    return maze;
}

// In dot format
fn print_maze(maze: &Maze) {
    println!("graph {{");
    for (vertex, neighbours) in maze.iter().enumerate() {
        for neighbour in neighbours.iter() {
            println!("{} -> {}", vertex, neighbour);
        }
    }
    println!("}}");
}

fn least_cost(maze: &Maze) -> i64 {
    // TODO
    return 0;
}

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let fname: &str;
    if args.len() > 1 {
        fname = &args[1];
    } else {
        fname = "input";
    }
    let file = File::open(fname).unwrap();

    let lines: Vec<String> = io::BufReader::new(file)
        .lines()
        .map(|l| l.unwrap())
        .collect();
    let state: Vec<u8> = lines.join("").bytes().collect();
    let grid: Vec<&[u8]> = state.chunks(lines[0].len()).collect();

    let maze = gen_maze(&grid);
    print_maze(&maze);
    // println!("{}", least_cost(&maze));
}
