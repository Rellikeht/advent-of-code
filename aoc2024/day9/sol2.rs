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
    let mut file_pos = 0;

    for c in line.bytes().into_iter() {
        let size = (c - b'0') as Num;
        if file {
            sectors.push((id, size));
            id += 1;
        } else {
            sectors.push((Num::max_value(), size));
        }
        file_pos += size;
        file = !file;
    }

    let mut sum = 0;
    let files_end = sectors.len() - file as usize;
    if file {
        file_pos -= sectors[sectors.len() - 1].1;
    }
    let mut pos_mod = vec![0; sectors.len()];

    for i in (2..files_end).step_by(2).rev() {
        let mut moved = false;
        let (id, file_size) = sectors[i];
        let mut pos = 0;
        file_pos -= file_size;

        for j in (1..i).step_by(2) {
            let sector_len = sectors[j].1 - pos_mod[j];
            pos += sectors[j - 1].1 + pos_mod[j];
            if sector_len >= file_size {
                pos_mod[j] += file_size;
                sum += checksum(id, pos, file_size);
                moved = true;
                break;
            }
            pos += sector_len;
        }

        if !moved {
            sum += checksum(id, file_pos, file_size);
        }
        file_pos -= sectors[i - 1].1;
    }

    println!("{}", sum);
}
