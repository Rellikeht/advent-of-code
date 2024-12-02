use std::io;

pub fn main() {
    let mut safe = 0;

    for ln in io::stdin().lines() {
        let line = ln.unwrap();
        let mut it = line.split(' ');
        let mut prev: i64 = it.next().unwrap().parse().unwrap();
        let mut next: i64 = it.next().unwrap().parse().unwrap();
        let mut diff = prev - next;
        if i64::abs(diff) == 0 || i64::abs(diff) > 3 {
            continue;
        }

        let mut passed = true;
        for chunk in it {
            let third: i64 = chunk.parse().unwrap();
            // all increasing or decreasing
            if (diff < 0 && next - third > 0) || (diff > 0 && next - third < 0) {
                passed = false;
                break;
            }
            prev = next;
            next = third;
            diff = prev - next;
            // difference between 1 and 3
            if i64::abs(diff) == 0 || i64::abs(diff) > 3 {
                passed = false;
                break;
            }
        }

        if passed {
            safe += 1;
        }
    }

    println!("{}", safe);
}
