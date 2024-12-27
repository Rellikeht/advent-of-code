use std::fs::File;
use std::io::BufRead;
use std::{env, io};

type Vert = u64;
type Maze = Vec<Vec<Vert>>;

fn gen_maze(grid: &Vec<&[u8]>) -> Maze {
    // TODO
    return vec![];
}

fn print_maze(maze: &Maze) {
    // TODO
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

    // how to measure number of lines ???
    // let state: Vec<u8> = io::BufReader::new(file)
    //     .lines()
    //     .map(|l| l.unwrap().bytes())
    //     .flatten()
    //     .collect();

    let lines: Vec<String> = io::BufReader::new(file)
        .lines()
        .map(|l| l.unwrap())
        .collect();
    let state: Vec<u8> = lines.join("").bytes().collect();
    let grid: Vec<&[u8]> = state.chunks(lines[0].len()).collect();

    let maze = gen_maze(&grid);
    print_maze(&maze);
    println!("{}", least_cost(&maze));
}
