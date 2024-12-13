pub fn gcd(a: Num, b: Num) -> Num {
    let (mut a, mut b) = (a, b);
    while b > 0 {
        (a, b) = (b, a % b);
    }
    return a;
}

pub fn lcm(a: Num, b: Num) -> Num {
    a * b / gcd(a, b)
}
