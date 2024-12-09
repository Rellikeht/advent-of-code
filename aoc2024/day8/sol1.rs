use std::collections::{HashMap, HashSet};
use std::io;

type Num = i64;

pub fn main() {
    let mut antennas = HashMap::<u8, HashSet<(Num, Num)>>::new();
    let mut antinodes = HashSet::<(Num, Num)>::new();
    let (mut x, mut max_y) = (0, 0);

    for ln in io::stdin().lines() {
        let line = ln.unwrap();
        max_y = line.len() as Num;
        let mut y = -1;
        for b in line.bytes() {
            y += 1;
            if b == b'.' {
                continue;
            }
            if !antennas.contains_key(&b) {
                antennas.insert(b, HashSet::new());
            }
            antennas.get_mut(&b).unwrap().insert((x, y));
        }
        x += 1;
    }

    for set in antennas.into_values() {
        for (x1, y1) in set.iter() {
            for (x2, y2) in set.iter() {
                if x1 == x2 && y1 == y2 {
                    continue;
                }
                let (dx, dy) = (x2 - x1, y2 - y1);
                let (ax, ay) = (x2 + dx, y2 + dy);
                if ax >= 0 && ax < x && ay >= 0 && ay < max_y {
                    antinodes.insert((ax, ay));
                }
            }
        }
    }

    println!("{}", antinodes.len());
}
