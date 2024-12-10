use std::io;

type Num = i64;

pub fn score(grid: &Vec<&mut [u8]>, i: usize, j: usize) -> Num {
    let mut visited = vec![vec![false; grid[0].len()]; grid.len()];

    fn helper(
        grid: &Vec<&mut [u8]>,
        visited: &mut Vec<Vec<bool>>,
        i: usize,
        j: usize,
        prev: u8,
    ) -> Num {
        if visited[i][j] {
            return 0;
        }

        if grid[i][j] <= prev || grid[i][j] - prev > 1 {
            return 0;
        }
        visited[i][j] = true;
        if grid[i][j] == b'9' {
            return 1;
        }

        let mut sum = 0;
        if i > 0 {
            sum += helper(grid, visited, i - 1, j, grid[i][j]);
        }
        if i < grid.len() - 1 {
            sum += helper(grid, visited, i + 1, j, grid[i][j]);
        }
        if j > 0 {
            sum += helper(grid, visited, i, j - 1, grid[i][j]);
        }
        if j < grid[0].len() - 1 {
            sum += helper(grid, visited, i, j + 1, grid[i][j]);
        }

        return sum;
    }

    return helper(grid, &mut visited, i, j, b'0' - 1);
}

pub fn main() {
    let lines: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();
    let mut state = vec![0u8; lines[0].len() * lines.len()];
    let mut grid: Vec<_> = state.chunks_mut(lines[0].len()).collect();
    for (i, l) in lines.iter().enumerate() {
        grid[i].copy_from_slice(l.as_bytes());
    }
    drop(lines);

    let sum = grid
        .iter()
        .enumerate()
        .map(|(i, l)| {
            return l
                .iter()
                .enumerate()
                .map(|(j, c)| {
                    if *c == b'0' {
                        return score(&grid, i, j);
                    } else {
                        return 0;
                    }
                })
                .fold(0, |a, x| a + x);
        })
        .fold(0, |a, x| a + x);

    println!("{}", sum);
}
