extern crate regex;
use core::str;
use regex::bytes::Regex;
use std::{i64, io};

pub fn find_muls(line: String, en: bool) -> (i64, bool) {
    let mut sum = 0;
    let do_re = Regex::new(r"(do(?:n't)?)\(\)").unwrap();
    let mul_re = Regex::new(r"mul\(([0-9]+),([0-9]+)\)").unwrap();
    let do_finds: Vec<regex::bytes::Match<'_>>;
    do_finds = do_re.find_iter(line.as_bytes()).collect();
    let mul_captures = mul_re.captures_iter(line.as_bytes());
    let mut enabled = en;

    for c in mul_captures {
        let start = c.get(0).unwrap().start();
        for f in do_finds.iter() {
            if f.end() <= start {
                if f.as_bytes() == "do()".as_bytes() {
                    enabled = true;
                } else {
                    enabled = false;
                }
            }
        }

        if enabled {
            let (_, [n1b, n2b]) = c.extract();
            let n1s = str::from_utf8(n1b).unwrap();
            let n1 = n1s.parse::<i64>().unwrap();
            let n2s = str::from_utf8(n2b).unwrap();
            let n2 = n2s.parse::<i64>().unwrap();
            sum += n1 * n2;
        }
    }

    if do_finds.len() > 0 {
        let last = do_finds[do_finds.len() - 1];
        if last.as_bytes() == "do()".as_bytes() {
            enabled = true;
        } else {
            enabled = false;
        }
    }
    return (sum, enabled);
}

pub fn main() {
    let mut sum = 0;
    let mut enabled = true;
    for l in io::stdin().lines() {
        let (res, en) = find_muls(l.unwrap(), enabled);
        enabled = en;
        sum += res;
    }

    println!("{}", sum);
}
