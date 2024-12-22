use core::panic;
use std::io;

type Num = i64;

pub fn solve(grid: &mut Vec<&mut [u8]>, start: (Num, Num)) -> Num {
    let (mut y, mut x) = start;
    let (mut dy, mut dx) = (-1 as Num, 0 as Num);
    let (ex, ey) = ((grid.len() - 1) as Num, (grid[0].len() - 1) as Num);
    let mut count = 1;

    loop {
        if (y == 0 && dy == -1)
            || (x == 0 && dx == -1)
            || (x == ex && dx == 1)
            || (y == ey && dy == 1)
        {
            break;
        }
        // println!("({} {}) ({} {})", x, y, dx, dy);

        let (px, py) = ((x + dx) as usize, (y + dy) as usize);
        if grid[py][px] == b'#' {
            (dy, dx) = (dx, -dy);
            continue;
        }

        if grid[py][px] == b'.' {
            count += 1;
            grid[py][px] = b'X';
        }

        x += dx;
        y += dy;
    }

    return count;
}

pub fn main() {
    let lines: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();
    let mut state = vec![0u8; lines[0].len() * lines.len()];
    let mut grid: Vec<_> = state.chunks_mut(lines[0].len()).collect();
    let mut start: (usize, usize) = (lines.len(), lines[0].len());

    for (i, l) in lines.iter().enumerate() {
        match l.find('^') {
            Some(n) => {
                start = (i, n);
            }
            None => {}
        }
        grid[i].copy_from_slice(l.as_bytes());
    }
    if start.0 >= lines.len() || start.1 >= lines[0].len() {
        panic!("KURWA");
    }

    // grid[start.0][start.1] = b'X';
    println!("{}", solve(&mut grid, (start.0 as Num, start.1 as Num)));
}
