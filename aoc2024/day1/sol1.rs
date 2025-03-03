use std::{i64, io};

pub fn main() {
    let mut right = Vec::<i64>::new();
    let mut left = Vec::<i64>::new();

    for opt_line in io::stdin().lines() {
        let line = opt_line.unwrap();
        let mut split = line.split_whitespace();
        let v1 = split.next().unwrap();
        let v2 = split.next().unwrap();
        left.push(v1.parse::<i64>().unwrap());
        right.push(v2.parse::<i64>().unwrap());
    }

    right.sort();
    left.sort();
    let mut sum = 0;
    for (i, _) in left.iter().enumerate() {
        sum += i64::abs(right[i] - left[i]);
    }
    println!("{}", sum);
}
