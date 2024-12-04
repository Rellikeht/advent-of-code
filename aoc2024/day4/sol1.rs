use std::io;

type Num = i64;

const DIRECTIONS: [(Num, Num); 8] = [
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
    (1, 1),
    (1, -1),
    (-1, 1),
    (-1, -1),
];

pub fn find(grid: &Vec<&mut [u8]>, text: &[u8], dx: Num, dy: Num) -> Num {
    let (start_x, end_x, start_y, end_y): (Num, Num, Num, Num);

    if dx < 0 {
        start_x = (text.len() - 1) as Num;
        end_x = grid[0].len() as Num;
    } else if dx > 0 {
        start_x = 0;
        end_x = (grid[0].len() - text.len() + 1) as Num;
    } else {
        start_x = 0;
        end_x = grid[0].len() as Num;
    }

    if dy < 0 {
        start_y = (text.len() - 1) as Num;
        end_y = grid.len() as Num;
    } else if dy > 0 {
        start_y = 0;
        end_y = (grid.len() - text.len() + 1) as Num;
    } else {
        start_y = 0;
        end_y = grid.len() as Num;
    }

    let mut count = 0;
    for sy in start_y..end_y {
        for sx in start_x..end_x {
            let (mut x, mut y) = (sx, sy);
            count += 1;

            for i in 0..text.len() {
                if grid[y as usize][x as usize] != text[i] {
                    count -= 1;
                    break;
                }
                x += dx;
                y += dy;
            }
        }
    }

    return count;
}

pub fn main() {
    let lines: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();
    let mut state = vec![0u8; lines[0].len() * lines.len()];
    let mut grid: Vec<_> = state.chunks_mut(lines[0].len()).collect();
    for (i, l) in lines.iter().enumerate() {
        grid[i].copy_from_slice(l.as_bytes());
    }

    let mut count = 0;
    for (dx, dy) in DIRECTIONS {
        count += find(&grid, b"XMAS", dx, dy);
    }
    println!("{}", count);
}
