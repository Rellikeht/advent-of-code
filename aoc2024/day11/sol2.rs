use std::collections::HashMap;
use std::{env, io};
type Num = u64;

pub fn amount(n: Num, steps: Num, state: &mut HashMap<(Num, Num), Num>) -> Num {
    fn helper(n: Num, steps: Num, state: &mut HashMap<(Num, Num), Num>) -> Num {
        if steps <= 0 {
            return 1;
        }
        match state.get(&(n, steps)) {
            Some(n) => return *n,
            None => {}
        }

        if n == 0 {
            let hv = helper(1, steps - 1, state);
            state.insert((0, steps), hv);
            return hv;
        }

        let l = n.ilog10() + 1;
        if l % 2 == 0 {
            let d = (10 as Num).pow(l / 2);
            let (n1, n2) = (n / d, n % d);
            let hv = helper(n1, steps - 1, state) + helper(n2, steps - 1, state);
            state.insert((n, steps), hv);
            return hv;
        }

        let hv = helper(n * 2024, steps - 1, state);
        state.insert((n, steps), hv);
        return hv;
    }

    return helper(n, steps, state);
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

    let cap = numbers.len() * steps as usize * steps as usize;
    let mut state = HashMap::with_capacity(cap);

    println!(
        "{}",
        numbers
            .iter()
            .map(|n| amount(*n, steps, &mut state))
            .fold(0, |a, x| a + x)
    );
}
