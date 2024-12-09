//     let mut it1 = set.iter();
//     while let Some((x1, y1)) = it1.next() {
//         let it2 = it1.clone();
//         // print!("({}, {}): ", x1, y1);

//         for (x2, y2) in it2 {
//             // print!("({}, {}) ", x2, y2);
//             let (dx, dy) = ((x2 - x1).abs(), (y2 - y1).abs());
//             let (ax1, ay1, ax2, ay2);

//             if x1 > y2 {
//                 (ax1, ax2) = (x1 + dx, x2 - dx);
//             } else {
//                 (ax1, ax2) = (x1 - dx, x2 + dx);
//             }
//             if y1 > y2 {
//                 (ay1, ay2) = (y1 + dy, y2 - dy);
//             } else {
//                 (ay1, ay2) = (y1 - dy, y2 + dy);
//             }

//             if ax1 >= 0 && ax1 < x && ay1 >= 0 && ay1 < max_y {
//                 // println!("({} {})", ax1, ay1);
//                 antinodes.insert((ax1, ay1));
//             }
//             if ax2 >= 0 && ax2 < x && ay2 >= 0 && ay2 < max_y {
//                 // println!("({} {})", ax2, ay2);
//                 antinodes.insert((ax2, ay2));
//             }
//         }

//         //
//         // println!("");
//     }
