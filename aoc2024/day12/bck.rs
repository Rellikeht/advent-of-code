use std::collections::HashMap;
use std::io;

type Num = i64;

pub fn main() {
    let lines: Vec<Vec<u8>> = io::stdin()
        .lines()
        .map(|l| l.unwrap().bytes().collect())
        .collect();
    let mut sizes = HashMap::<u8, (Num, Num)>::with_capacity(lines.len());
    sizes.insert(lines[0][0], (4, 1));

    // iter over first row
    for i in 1..lines[0].len() {
        let ch = lines[0][i];
        match sizes.get_mut(&ch) {
            None => {
                let _ = sizes.insert(ch, (4, 1));
            }
            Some(t) => {
                if ch == lines[0][i - 1] {
                    t.0 += 2;
                } else {
                    t.0 += 4;
                }
                t.1 += 1;
            }
        }
    }

    // iter over grid
    for i in 1..lines.len() {
        let ch = lines[i][0];
        match sizes.get_mut(&ch) {
            None => {
                let _ = sizes.insert(ch, (4, 1));
            }
            Some(t) => {
                if ch == lines[i - 1][0] {
                    t.0 += 2;
                } else {
                    t.0 += 4;
                }
                t.1 += 1;
            }
        }

        for j in 1..lines[i].len() {
            let ch = lines[i][j];
            match sizes.get_mut(&ch) {
                None => {
                    let _ = sizes.insert(ch, (4, 1));
                }
                Some(t) => {
                    let c1 = (ch == lines[i - 1][j]) as Num;
                    let c2 = (ch == lines[i][j - 1]) as Num;
                    match c1 + c2 {
                        0 => {
                            t.0 += 4;
                        }
                        1 => {
                            t.0 += 2;
                        }
                        2 => {}
                        _ => panic!("FUCK"),
                    }
                    t.1 += 1;
                }
            }
        }
    }

    for (ch, (p, a)) in sizes.iter() {
        println!("{} {} {}", *ch as char, p, a);
    }

    println!(
        "{}",
        sizes
            .into_values()
            .fold(0, |acc, (perimeter, area)| acc + perimeter * area)
    );
}
