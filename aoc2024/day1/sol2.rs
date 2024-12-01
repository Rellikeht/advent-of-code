use std::io;

pub fn main() {
    let mut left = Vec::<u64>::new();
    let mut right: [u64; 100000] = [0; 100000];

    for opt_line in io::stdin().lines() {
        let line = opt_line.unwrap();
        let mut split = line.split_whitespace();
        let v1 = split.next().unwrap().parse::<u64>().unwrap();
        let v2 = split.next().unwrap().parse::<usize>().unwrap();
        left.push(v1);
        right[v2] += 1;
    }

    let mut sum = 0;
    for e in left {
        sum += e * right[e as usize];
    }
    println!("{}", sum);
}
