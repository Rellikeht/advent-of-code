use std::fs::File;
use std::io::BufRead;
use std::{env, io};

type itype = i64;
type vert = usize;
// type MMaze<'a> = Vec<&'a mut Vec<vert>>;
type Maze = Vec<Vec<vert>>;

fn find_marker(grid: &Vec<&[u8]>, marker: u8) -> (usize, usize) {
    for (i, row) in grid.iter().enumerate() {
        match row.iter().position(|c| *c == marker) {
            Some(j) => {
                return (i, j);
            }
            None => {}
        }
    }
    panic!("No marker {} in grid!!!", marker);
}

fn gen_path(
    grid: &Vec<&[u8]>,
    maze: &mut Maze,
    start: (itype, itype),
    end: (itype, itype),
    dir: (itype, itype),
) {
    // TODO
}

fn gen_maze(grid: &Vec<&[u8]>) -> Maze {
    let start = find_marker(grid, b'S');
    let start = (start.0 as itype, start.1 as itype);
    let end = find_marker(grid, b'E');
    let end = (end.0 as itype, end.1 as itype);
    let mut maze = vec![];
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
