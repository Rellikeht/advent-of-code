let result op = match op with
    | "A X" -> (0+3)
    | "B X" -> (0+1)
    | "C X" -> (0+2)
    | "A Y" -> (3+1)
    | "B Y" -> (3+2)
    | "C Y" -> (3+3)
    | "A Z" -> (6+2)
    | "B Z" -> (6+3)
    | "C Z" -> (6+1)
    | _ -> 0
;;

let rec count_result cur_count =
    try count_result (cur_count + result (read_line ()))
    with End_of_file -> cur_count
;;

print_string ((string_of_int (count_result 0))^"\n");
