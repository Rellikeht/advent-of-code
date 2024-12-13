use std::io;

type Num = i64;

const A_COST: Num = 3;
const B_COST: Num = 1;
const MAX_MOVES: usize = 100;

pub fn get_info(line: String) -> (Num, Num) {
    let mut sp = line.split(": ");
    let _ = sp.next();

    let content = sp.next().unwrap();
    let mut sp = content.split(", ");
    let f1 = sp.next().unwrap();
    let f2 = sp.next().unwrap();

    let x: Num = f1[2..].parse().unwrap();
    let y: Num = f2[2..].parse().unwrap();
    return (x, y);
}

pub fn find(a: (Num, Num), b: (Num, Num), target: (Num, Num)) -> Option<Num> {
    let mut min: Option<Num> = None;

    for i in 0..=MAX_MOVES {
        let (mut x, mut y) = (i as Num * a.0, i as Num * a.1);
        let mut cost = i as Num * A_COST;
        if x > target.0 || y > target.1 {
            break;
        }

        for _ in 0..=MAX_MOVES {
            if x == target.0 && y == target.1 {
                min = match min {
                    None => Some(cost),
                    Some(n) => Some(Num::min(n, cost)),
                };
                break;
            }
            if x > target.0 || y > target.1 {
                break;
            }

            cost += B_COST;
            (x, y) = (x + b.0, y + b.1);
        }
    }

    return min;
}

pub fn main() {
    let mut sum = 0;
    let mut lines = io::stdin().lines();

    loop {
        let ln = lines.next();
        let line;
        match ln {
            None => break,
            Some(_) => {
                line = ln.unwrap().unwrap();
            }
        }

        let a = get_info(line);
        let b = get_info(lines.next().unwrap().unwrap());
        let target = get_info(lines.next().unwrap().unwrap());
        sum += find(a, b, target).unwrap_or(0);
        let _ = lines.next();
    }

    println!("{}", sum);
}
