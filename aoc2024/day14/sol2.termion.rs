use std::fs::File;
use std::io::{stdin, stdout, BufRead, Write};
use std::{env, io, thread, time};

use termion::clear;
use termion::cursor;
use termion::cursor::DetectCursorPos;
use termion::event::Key;
use termion::input::TermRead;
use termion::raw::IntoRawMode;

type Num = i64;
type Robot = (Num, Num, Num, Num);
type Board<'a> = Vec<&'a mut [u8]>;

const EMPTY: u8 = b'.';
const ROBOT: u8 = b'*';

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
    //
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

    // some fucking useless shit needed for keys to work properly
    let mut stdout = io::stdout().into_raw_mode().unwrap();
    // iterator, because why do imperative things imperative way
    let mut events = termion::async_stdin().keys();
    let mut event;

    loop {
        thread::sleep(time::Duration::from_millis(50));
        // some useless shit, because why just give me fucking key
        match events.next() {
            Some(e) => {
                event = e;
            }
            None => {
                continue;
            }
        };

        // finally fucking parsing of the fucking key
        // because why make things simple
        match event.unwrap() {
            Key::Char(c) => {
                if c == 'q' {
                    return;
                }
            }
            _ => {}
        }
        // at least this looks ok, but of course does
        // it's job in a shitty way
        // println!("{}", clear::All);

        // needed, because not your fucking business
        // works so shut up

        write!(stdout, "Step {}", step).unwrap();
        let cpos = stdout.cursor_pos().unwrap();
        write!(stdout, "{}", cursor::Goto(1, cpos.1 + 1)).unwrap();
        // print_board(&robots, &mut board);
        stdout.lock().flush().unwrap();

        next_frame(&mut robots, &size);
        step += 1;
    }
}
