use std::io;
type Num = i64;

pub fn find_xs(grid: &Vec<&mut [u8]>, text: &[u8]) -> Num {
    let mut count = 0;
    for sy in 0..(grid.len() - text.len() + 1) {
        for sx in 0..(grid[0].len() - text.len() + 1) {
            let (mut pslash, mut mslash, mut pback, mut mback) = (true, true, true, true);
            let (mut x, mut y) = (0, 0);
            let last = text.len() - 1;
            count += 1;

            for i in 0..text.len() {
                if pback && grid[sy + y][sx + x] != text[i] {
                    pback = false;
                }
                if mback && grid[sy + last - y][sx + last - x] != text[i] {
                    mback = false;
                }
                if pslash && grid[sy + y][sx + last - x] != text[i] {
                    pslash = false;
                }
                if mslash && grid[sy + last - y][sx + x] != text[i] {
                    mslash = false;
                }

                if !((pslash || mslash) && (pback || mback)) {
                    count -= 1;
                    break;
                }
                x += 1;
                y += 1;
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

    println!("{}", find_xs(&grid, b"MAS"));
}
