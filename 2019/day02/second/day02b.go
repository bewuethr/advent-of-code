package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/intcode"
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

			comp := intcode.NewComputer(opCodes)
			if err := comp.RunProgram(); err != nil {
				log.Die("running op codes", err)
			}

			if comp.Value(0) == target {
				fmt.Println(100*noun + verb)
				os.Exit(0)
			}
		}
	}
}
