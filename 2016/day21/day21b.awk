function swap(word, p1, p2,    t) {
    if (p1 > p2) {
        t = p1
        p1 = p2
        p2 = t
    }
    word = substr(word, 1, p1-1) substr(word, p2, 1) substr(word, p1+1, p2-p1-1) substr(word, p1, 1) substr(word, p2+1)
    return word
}

BEGIN {
    pass = "fbgdceah"
    mv[0] = 1
    mv[1] = 1
    mv[2] = 6
    mv[3] = 2
    mv[4] = 7
    mv[5] = 3
    mv[6] = 8
    mv[7] = 4
}

/swap position/ {
    p1 = $3 + 1
    p2 = $6 + 1
    pass = swap(pass, p1, p2)
}

/swap letter/ {
    p1 = index(pass, $3)
    p2 = index(pass, $6)
    pass = swap(pass, p1, p2)
}

/rotate right/ { pass = substr(pass, 1+$3) substr(pass, 1, $3) }

/rotate left/ { pass = substr(pass, length(pass)-$3+1) substr(pass, 1, length(pass)-$3) }

/rotate based/ {
    p1 = index(pass, $NF) - 1
    shift = mv[p1]
    pass = pass = substr(pass, 1+shift) substr(pass, 1, shift) 
}

/reverse/ {
    p1 = $3 + 1
    p2 = $5 + 1
    new_pass = substr(pass, 1, p1-1)
    for (i = p2; i >= p1; --i)
        new_pass = new_pass substr(pass, i, 1)
    pass = new_pass substr(pass, p2+1)
}

/move/ {
    p2 = $3 + 1
    p1 = $6 + 1
    letter = substr(pass, p1, 1)
    new_pass = substr(pass, 1, p1-1) substr(pass, p1+1)
    pass = substr(new_pass, 1, p2-1) letter substr(new_pass, p2)
}

{ print $0, pass }

END { print pass }
