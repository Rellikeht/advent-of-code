use std::fs::File;
use std::io::BufRead;
use std::{env, io};

type Num = i64;
type Robot = (Num, Num, Num, Num);
type Board<'a> = Vec<&'a mut [u8]>;

const EMPTY: u8 = b' ';
const ROBOT: u8 = b'#';

fn get_size(line: &String) -> (usize, usize) {
    let mut s = line.split(' ');
    let p1 = s.next().unwrap().parse::<usize>().unwrap();
    let p2 = s.next().unwrap().parse::<usize>().unwrap();
    return (p1, p2);
}

fn get2(str: &str) -> (Num, Num) {
    let mut s = str.split('=');
    let _ = s.next();
    let mut s = s.next().unwrap().split(',');
    let p1 = s.next().unwrap().parse::<Num>().unwrap();
    let p2 = s.next().unwrap().parse::<Num>().unwrap();
    return (p1, p2);
}

fn get_robot(line: &String) -> Robot {
    let mut s1 = line.split(' ');
    let pos = get2(s1.next().unwrap());
    let vel = get2(s1.next().unwrap());
    return (pos.0, pos.1, vel.0, vel.1);
}

fn next_frame(robots: &mut Vec<Robot>, size: &(usize, usize)) {
    for robot in robots.iter_mut() {
        robot.0 = (robot.0 + robot.2 + size.0 as Num) % size.0 as Num;
        robot.1 = (robot.1 + robot.3 + size.1 as Num) % size.1 as Num;
    }
}

fn print_board(robots: &Vec<Robot>, board: &mut Board) {
    for i in 0..board.len() {
        for j in 1..board[i].len() {
            board[i][j] = EMPTY;
        }
    }
    for r in robots {
        board[r.0 as usize][r.1 as usize] = ROBOT;
    }
    for i in 0..board.len() {
        for j in 1..board[i].len() {
            print!("{} ", board[i][j] as char);
        }
        println!("");
    }
}

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let fname: &str;
    if args.len() > 1 {
        fname = &args[1];
    } else {
        fname = "tinput";
    }
    let file = File::open(fname).unwrap();

    let mut lines = io::BufReader::new(file).lines();
    let l1 = lines.next().unwrap().unwrap();
    let size = get_size(&l1);
    let mut robots: Vec<_> = lines.map(|ln| get_robot(&ln.unwrap())).collect();

    let mut state = vec![0 as u8; size.0 * size.1];
    let mut board: Board = state.chunks_mut(size.1).collect();
    let mut step = 0;

    loop {
        // hardcoded shit, because authors wanted that
        if (step - 65) % 103 != 0 || (step - 114) % 101 != 0 {
            next_frame(&mut robots, &size);
            step += 1;
            continue;
        }

        println!("Step {}:", step);
        print_board(&robots, &mut board);
        println!("");
        println!("");
        println!("");
        println!("");
        println!("");

        // This is leftover from endless trials of solving that shit
        let mut line = String::new();
        io::stdin().read_line(&mut line).unwrap();
        if line.len() > 1 && line.as_bytes()[0] == b'q' {
            break;
        }
    }
}
