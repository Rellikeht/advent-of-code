use std::collections::HashSet;
use std::io;

type Num = usize;

pub fn rule(line: String) -> (Num, Num) {
    let mut it = line.split('|').map(|e| e.parse().unwrap());
    let x = it.next().unwrap();
    let y = it.next().unwrap();
    return (x, y);
}

pub fn parse(line: String) -> Vec<Num> {
    return line.split(',').map(|e| e.parse().unwrap()).collect();
}

pub fn correct(line: Vec<Num>, rules: &Vec<HashSet<Num>>) -> Option<Num> {
    for i in (1..line.len()).rev() {
        let set = &rules[line[i]];
        for j in (0..i).rev() {
            if set.contains(&line[j]) {
                return None;
            }
        }
    }
    return Some(line[line.len() / 2]);
}

pub fn main() {
    let mut rules: Vec<HashSet<Num>> = vec![HashSet::new(); 100];
    let mut sum = 0;

    for ln in io::stdin().lines() {
        let line = ln.unwrap();
        if line == "" {
            break;
        }
        let (prev, next) = rule(line);
        rules[prev].insert(next);
    }

    for ln in io::stdin().lines() {
        let line = ln.unwrap();
        match correct(parse(line), &rules) {
            Some(n) => sum += n,
            _ => {}
        }
    }

    println!("{}", sum);
}
