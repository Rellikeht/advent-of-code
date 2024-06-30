#!/usr/bin/env dash
#!/usr/bin/env sh

read ns
boards=0
DIR="$(mktemp -d)"
cd "$DIR"

while read ignored; do
    mkdir $boards
    cd $boards

    for i in $(seq 5); do
        mkdir "c$i"
    done

    for i in $(seq 5); do
        mkdir "r$i"

        read row
        row="$(echo $row | sed -E 's/^ *//;s/ +/\n/g')"
        j=1
        for f in $(echo $row); do
            touch "r$i/$f"
            touch "c$j/$f"
            j=$((j + 1))
        done
    done

    cd ..
    boards=$((boards + 1))
done

# for i in $(echo $ns | sed 's/,/\n/g'); do
#     echo $i
# done

# echo "$DIR"
rm -r "$DIR"
