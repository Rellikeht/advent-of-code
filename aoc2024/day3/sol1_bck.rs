use std::{i64, io};

pub fn find_muls(line: String) -> i64 {
    let mut i = 0;
    let mut sum = 0;
    let m = line.len() - 8;
    let debugl = &line[..].as_bytes();

    while i < m {
        if i < m {
            if line[i..i + 4] == *"mul(" {
                i += 4;
                // println!("{:?}", line[i..i + 4].to_string());

                let last;
                match line[i..].find(|c: char| !c.is_numeric()) {
                    Some(n) => last = n,
                    None => continue,
                }

                let n1;
                match line[i..last].parse::<i64>() {
                    Ok(n) => n1 = n,
                    Err(_) => continue,
                };
                println!("n1");

                i += i64::ilog(n1, 10) as usize;
                if line[i..i + 1] != *"," {
                    continue;
                }
                i += 1;

                let last;
                match line[i..].find(|c: char| !c.is_numeric()) {
                    Some(n) => last = n,
                    None => continue,
                }

                let n2;
                match line[i..last].parse::<i64>() {
                    Ok(n) => n2 = n,
                    Err(_) => continue,
                };

                i += i64::ilog(n2, 10) as usize;
                if line[i..i + 1] != *")" {
                    continue;
                }

                i += 1;
                sum += n1 * n2;
            } else {
                i += 1;
            }
        }
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
