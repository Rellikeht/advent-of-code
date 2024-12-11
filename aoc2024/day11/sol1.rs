use std::{env, io};
type Num = u64;

pub fn amount(n: Num, steps: Num) -> Num {
    let mut acc = 1;

    fn helper(n: Num, steps: Num, acc: &mut Num) {
        if steps <= 0 {
            return;
        }
        if n == 0 {
            helper(1, steps - 1, acc);
            return;
        }

        let l = n.ilog10() + 1;
        if l % 2 == 0 {
            let d = (10 as Num).pow(l / 2);
            let (n1, n2) = (n / d, n % d);
            helper(n1, steps - 1, acc);
            *acc += 1;
            helper(n2, steps - 1, acc);
            return;
        }

        helper(n * 2024, steps - 1, acc);
    }

    helper(n, steps, &mut acc);
    return acc;
}

pub fn main() {
    let args: Vec<String> = env::args().collect();
    let steps: Num;
    if args.len() > 1 {
        steps = args[1].parse().unwrap();
    } else {
        steps = 25;
    }

    let numbers: Vec<Num> = io::stdin()
        .lines()
        .next()
        .unwrap()
        .unwrap()
        .split(' ')
        .map(|s| s.parse::<Num>().unwrap())
        .collect();

    println!(
        "{}",
        numbers
            .iter()
            .map(|n| amount(*n, steps))
            .fold(0, |a, x| a + x)
    );
}
