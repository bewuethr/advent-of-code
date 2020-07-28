package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	opCodes, err := strSliceToInt(opCodesStr)
	if err != nil {
		log.Die("converting string slice to int", err)
	}

	opCodes[1], opCodes[2] = 12, 2
	opCodes, err = runProgram(opCodes)
	if err != nil {
		log.Die("running op codes", err)
	}

	fmt.Println(opCodes[0])
}

func runProgram(codes []int) ([]int, error) {
	const (
		add  = 1
		mult = 2
		halt = 99
	)

	idx := 0
	for {
		switch codes[idx] {
		case halt:
			return codes, nil

		case add:
			codes[codes[idx+3]] = codes[codes[idx+1]] + codes[codes[idx+2]]

		case mult:
			codes[codes[idx+3]] = codes[codes[idx+1]] * codes[codes[idx+2]]

		default:
			return nil, fmt.Errorf("illegal opcode %d", codes[idx])
		}

		idx += 4
	}
}

func strSliceToInt(strSlice []string) ([]int, error) {
	intSlice := make([]int, len(strSlice))
	for i, s := range strSlice {
		val, err := strconv.Atoi(s)
		if err != nil {
			return nil, err
		}
		intSlice[i] = val
	}

	return intSlice, nil
}
