#!/bin/bash

# Initialize grid
grid=()
for i in {0..999}; do
    grid[i]=$(printf "%1000s" | tr ' ' o)
    (( i % 100 == 0 )) && echo "Initialized $i lines..."
done

re='(.*) ([[:digit:]]+),([[:digit:]]+) through ([[:digit:]]+),([[:digit:]]+)'

idx=0
while read line; do
    [[ "$line" =~ $re ]]
    action="${BASH_REMATCH[1]}"
    x1="${BASH_REMATCH[2]}"
    y1="${BASH_REMATCH[3]}"
    x2="${BASH_REMATCH[4]}"
    y2="${BASH_REMATCH[5]}"
    for (( y = y1; y <= y2; ++y )); do
        for (( x = x1; x <= x2; ++x )); do
            case "$action" in
                'turn on') light='x' ;;
                'turn off') light='o' ;;
                'toggle') [[ ${grid[y]:x:1} == o ]] && light='x' || light='o' ;;
            esac
            grid[y]="${grid[y]:0:$x}$light${grid[y]:((x+1))}"
        done
    done
    (( ++idx ))
    (( idx % 50 == 0 )) && echo "Processed $idx instructions..."
done < input

l_count=0
for row in "${grid[@]}"; do
    row="${row//o}"
    (( l_count += ${#row} ))
done

echo "We have $l_count lights turned on."
