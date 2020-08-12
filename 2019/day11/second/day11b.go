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

type robot struct {
	pos grid.Vec2
	dir grid.Vec2
}

func (r *robot) move(instruction int) {
	switch instruction {
	case 0:
		r.dir = r.dir.RotCCW()
	case 1:
		r.dir = r.dir.RotCW()
	default:
		log.Die("moving robot", fmt.Errorf("illegal instruction %d", instruction))
	}
	r.pos = r.pos.Add(r.dir)
}

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

	robot := robot{
		pos: grid.Origin,
		dir: grid.Uy.ScalarMult(-1),
	}

	panels := make(map[grid.Vec2]int)
	panels[robot.pos] = 1
	var maxX, maxY int

	comp := intcode.NewComputer(opCodes)
	comp.StartProgram()
Loop:
	for {
		select {
		case comp.Input <- panels[robot.pos]:
		case err := <-comp.Err:
			log.Die("running op codes", err)
		case <-comp.Done:
			break Loop
		case panels[robot.pos] = <-comp.Output:
			robot.move(<-comp.Output)
		}
		maxX = math.IntMax(maxX, robot.pos.X())
		maxY = math.IntMax(maxY, robot.pos.Y())
	}

	for y := 0; y <= maxY; y++ {
		for x := 0; x <= maxX; x++ {
			c := "."
			if color, ok := panels[grid.NewVec2(x, y)]; ok && color == 1 {
				c = "#"
			}
			fmt.Print(c)
		}
		fmt.Println()
	}
}
