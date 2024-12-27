use std::fs::File;
use std::io::BufRead;
use std::{env, io};

pub fn print_grid(grid: &Vec<&mut [u8]>) {
    for i in 1..grid.len() - 1 {
        for j in 1..grid[0].len() - 1 {
            print!("{}", grid[i][j] as char);
        }
        println!("");
    }
}

fn move_dir(m: u8) -> Result<(i64, i64), ()> {
    return match m {
        b'^' => Ok((-1, 0)),
        b'<' => Ok((0, -1)),
        b'>' => Ok((0, 1)),
        b'v' => Ok((1, 0)),
        _ => Err(()),
    };
}

fn find_position(grid: &Vec<&mut [u8]>) -> Result<(i64, i64), ()> {
    for i in 1..grid.len() - 1 {
        for j in 1..grid[0].len() - 1 {
            if grid[i][j] == b'@' {
                return Ok((i as i64, j as i64));
            }
        }
    }
    return Err(());
}

fn do_moves(grid: &mut Vec<&mut [u8]>, moves: &[u8]) {
    let mut pos = find_position(grid).unwrap();
    let last = (grid.len() as i64 - 1, grid[0].len() as i64 - 1);

    for m in moves {
        let m = move_dir(*m).unwrap();
        let mut cur = pos;
        grid[pos.0 as usize][pos.1 as usize] = b'.';
        // println!("p {} {}", pos.0, pos.1);

        loop {
            cur = (cur.0 + m.0, cur.1 + m.1);
            // println!("{} {}", cur.0, cur.1);
            if cur.0 < 1 || cur.0 > last.0 || cur.1 < 1 || cur.1 > last.1 {
                break;
            }
            if grid[cur.0 as usize][cur.1 as usize] == b'#' {
                break;
            }

            if grid[cur.0 as usize][cur.1 as usize] == b'.' {
                // println!(
                //     "({} {}) ({} {}) ({} {})",
                //     pos.0, pos.1, cur.0, cur.1, m.0, m.1
                // );

                match m {
                    (0, 1) => {
                        for i in (pos.1..cur.1).rev() {
                            grid[pos.0 as usize][(i + m.1) as usize] =
                                grid[pos.0 as usize][i as usize];
                            // println!("{} {}", pos.0, i);
                        }
                    }
                    (0, -1) => {
                        for i in cur.1 - m.1..pos.1 {
                            grid[pos.0 as usize][(i + m.1) as usize] =
                                grid[pos.0 as usize][i as usize];
                            // println!("{} {}", pos.0, i);
                        }
                    }
                    (1, 0) => {
                        for i in (pos.0..cur.0).rev() {
                            grid[(i + m.0) as usize][pos.1 as usize] =
                                grid[i as usize][pos.1 as usize];
                            // println!("{} {}", i, pos.1);
                        }
                    }
                    (-1, 0) => {
                        for i in cur.0 - m.0..pos.0 {
                            grid[(i + m.0) as usize][pos.1 as usize] =
                                grid[i as usize][pos.1 as usize];
                            // println!("{} {}", i, pos.1);
                        }
                    }

                    _ => panic!("KURWA"),
                }

                pos = (pos.0 + m.0, pos.1 + m.1);
                break;
            }
        }

        grid[pos.0 as usize][pos.1 as usize] = b'@';
        // print_grid(grid);
        // println!("");
    }
}

fn calc_boxes(grid: &Vec<&mut [u8]>) -> usize {
    let mut sum = 0;
    for i in 1..grid.len() - 1 {
        for j in 1..grid[0].len() - 1 {
            if grid[i][j] == b'O' {
                sum += 100 * i + j;
            }
        }
    }
    return sum;
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
    let mut lines_iter = io::BufReader::new(file).lines();

    let mut lines: Vec<String> = vec![];
    loop {
        let line = lines_iter.next().unwrap().unwrap();
        if line.len() == 0 {
            break;
        }
        lines.push(line);
    }

    let mut state = vec![0u8; lines[0].len() * lines.len()];
    let mut grid: Vec<_> = state.chunks_mut(lines[0].len()).collect();
    for (i, l) in lines.iter().enumerate() {
        grid[i].copy_from_slice(l.as_bytes());
    }

    for ln in lines_iter {
        let line = ln.unwrap();
        let moves = line.as_bytes();
        do_moves(&mut grid, moves);
    }
    println!("{}", calc_boxes(&grid));
}
