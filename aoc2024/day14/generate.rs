use std::fs::File;
use std::io::BufRead;
use std::{env, io};

type Num = i64;
type Robot = (Num, Num, Num, Num);

fn get_size(line: &String) -> (usize, usize) {
    let mut s = line.split(' ');
    let p1 = s.next().unwrap().parse::<usize>().unwrap();
    let p2 = s.next().unwrap().parse::<usize>().unwrap();
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

fn next_frame(robots: &mut Vec<Robot>, size: &(usize, usize)) {
    for robot in robots.iter_mut() {
        robot.0 = (robot.0 + robot.2 + size.0 as Num) % size.0 as Num;
        robot.1 = (robot.1 + robot.3 + size.1 as Num) % size.1 as Num;
    }
}

fn print_robots(robots: &Vec<Robot>) {
    let mut it = robots.iter();
    let robot = it.next().unwrap();
    print!("{},{}", robot.0, robot.1);
    for robot in it {
        print!(" {},{}", robot.0, robot.1);
    }

    // let mut it = robots.iter();
    // let robot = it.next().unwrap();
    // print!("{}", robot.0);
    // for robot in it {
    //     print!(" {}", robot.0);
    // }
    // let mut it = robots.iter();
    // let robot = it.next().unwrap();
    // print!(":{}", robot.1);
    // for robot in it {
    //     print!(" {}", robot.1);
    // }

    //
}

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let fname: &str;
    let steps: Num;

    if args.len() > 1 {
        fname = &args[1];
    } else {
        fname = "tinput";
    }
    if args.len() > 2 {
        steps = args[2].parse().unwrap();
    } else {
        steps = 10_000;
    }
    let file = File::open(fname).unwrap();

    let mut lines = io::BufReader::new(file).lines();
    let l1 = lines.next().unwrap().unwrap();
    let size = get_size(&l1);
    let mut robots: Vec<_> = lines.map(|ln| get_robot(&ln.unwrap())).collect();

    // for step in 0..(steps + 1) {
    for _ in 0..(steps + 1) {
        // print!("{}:", step);
        // let mut line = String::new();
        // io::stdin().read_line(&mut line).unwrap();
        print_robots(&robots);
        println!("");
        next_frame(&mut robots, &size);
    }
}
