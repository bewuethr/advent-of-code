package main

import (
	"fmt"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	"github.com/bewuethr/advent-of-code/go/math"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	signalStr := strings.Split(scanner.Text(), "")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	signals, err := convert.StrSliceToInt(signalStr)
	if err != nil {
		log.Die("converting to ints", err)
	}

	cache := make(cache)

	for i := 0; i < 100; i++ {
		next := make([]int, len(signals))
		for j := range signals {
			pattern := cache.getPattern(j)
			var newVal int
			for k, e := range signals {
				newVal += e * pattern[(k+1)%len(pattern)]
			}
			next[j] = math.IntAbs(newVal % 10)
		}
		signals = next
	}

	fmt.Println(strings.Join(convert.IntSliceToStr(signals[:8]), ""))
}

type cache map[int][]int

func (c cache) getPattern(idx int) []int {
	if pattern, ok := c[idx]; !ok {
		var base = [...]int{0, 1, 0, -1}
		for _, val := range base {
			for i := 0; i < idx+1; i++ {
				pattern = append(pattern, val)
			}
		}
		c[idx] = pattern
	}

	return c[idx]
}
