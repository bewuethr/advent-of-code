package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	input := strings.Split(scanner.Text(), "-")

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	limits, err := convert.StrSliceToInt(input)
	if err != nil {
		log.Die("converting input to ints", err)
	}

	count := 0
	for n := limits[0]; n <= limits[1]; n++ {
		if !hasAdjacent(n) {
			continue
		}

		if !neverDecreases(n) {
			continue
		}

		count++
	}

	fmt.Println(count)
}

func hasAdjacent(n int) bool {
	s := strconv.Itoa(n)
	for i := 1; i < len(s); i++ {
		if s[i] == s[i-1] {
			return true
		}
	}
	return false
}

func neverDecreases(n int) bool {
	s := strconv.Itoa(n)
	for i := 1; i < len(s); i++ {
		if s[i] < s[i-1] {
			return false
		}
	}
	return true
}
