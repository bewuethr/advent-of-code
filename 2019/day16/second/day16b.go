package main

import (
	"fmt"
	"strconv"
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

	shortSignals, err := convert.StrSliceToInt(signalStr)
	if err != nil {
		log.Die("converting to ints", err)
	}

	signals := make([]int, 0, 10_000*len(shortSignals))
	for i := 0; i < 10000; i++ {
		signals = append(signals, shortSignals...)
	}

	offsetStr := strings.Join(convert.IntSliceToStr(signals[:7]), "")
	offset, err := strconv.Atoi(offsetStr)
	if err != nil {
		log.Die("converting offset string", err)
	}

	signals = signals[offset:]
	n := len(signals)
	for i := 0; i < 100; i++ {
		sum := 0
		for j := n - 1; j >= 0; j-- {
			sum += signals[j]
			signals[j] = math.IntAbs(sum % 10)
		}
	}

	fmt.Println(strings.Join(convert.IntSliceToStr(signals[:8]), ""))
}
