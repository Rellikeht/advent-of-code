use std::io;

pub fn check_without(index: i64, row: &Vec<i64>) -> bool {
    let mut prev: i64 = if index == 0 { row[1] } else { row[0] };
    let mut next: i64 = if index <= 1 { row[2] } else { row[1] };
    let mut diff = prev - next;
    if i64::abs(diff) == 0 || i64::abs(diff) > 3 {
        return false;
    }

    let mut passed = true;
    let start = if index <= 2 { 3 } else { 2 };

    for i in start..row.len() {
        if index as usize == i {
            continue;
        }
        let third = row[i];
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

    return passed;
}

pub fn main() {
    let mut safe = 0;

    for ln in io::stdin().lines() {
        let row: Vec<i64> = ln
            .unwrap()
            .split(' ')
            .map(|c| c.parse::<i64>().unwrap())
            .collect();

        let end = row.len() as i64;
        for i in -1..end {
            if check_without(i, &row) {
                safe += 1;
                break;
            }
        }
    }

    println!("{}", safe);
}
