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
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	opCodes, err := convert.StrSliceToInt(opCodesStr)
	if err != nil {
		log.Die("converting string slice to int", err)
	}

	var max int
	for _, phases := range math.IntPermutations([]int{0, 1, 2, 3, 4}) {
		channels := []chan int{make(chan int)}
		for i := 0; i < 5; i++ {
			codesCopy := make([]int, len(opCodes))
			copy(codesCopy, opCodes)
			channels = append(channels, make(chan int))
			go runProgram(codesCopy, phases[i], channels[i], channels[i+1])
		}

		channels[0] <- 0
		max = math.IntMax(max, <-channels[len(channels)-1])
	}
	fmt.Println(max)
}

const (
	add         = 1
	mult        = 2
	input       = 3
	output      = 4
	jumpIfTrue  = 5
	jumpIfFalse = 6
	lessThan    = 7
	equals      = 8
	halt        = 99

	positionMode  = 0
	immediateMode = 1
)

var nargs = map[int]int{
	add:         3,
	mult:        3,
	input:       1,
	output:      1,
	jumpIfTrue:  2,
	jumpIfFalse: 2,
	lessThan:    3,
	equals:      3,
	halt:        0,
}

func runProgram(codes []int, phase int, in <-chan int, out chan<- int) {
	firstInput := true
	idx := 0
	for {
		code, modes := parseValue(codes[idx])
		params := getParams(codes, idx, modes)

		switch code {
		case halt:
			close(out)
			return

		case add:
			codes[codes[idx+3]] = params[0] + params[1]
			idx += nargs[add] + 1

		case mult:
			codes[codes[idx+3]] = params[0] * params[1]
			idx += nargs[mult] + 1

		case input:
			if firstInput {
				codes[codes[idx+1]] = phase
				firstInput = false
			} else {
				codes[codes[idx+1]] = <-in
			}
			idx += nargs[input] + 1

		case output:
			out <- params[0]
			idx += nargs[output] + 1

		case jumpIfTrue:
			if params[0] != 0 {
				idx = params[1]
			} else {
				idx += nargs[jumpIfTrue] + 1
			}

		case jumpIfFalse:
			if params[0] == 0 {
				idx = params[1]
			} else {
				idx += nargs[jumpIfFalse] + 1
			}

		case lessThan:
			if params[0] < params[1] {
				codes[codes[idx+3]] = 1
			} else {
				codes[codes[idx+3]] = 0
			}
			idx += nargs[lessThan] + 1

		case equals:
			if params[0] == params[1] {
				codes[codes[idx+3]] = 1
			} else {
				codes[codes[idx+3]] = 0
			}
			idx += nargs[equals] + 1

		default:
			panic(fmt.Sprintf("illegal opcode %d", codes[idx]))
		}
	}
}

func parseValue(val int) (code int, modes []int) {
	code = val % 100
	if valStr := strconv.Itoa(val); len(valStr) > 2 {
		valStr = valStr[:len(valStr)-2]

		var modesStr []string
		for _, m := range valStr {
			modesStr = append([]string{string(m)}, modesStr...)
		}

		var err error
		modes, err = convert.StrSliceToInt(modesStr)
		if err != nil {
			log.Die("converting modes to int", err)
		}
	}

	for len(modes) < nargs[code] {
		modes = append(modes, 0)
	}

	return code, modes
}

func getParams(codes []int, idx int, modes []int) []int {
	var params []int

	for i := 0; i < len(modes); i++ {
		var param int
		if modes[i] == immediateMode {
			param = codes[idx+i+1]
		} else {
			param = codes[codes[idx+i+1]]
		}
		params = append(params, param)
	}

	return params
}
