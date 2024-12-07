use std::io;

type Num = u64;

pub fn parse(ln: String) -> (Num, Vec<Num>) {
    let mut it1 = ln.split(": ");
    let n1 = it1.next().unwrap().parse::<Num>().unwrap();
    let it2 = it1
        .next()
        .unwrap()
        .split(' ')
        .map(|e| e.parse::<Num>().unwrap());
    return (n1, it2.collect());
}

pub fn conc(a: Num, n: Num) -> Num {
    return Num::pow(10, n.ilog10() + 1) * a + n;
}

pub fn check((target, numbers): (Num, Vec<Num>)) -> Num {
    fn helper(n: &Vec<Num>, t: Num, i: usize, a: Num) -> bool {
        if i == n.len() {
            return a == t;
        }
        if a > t {
            return false;
        }
        return helper(n, t, i + 1, a + n[i])
            || helper(n, t, i + 1, a * n[i])
            || helper(n, t, i + 1, conc(a, n[i]));
    }

    if helper(&numbers, target, 1, numbers[0]) {
        return target;
    }
    return 0;
}

pub fn main() {
    println!(
        "{}",
        io::stdin()
            .lines()
            .map(|l| check(parse(l.unwrap())))
            .fold(0, |a, x| a + x)
    )
}
