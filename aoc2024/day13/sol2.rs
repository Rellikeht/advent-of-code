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
    // solving system
    let ma = a.1 * a.0 - a.0 * a.1;
    let mb = b.1 * a.0 - b.0 * a.1;
    let mt = target.1 * a.0 - target.0 * a.1;
    if mt % mb != 0 {
        return None;
    }

    let y = mt / mb;
    if (target.0 - b.0 * y) % a.0 != 0 {
        return None;
    }

    let x = (target.0 - b.0 * y) / a.0;
    return Some(x * A_COST + y * B_COST);
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
