let result op = match op with
    | "A X" -> (1+3)
    | "B X" -> (1+0)
    | "C X" -> (1+6)
    | "A Y" -> (2+6)
    | "B Y" -> (2+3)
    | "C Y" -> (2+0)
    | "A Z" -> (3+0)
    | "B Z" -> (3+6)
    | "C Z" -> (3+3)
    | _ -> 0
;;

let rec count_result cur_count =
    try count_result (cur_count + result (read_line ()))
    with End_of_file -> cur_count
;;

print_string ((string_of_int (count_result 0))^"\n");
