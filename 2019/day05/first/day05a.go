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
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	opCodes, err := convert.StrSliceToInt(opCodesStr)
	if err != nil {
		log.Die("converting string slice to int", err)
	}

	if err := runProgram(opCodes); err != nil {
		log.Die("running op codes", err)
	}
}

const (
	add    = 1
	mult   = 2
	input  = 3
	output = 4
	halt   = 99

	positionMode  = 0
	immediateMode = 1
)

var nargs = map[int]int{
	add:    3,
	mult:   3,
	input:  1,
	output: 1,
	halt:   0,
}

func runProgram(codes []int) error {
	idx := 0
	for {
		code, modes := parseValue(codes[idx])
		params := getParams(codes, idx, modes)

		switch code {
		case halt:
			return nil

		case add:
			codes[codes[idx+3]] = params[0] + params[1]
			idx += nargs[add] + 1

		case mult:
			codes[codes[idx+3]] = params[0] * params[1]
			idx += nargs[mult] + 1

		case input:
			codes[codes[idx+1]] = 1
			idx += nargs[input] + 1

		case output:
			fmt.Println(params[0])
			idx += nargs[output] + 1

		default:
			return fmt.Errorf("illegal opcode %d", codes[idx])
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
