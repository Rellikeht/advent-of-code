use std::io;
type Num = i64;

pub fn checksum(id: Num, pos: Num, size: Num) -> Num {
    return id * ((pos - 1) * size + (size * (size + 1)) / 2);
}

pub fn main() {
    let line = io::stdin().lines().next().unwrap().unwrap();
    let mut sectors: Vec<(Num, Num)> = Vec::with_capacity(line.len() + 1);
    let mut id = 0;
    let mut file = true;

    for c in line.bytes().into_iter() {
        if file {
            sectors.push((id, (c - b'0') as Num));
            id += 1;
        } else {
            sectors.push((Num::max_value(), (c - b'0') as Num));
        }
        file = !file;
    }

    let (mut sum, mut pos) = (0, 0);
    file = false;
    let mut j = sectors.len() - 1 - file as usize;
    let mut jleft = sectors[j].1;

    for (i, (id, size)) in sectors.iter().enumerate() {
        if i == j {
            sum += checksum(*id, pos, jleft);
            break;
        }
        if i > j {
            break;
        }
        file = !file;
        if file {
            sum += checksum(*id, pos, *size);
            pos += size;
            continue;
        }

        let mut size = *size as i64;
        while size > 0 {
            if jleft == 0 {
                j -= 2;
                jleft = sectors[j].1;
            }
            if i > j {
                break;
            }
            sum += sectors[j].0 * pos;
            pos += 1;
            size -= 1;
            jleft -= 1;
        }

        if i >= j && size > 0 {
            sum += checksum(sectors[j].0, pos, size);
            pos += size;
            jleft -= size;
        }
        if i >= j && jleft > 0 {
            sum += checksum(sectors[j].0, pos, jleft);
        }
    }

    println!("{}", sum);
}
