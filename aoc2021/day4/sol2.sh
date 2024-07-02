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

    # amount of boards
    b=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)

    if [ "$b" -gt 1 ]; then
        # remove winning boards
        find . -type d -empty |
            while read -r d; do
                d="${d%/*}"
                echo "${d#./}"
            done |       # get directory name
            sort |       # for uniq
            uniq |       # remove duplicates
            xargs rm -rf # remove directories

    else
        # break if last one wins
        find . -type d -empty |
            grep -E '.*' >/dev/null && break
    fi
done

find . -type d | # getting board with bingo (should be only one)
    while read -r d; do
        d="${d%/*}"
        echo "${d#./}"
    done |   # getting directory name
    sed 1q | # counting dir only one time
    xargs -I{} \
        find {} -type f \
        -wholename '*r*' \
        -printf '%f + ' | # adding numbers
    sed 'i0 ' |           # for expression to be correct
    sed "\$a$i * p\0" |   # multiplying by last guessed number
    xargs -d'\0' dc -e    # calculating score

# finally
rm -r "$DIR"
