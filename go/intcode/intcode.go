// Package intcode implements an intocde computer.
package intcode

import (
	"fmt"
	"strconv"

	"github.com/bewuethr/advent-of-code/go/convert"
)

const (
	// Instructions
	add         = 1
	mult        = 2
	input       = 3
	output      = 4
	jumpIfTrue  = 5
	jumpIfFalse = 6
	lessThan    = 7
	equals      = 8
	halt        = 99

	// Modes
	positionMode  = 0
	immediateMode = 1
)

// nargs maps instructions to the number of arguments they use.
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

// methodMap is a map from instructions to the corresponding Computer methods.
var methodMap = map[int]func(*Computer, []int){
	add:         (*Computer).add,
	mult:        (*Computer).mult,
	input:       (*Computer).input,
	output:      (*Computer).output,
	jumpIfTrue:  (*Computer).jumpIfTrue,
	jumpIfFalse: (*Computer).jumpIfFalse,
	lessThan:    (*Computer).lessThan,
	equals:      (*Computer).equals,
}

// Computer is an opcode computer.
type Computer struct {
	opcodes   []int
	inputVals []int
	instrPtr  int
}

// NewComputer returns an opcode computer with its memory initalized to opcodes.
func NewComputer(opcodes []int) *Computer {
	return &Computer{
		opcodes:  opcodes,
		instrPtr: 0,
	}
}

// RunProgram executes the program in the memory of the computer.
func (c *Computer) RunProgram(inputVals ...int) error {
	c.inputVals = inputVals
	for {
		code, params, err := c.parseInstruction(c.opcodes[c.instrPtr])
		if err != nil {
			return err
		}

		if code == halt {
			return nil
		}

		methodMap[code](c, params)
	}
}

// Value returns the value at position idx.
func (c *Computer) Value(idx int) int {
	return c.opcodes[idx]
}

func (c *Computer) add(params []int) {
	c.opcodes[c.opcodes[c.instrPtr+3]] = params[0] + params[1]
	c.instrPtr += nargs[add] + 1
}

func (c *Computer) mult(params []int) {
	c.opcodes[c.opcodes[c.instrPtr+3]] = params[0] * params[1]
	c.instrPtr += nargs[mult] + 1
}

func (c *Computer) input(params []int) {
	c.opcodes[c.opcodes[c.instrPtr+1]] = c.inputVals[0]
	c.inputVals = c.inputVals[1:]
	c.instrPtr += nargs[input] + 1
}

func (c *Computer) output(params []int) {
	fmt.Println(params[0])
	c.instrPtr += nargs[output] + 1
}

func (c *Computer) jumpIfTrue(params []int) {
	if params[0] != 0 {
		c.instrPtr = params[1]
	} else {
		c.instrPtr += nargs[jumpIfTrue] + 1
	}
}

func (c *Computer) jumpIfFalse(params []int) {
	if params[0] == 0 {
		c.instrPtr = params[1]
	} else {
		c.instrPtr += nargs[jumpIfFalse] + 1
	}
}

func (c *Computer) lessThan(params []int) {
	if params[0] < params[1] {
		c.opcodes[c.opcodes[c.instrPtr+3]] = 1
	} else {
		c.opcodes[c.opcodes[c.instrPtr+3]] = 0
	}
	c.instrPtr += nargs[lessThan] + 1
}

func (c *Computer) equals(params []int) {
	if params[0] == params[1] {
		c.opcodes[c.opcodes[c.instrPtr+3]] = 1
	} else {
		c.opcodes[c.opcodes[c.instrPtr+3]] = 0
	}
	c.instrPtr += nargs[equals] + 1
}

// parseInstruction reads a value  from memory and extracts the opcode as well
// as the parameter values for the instruction, taking the parameter mode into
// account.
func (c *Computer) parseInstruction(val int) (code int, params []int, err error) {
	code = val % 100
	var modes []int
	if valStr := strconv.Itoa(val); len(valStr) > 2 {
		valStr = valStr[:len(valStr)-2]

		var modesStr []string
		for _, m := range valStr {
			modesStr = append([]string{string(m)}, modesStr...)
		}

		var err error
		modes, err = convert.StrSliceToInt(modesStr)
		if err != nil {
			return 0, nil, fmt.Errorf("converting modes %v to int: %w", modesStr, err)
		}
	}

	for len(modes) < nargs[code] {
		modes = append(modes, 0)
	}

	return code, c.getParams(modes), nil
}

// getParams takes a slice of parameter modes and returns the corresponding
// parameter values based on the current value of the instruction pointer.
func (c *Computer) getParams(modes []int) []int {
	var params []int

	for i := 0; i < len(modes); i++ {
		var param int
		if modes[i] == immediateMode {
			param = c.opcodes[c.instrPtr+i+1]
		} else {
			param = c.opcodes[c.opcodes[c.instrPtr+i+1]]
		}
		params = append(params, param)
	}

	return params
}
