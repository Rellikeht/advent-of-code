use std::io;

type Num = i64;

pub fn calc_area(
    grid: &Vec<&mut [u8]>,
    i: usize,
    j: usize,
    visited: &mut Vec<Vec<bool>>, //
) -> (Num, Num) {
    let (mut perimeter, mut area) = (0, 0);

    fn helper(
        perimeter: &mut Num,
        area: &mut Num,
        grid: &Vec<&mut [u8]>,
        i: usize,
        j: usize,
        visited: &mut Vec<Vec<bool>>, //
    ) {
        if visited[i][j] {
            return;
        }
        *area += 1;
        visited[i][j] = true;

        if i >= grid.len() - 1 {
            *perimeter += 1;
        } else {
            if grid[i + 1][j] != grid[i][j] {
                *perimeter += 1;
            } else if !visited[i + 1][j] {
                helper(perimeter, area, grid, i + 1, j, visited);
            }
        }

        if i <= 0 {
            *perimeter += 1;
        } else {
            if grid[i - 1][j] != grid[i][j] {
                *perimeter += 1;
            } else if !visited[i - 1][j] {
                helper(perimeter, area, grid, i - 1, j, visited);
            }
        }

        if j >= grid[0].len() - 1 {
            *perimeter += 1;
        } else {
            if grid[i][j + 1] != grid[i][j] {
                *perimeter += 1;
            } else if !visited[i][j + 1] {
                helper(perimeter, area, grid, i, j + 1, visited);
            }
        }

        if j <= 0 {
            *perimeter += 1;
        } else {
            if grid[i][j - 1] != grid[i][j] {
                *perimeter += 1;
            } else if !visited[i][j - 1] {
                helper(perimeter, area, grid, i, j - 1, visited);
            }
        }

        //
    }

    helper(&mut area, &mut perimeter, grid, i, j, visited);
    return (perimeter, area);
}

pub fn main() {
    let lines: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();
    let mut state = vec![0u8; lines[0].len() * lines.len()];
    let mut grid: Vec<_> = state.chunks_mut(lines[0].len()).collect();
    for (i, l) in lines.iter().enumerate() {
        grid[i].copy_from_slice(l.as_bytes());
    }
    let mut sum = 0;
    let mut visited = vec![vec![false; lines[0].len()]; lines.len()];

    for i in 0..lines.len() {
        for j in 0..lines[i].len() {
            let (perimeter, area) = calc_area(&grid, i, j, &mut visited);
            sum += perimeter * area;
        }
    }
    println!("{}", sum);
}
