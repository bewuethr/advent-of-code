package main

import (
	"fmt"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/intcode"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	"github.com/bewuethr/advent-of-code/go/math"
)

const (
	empty  = 0
	wall   = 1
	block  = 2
	paddle = 3
	ball   = 4
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

	opCodes[0] = 2
	comp := intcode.NewComputer(opCodes)
	comp.StartProgram()

	screen := make(map[grid.Vec2]int)
	var maxX, maxY, joystick, score int
	var ballX, paddleX int

Loop:
	for {
		select {
		case comp.Input <- joystick:
		case x := <-comp.Output:
			y := <-comp.Output
			if x == -1 && y == 0 {
				score = <-comp.Output
				continue
			}

			id := <-comp.Output
			switch id {
			case ball:
				ballX = x
			case paddle:
				paddleX = x
			}

			switch {
			case ballX < paddleX:
				joystick = -1
			case ballX == paddleX:
				joystick = 0
			case ballX > paddleX:
				joystick = 1
			}

			screen[grid.NewVec2(x, y)] = id
			maxX = math.IntMax(maxX, x)
			maxY = math.IntMax(maxY, y)
		case err := <-comp.Err:
			log.Die("running op codes", err)
		case <-comp.Done:
			break Loop
		}
	}

	fmt.Println(score)
}
