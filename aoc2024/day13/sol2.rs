use std::io;

type Num = i64;

const A_COST: Num = 3;
const B_COST: Num = 1;
const CONV: Num = 10_000_000_000_000;

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
    let (mut x, mut y) = (0, 0);
    let mut cost = 0;

    loop {
        if x > target.0 || y > target.1 {
            break;
        }

        if (target.0 - x) % b.0 == 0 && (target.1 - y) % b.1 == 0 {
            let (bx, by) = ((target.0 - x) / b.0, (target.1 - y) / b.1);
            if bx == by {
                let cost = cost + bx * B_COST;
                min = match min {
                    None => Some(cost),
                    Some(n) => Some(Num::min(n, cost)),
                };
            }
        }

        x += a.0;
        y += a.1;
        cost += A_COST;
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
        sum += find(a, b, (target.0 + CONV, target.1 + CONV)).unwrap_or(0);
        let _ = lines.next();
    }

    println!("{}", sum);
}
