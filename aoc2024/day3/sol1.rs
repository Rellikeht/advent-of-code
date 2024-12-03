extern crate regex;
use core::str;
use regex::bytes::Regex;
use std::{i64, io};

pub fn find_muls(line: String) -> i64 {
    let mut sum = 0;
    let re = Regex::new(r"mul\(([0-9]+),([0-9]+)\)").unwrap();
    for (_, [n1b, n2b]) in re.captures_iter(line.as_bytes()).map(|c| c.extract()) {
        let n1s = str::from_utf8(n1b).unwrap();
        let n1 = n1s.parse::<i64>().unwrap();
        let n2s = str::from_utf8(n2b).unwrap();
        let n2 = n2s.parse::<i64>().unwrap();
        sum += n1 * n2;
    }
    return sum;
}

pub fn main() {
    println!(
        "{}",
        io::stdin()
            .lines()
            .map(|l| find_muls(l.unwrap()))
            .fold(0, |a, x| a + x)
    );
}
