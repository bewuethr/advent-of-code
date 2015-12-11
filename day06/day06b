#!/bin/bash

re='(.*) ([[:digit:]]+),([[:digit:]]+) through ([[:digit:]]+),([[:digit:]]+)'

declare -A grid

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
                'turn on') (( ++grid[$x,$y] )) ;;
                'turn off')
                    val="${grid[$x,$y]}"
                    if (( val > 0 )); then
                        (( --grid[$x,$y] ))
                    fi
                    ;;
                'toggle') (( grid[$x,$y] += 2 )) ;;
            esac
        done
    done
    (( ++idx ))
    (( idx % 50 == 0 && idx > 0 )) && echo "Processed $idx instructions..."
done < input

brightness=0
for light in "${grid[@]}"; do
    (( brightness += $light ))
done

echo "The total brightness is $brightness."
