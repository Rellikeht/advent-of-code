#!/usr/bin/env sh
#!/usr/bin/env dash

# numbers to guess
read -r ns

# board number
board=0

# directory for commiting this crime
DIR="$(mktemp -d)"
cd "$DIR"

while read -r _; do
    mkdir $board

    # go to current board
    cd $board

    # dirs for columns
    for i in $(seq 5); do
        mkdir "c$i"
    done

    # for each row
    for i in $(seq 5); do
        mkdir "r$i"

        # get numbers in a row
        read -r row

        # change format to loop friendly
        row="$(echo "$row" | sed -E 's/^ *//;s/ +/\n/g')"

        # because seq starts with 1
        j=1

        for f in $row; do

            # create file for each number
            touch "r$i/$f"
            touch "c$j/$f"

            j=$((j + 1))
        done
    done

    cd ..
    board=$((board + 1))
done

# for all numbers to guess
for i in $(echo "$ns" | sed 's/,/\n/g'); do

    # remove number from all boards
    find . -type f -a -name "$i" -exec rm {} \;

    # check if there is board with all numbers marked
    find . -type d -empty | grep -E '.*' >/dev/null && break
done

find . -type d -empty | # getting all boards with bingo
    while read -r d; do
        d="${d%/*}"
        echo "${d#./}"
    done |    # getting directory names
    sort -r | # highest number
    sed 1q |  # only one
    xargs -I{} \
        find {} -type f \
        -wholename '*r*' \
        -printf '%f + ' | # adding numbers
    sed 'i0 ' |           # for expression to be correct
    sed "\$a$i * p\0" |   # multiplying by last guessed number
    xargs -d'\0' dc -e    # calculating score

# finally
rm -r "$DIR"
