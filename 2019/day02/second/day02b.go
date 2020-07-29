package main

import (
	"fmt"
	"os"
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
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	initOpCodes, err := convert.StrSliceToInt(opCodesStr)
	if err != nil {
		log.Die("converting string slice to int", err)
	}

	const target = 19690720

	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			opCodes := make([]int, len(initOpCodes))
			copy(opCodes, initOpCodes)
			opCodes[1], opCodes[2] = noun, verb

			opCodes, err = runProgram(opCodes)
			if err != nil {
				log.Die("running op codes", err)
			}

			if opCodes[0] == target {
				fmt.Println(100*noun + verb)
				os.Exit(0)
			}
		}
	}
}

func runProgram(codes []int) ([]int, error) {
	const (
		add  = 1
		mult = 2
		halt = 99
	)

	instrPtr := 0
	for {
		switch codes[instrPtr] {
		case halt:
			return codes, nil

		case add:
			codes[codes[instrPtr+3]] = codes[codes[instrPtr+1]] + codes[codes[instrPtr+2]]

		case mult:
			codes[codes[instrPtr+3]] = codes[codes[instrPtr+1]] * codes[codes[instrPtr+2]]

		default:
			return nil, fmt.Errorf("illegal opcode %d", codes[instrPtr])
		}

		instrPtr += 4
	}
}
