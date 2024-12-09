// let (mut sum, mut pos) = (0, 0);
// file = false;
// let mut j = sectors.len() - 1 - file as usize;
// let mut jleft = sectors[j].1;

// for (i, (id, size)) in sectors.iter().enumerate() {
//     if i > j {
//         break;
//     }

//     file = !file;
//     if file {
//         sum += checksum(*id, pos, *size);
//         pos += size;
//         continue;
//     }

//     let mut size = *size;
//     while size >= jleft && i < j {
//         sum += checksum(sectors[j].0, pos, jleft);
//         size -= jleft;
//         pos += jleft;
//         j -= 2;
//         jleft = sectors[j].1;
//     }

//     if i >= j {
//         break;
//     }
//     if size > 0 {
//         sum += checksum(sectors[j].0, pos, size);
//         jleft -= size;
//         pos += size;
//     }
// }
