let calculate bottom top =
    let rec c b t a =
        if b > t then a
        else c b (t-1) (a+t*t mod 2)
    in c bottom top 0
;;

