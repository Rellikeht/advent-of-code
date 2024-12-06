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

pub fn middle(line: &mut Vec<Num>, rules: &Vec<HashSet<Num>>) -> Option<Num> {
    let mut correct = true;
    for i in (1..line.len()).rev() {
        loop {
            let set = &rules[line[i]];
            let mut fixed = true;
            for j in (0..i).rev() {
                if set.contains(&line[j]) {
                    correct = false;
                    fixed = false;
                    line.swap(i, j);
                    break;
                }
            }
            if fixed {
                break;
            }
        }
    }

    if correct {
        return None;
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
        match middle(&mut parse(line), &rules) {
            Some(n) => sum += n,
            _ => {}
        }
    }

    println!("{}", sum);
}
