#!/bin/bash

print_res () {
    local wire="$1"
    (( ++solved ))
    echo "$wire -> ${wires[$wire]} ($solved/$num_tot)"
}

get_output () {
    [[ "${wires[$wire]}" ]] && return 0   # We already have the result

    local in1="$1"
    local op="$2"
    local in2="$3"
    local wire="$4"

    # If one of the operands is numeric, leave as is, else try to get
    # value from hash and return if it is not there
    local re_num='[[:digit:]]+'
    if [[ ! "$in1" =~ $re_num ]]; then
        if [[ "${wires[$in1]}" ]]; then
            in1="${wires[$in1]}"
        else
            return 0
        fi
    fi
    if [[ ! "$in2" =~ $re_num ]]; then
        if [[ "${wires[$in2]}" ]]; then
            in2="${wires[$in2]}"
        else
            return 0
        fi
    fi

    case "$op" in
        LSHIFT) wires[$wire]=$(( in1 << in2 )) ;;
        RSHIFT) wires[$wire]=$(( in1 >> in2 )) ;;
        AND)    wires[$wire]=$(( in1 & in2 ))  ;;
        OR)     wires[$wire]=$(( in1 | in2 ))  ;;
        *)      echo "Illegal operation $op" && exit 1 ;;
    esac

    print_res "$wire"
}

declare -A wires
wires[b]=16076  # Answer from part 1
num_tot=$(wc -l < input)
solved=1

re1='^([[:digit:]]+) -> ([[:lower:]]+)$'
re2='^([[:lower:]]+) -> ([[:lower:]]+)$'
re3='^NOT ([[:lower:]]+) -> ([[:lower:]]+)$'
re4='^([[:alnum:]]+) ([[:upper:]]+) ([[:alnum:]]+) -> ([[:lower:]]+)$'

# Loop through assignments
while (( solved < num_tot )); do
    while read line; do
        if [[ "$line" =~ $re1 ]]; then
            input="${BASH_REMATCH[1]}"
            wire="${BASH_REMATCH[2]}"
            [[ "${wires[$wire]}" ]] || { wires[$wire]="$input" && print_res "$wire"; }
        elif [[ "$line" =~ $re2 ]]; then
            input="${BASH_REMATCH[1]}"
            wire="${BASH_REMATCH[2]}"
            if [[ "${wires[$input]}" ]] && [[ -z "${wires[$wire]}" ]]; then
                wires[$wire]="${wires[$input]}"
                print_res "$wire"
            fi
        elif [[ "$line" =~ $re3 ]]; then
            input="${BASH_REMATCH[1]}"
            wire="${BASH_REMATCH[2]}"
            if [[ "${wires[$input]}" ]] && [[ -z "${wires[$wire]}" ]]; then
                wires[$wire]=$(( ~${wires[$input]} ))
                print_res "$wire"
            fi
        elif [[ "$line" =~ $re4 ]]; then
            input1="${BASH_REMATCH[1]}"
            op="${BASH_REMATCH[2]}"
            input2="${BASH_REMATCH[3]}"
            wire="${BASH_REMATCH[4]}"
            get_output "$input1" "$op" "$input2" "$wire"
        else
            echo "Illegal assignment: $line"
            exit 1
        fi
    done < input
done
