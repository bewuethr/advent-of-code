// Package intcode implements an intcode computer.
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
	adjustBase  = 9
	halt        = 99

	// Modes
	positionMode  = 0
	immediateMode = 1
	relativeMode  = 2
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
	adjustBase:  1,
	halt:        0,
}

// param is a type for values in memory, where index is the optional location
// of the value; it is nil for immediate mode parameters.
type param struct {
	value int
	index *int
}

// methodMap is a map from instructions to the corresponding Computer methods.
var methodMap = map[int]func(*Computer, []param){
	add:         (*Computer).add,
	mult:        (*Computer).mult,
	input:       (*Computer).input,
	output:      (*Computer).output,
	jumpIfTrue:  (*Computer).jumpIfTrue,
	jumpIfFalse: (*Computer).jumpIfFalse,
	lessThan:    (*Computer).lessThan,
	equals:      (*Computer).equals,
	adjustBase:  (*Computer).adjustBase,
}

// Computer is an opcode computer. Input is read through the Input channel,
// output from the Output channel; the "halt" instruction closes the Done
// channel, and any errors can be read from the Err channel.
type Computer struct {
	opcodes   []int
	instrPtr  int
	relOffset int
	Done      chan struct{}
	Input     chan int
	Output    chan int
	Err       chan error
}

// NewComputer returns an opcode computer with its memory initalized to opcodes.
func NewComputer(opcodes []int) *Computer {
	var (
		done   = make(chan struct{})
		input  = make(chan int)
		output = make(chan int)
		err    = make(chan error)
	)

	return &Computer{
		opcodes:   opcodes,
		instrPtr:  0,
		relOffset: 0,
		Done:      done,
		Input:     input,
		Output:    output,
		Err:       err,
	}
}

// StartProgram starts a goroutine that executes the program in the memory of the
// computer. It is typically used like this:
//
//     Loop:
//         for {
//             select {
//             case v := <-c.Output:
//                 // Do something with output.
//             case <-c.Done:
//                 break Loop
//             case err := <-c.Err:
//                 // Handle error.
//             }
//         }
func (c *Computer) StartProgram() {
	go func() {
		for {
			code, params, err := c.parseInstruction(c.opcodes[c.instrPtr])
			if err != nil {
				c.Err <- err
				return
			}

			if code == halt {
				close(c.Done)
				return
			}

			methodMap[code](c, params)
		}
	}()
}

// Value returns the value at position idx; if the index is out of range, extra
// memory is appended.
func (c *Computer) Value(idx int) int {
	if idx < len(c.opcodes) {
		return c.opcodes[idx]
	}

	if idx < cap(c.opcodes) {
		c.opcodes = c.opcodes[:cap(c.opcodes)]
		return c.opcodes[idx]
	}

	// Index larger than even backing array, allocate new slice
	newOpcodes := make([]int, idx+1, (2*idx)+1)
	copy(newOpcodes, c.opcodes)
	c.opcodes = newOpcodes
	return c.opcodes[idx]
}

func (c *Computer) add(params []param) {
	c.opcodes[*params[2].index] = params[0].value + params[1].value
	c.instrPtr += nargs[add] + 1
}

func (c *Computer) mult(params []param) {
	c.opcodes[*params[2].index] = params[0].value * params[1].value
	c.instrPtr += nargs[mult] + 1
}

func (c *Computer) input(params []param) {
	c.opcodes[*params[0].index] = <-c.Input
	c.instrPtr += nargs[input] + 1
}

func (c *Computer) output(params []param) {
	c.Output <- params[0].value
	c.instrPtr += nargs[output] + 1
}

func (c *Computer) jumpIfTrue(params []param) {
	if params[0].value != 0 {
		c.instrPtr = params[1].value
	} else {
		c.instrPtr += nargs[jumpIfTrue] + 1
	}
}

func (c *Computer) jumpIfFalse(params []param) {
	if params[0].value == 0 {
		c.instrPtr = params[1].value
	} else {
		c.instrPtr += nargs[jumpIfFalse] + 1
	}
}

func (c *Computer) lessThan(params []param) {
	if params[0].value < params[1].value {
		c.opcodes[*params[2].index] = 1
	} else {
		c.opcodes[*params[2].index] = 0
	}
	c.instrPtr += nargs[lessThan] + 1
}

func (c *Computer) equals(params []param) {
	if params[0].value == params[1].value {
		c.opcodes[*params[2].index] = 1
	} else {
		c.opcodes[*params[2].index] = 0
	}
	c.instrPtr += nargs[equals] + 1
}

func (c *Computer) adjustBase(params []param) {
	c.relOffset += params[0].value
	c.instrPtr += nargs[adjustBase] + 1
}

// parseInstruction reads a value from memory and extracts the opcode as well as
// the parameter values for the instruction, taking the parameter mode into
// account.
func (c *Computer) parseInstruction(val int) (code int, params []param, err error) {
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

	params, err = c.getParams(modes)
	return code, params, err
}

// getParams takes a slice of parameter modes and returns the corresponding
// parameter values based on the current value of the instruction pointer.
func (c *Computer) getParams(modes []int) ([]param, error) {
	var params []param

	for i := 0; i < len(modes); i++ {
		var p param
		switch modes[i] {
		case positionMode:
			idx := c.Value(c.instrPtr + i + 1)
			p = param{
				value: c.Value(idx),
				index: &idx,
			}

		case immediateMode:
			p.value = c.Value(c.instrPtr + i + 1)

		case relativeMode:
			idx := c.Value(c.instrPtr+i+1) + c.relOffset
			p = param{
				value: c.Value(idx),
				index: &idx,
			}

		default:
			return nil, fmt.Errorf("unknown parameter mode %q", modes[i])
		}

		params = append(params, p)
	}

	return params, nil
}
