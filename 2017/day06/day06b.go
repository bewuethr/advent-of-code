package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
)

func maxIdx(s []int) int {
	idx, max := 0, s[0]
	for i, v := range s {
		if v > max {
			idx, max = i, v
		}
	}
	return idx
}

func joinIntSlice(s []int, delim string) string {
	strSlice := make([]string, len(s))
	for i, v := range s {
		strSlice[i] = strconv.Itoa(v)
	}
	return strings.Join(strSlice, delim)
}

func redistribute(banks []int, maxIdx int) {
	blocks := banks[maxIdx]
	idx := maxIdx
	banks[idx] = 0
	for i := 0; i < blocks; i++ {
		idx = (idx + 1) % len(banks)
		banks[idx]++
	}
}

func main() {
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	banksStr := strings.Split(strings.TrimRight(string(input), "\n"), "\t")

	// Convert to ints
	banks := make([]int, len(banksStr))
	for i, v := range banksStr {
		banks[i], err = strconv.Atoi(v)
		if err != nil {
			log.Fatal(err)
		}
	}

	seen := make(map[string]int)
	step := 0
	seen[joinIntSlice(banks, ",")] = step

	for {
		maxIdx := maxIdx(banks)
		redistribute(banks, maxIdx)
		step++
		_, ok := seen[joinIntSlice(banks, ",")]
		if ok {
			break
		}
		seen[joinIntSlice(banks, ",")] = step
	}
	fmt.Println(step - seen[joinIntSlice(banks, ",")])
}
