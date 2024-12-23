use std::io;

type Count = u64;
type Num = i64;
type Robot = (Num, Num, Num, Num);

fn get_size(line: &String) -> (Num, Num) {
    let mut s = line.split(' ');
    let p1 = s.next().unwrap().parse::<Num>().unwrap();
    let p2 = s.next().unwrap().parse::<Num>().unwrap();
    return (p1, p2);
}

fn get2(str: &str) -> (Num, Num) {
    let mut s = str.split('=');
    let _ = s.next();
    let mut s = s.next().unwrap().split(',');
    let p1 = s.next().unwrap().parse::<Num>().unwrap();
    let p2 = s.next().unwrap().parse::<Num>().unwrap();
    return (p1, p2);
}

fn get_robot(line: &String) -> Robot {
    let mut s1 = line.split(' ');
    let pos = get2(s1.next().unwrap());
    let vel = get2(s1.next().unwrap());
    return (pos.0, pos.1, vel.0, vel.1);
}

fn get_position(robot: &Robot, size: &(Num, Num), steps: Num) -> (Num, Num) {
    let max = (steps * size.0, steps * size.1);
    let px = (robot.0 + robot.2 * steps + max.0) % size.0;
    let py = (robot.1 + robot.3 * steps + max.1) % size.1;
    return (px, py);
}

pub fn main() {
    let mut lines = io::stdin().lines();
    let l1 = lines.next().unwrap().unwrap();
    let size = get_size(&l1);
    let half = (size.0 / 2, size.1 / 2);

    let mut qmxpy = 0 as Count;
    let mut qpxpy = 0 as Count;
    let mut qpxmy = 0 as Count;
    let mut qmxmy = 0 as Count;

    for ln in lines {
        let line = ln.unwrap();
        let robot = get_robot(&line);
        let position = get_position(&robot, &size, 100);
        if position.0 == half.0 || position.1 == half.1 {
            continue;
        }

        if position.0 > half.0 {
            if position.1 > half.1 {
                qpxpy += 1;
            } else {
                qpxmy += 1;
            }
        } else {
            if position.1 > half.1 {
                qmxpy += 1;
            } else {
                qmxmy += 1;
            }
        }
    }

    println!("{}", qmxpy * qpxpy * qpxmy * qmxmy);
}
