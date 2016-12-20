BEGIN {
    FS = "-"
    min = 0
}

$1 <= min && $2 >= min { min = $2 + 1 }

END { print min }
