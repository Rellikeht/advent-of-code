use std::fs::File;
use std::io::BufRead;
use std::{env, io};

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let fname: &str;
    if args.len() > 1 {
        fname = &args[1];
    } else {
        fname = "input";
    }
    let file = File::open(fname).unwrap();
    let mut lines = io::BufReader::new(file).lines();

    for ln in lines {
        //
    }

    println!("{}", 0);
}
