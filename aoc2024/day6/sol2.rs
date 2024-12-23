use core::panic;
use std::collections::HashSet;
use std::io;

type Num = i64;

pub fn dnum(dy: Num, dx: Num) -> Num {
    return match (dy, dx) {
        (-1, 0) => 0,
        (0, 1) => 1,
        (1, 0) => 2,
        (0, -1) => 3,
        _ => panic!("DUPA"),
    };
}

pub fn is_loop(
    grid: &Vec<&mut [u8]>,
    start: (Num, Num),
    diff: (Num, Num), //
) -> bool {
    let (mut y, mut x) = start;
    let (mut dy, mut dx) = diff;
    let (ey, ex) = ((grid.len() - 1) as Num, (grid[0].len() - 1) as Num);
    let vsize = (ex * ey) as usize;
    let mut visited: HashSet<(Num, Num, Num)> = HashSet::with_capacity(vsize);

    loop {
        if (y == 0 && dy == -1)
            || (x == 0 && dx == -1)
            || (x == ex && dx == 1)
            || (y == ey && dy == 1)
        {
            return false;
        }

        if visited.contains(&(y, x, dnum(dy, dx))) {
            return true;
        }
        visited.insert((y, x, dnum(dy, dx)));

        (y, x) = (y + dy, x + dx);
        let (py, px) = (y as usize, x as usize);
        if grid[py][px] == b'#' {
            (y, x) = (y - dy, x - dx);
            (dy, dx) = (dx, -dy);
            continue;
        }
    }
}

pub fn solve(grid: &mut Vec<&mut [u8]>, start: (Num, Num)) -> Num {
    let (mut y, mut x) = start;
    let (mut dy, mut dx) = (-1 as Num, 0 as Num);
    let (ey, ex) = ((grid.len() - 1) as Num, (grid[0].len() - 1) as Num);
    let mut count = 0;
    let mut obstacles: HashSet<(Num, Num)> = HashSet::new();

    loop {
        if (y == 0 && dy == -1)
            || (x == 0 && dx == -1)
            || (x == ex && dx == 1)
            || (y == ey && dy == 1)
        {
            break;
        }

        let (py, px) = ((y + dy) as usize, (x + dx) as usize);
        if grid[py][px] == b'#' {
            (dy, dx) = (dx, -dy);
            continue;
        }

        if grid[py][px] != b'^' && !obstacles.contains(&(py as Num, px as Num)) {
            obstacles.insert((py as Num, px as Num));
            let prev = grid[py][px];
            grid[py][px] = b'#';
            if is_loop(grid, (y, x), (dy, dx)) {
                count += 1;
            }
            grid[py][px] = prev;
        }

        (y, x) = (py as Num, px as Num);
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

    println!("{}", solve(&mut grid, (start.0 as Num, start.1 as Num)));
}
