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

type scaffolding map[grid.Vec2]rune

func (s scaffolding) isIntersection(pos grid.Vec2) bool {
	if s[pos] != '#' || pos.X() == 0 || pos.Y() == 0 {
		return false
	}

	if _, ok := s[pos.Add(grid.Ux)]; !ok {
		return false
	}

	if _, ok := s[pos.Add(grid.Uy)]; !ok {
		return false
	}

	return s[pos.Add(grid.Ux)] == '#' &&
		s[pos.Add(grid.Uy)] == '#' &&
		s[pos.Add(grid.Ux.ScalarMult(-1))] == '#' &&
		s[pos.Add(grid.Uy.ScalarMult(-1))] == '#'
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

	comp := intcode.NewComputer(opCodes)
	comp.StartProgram()

	scaffolds := make(scaffolding)
	x, y := 0, 0
	var maxX int

Loop:
	for {
		select {
		case err := <-comp.Err:
			log.Die("running op codes", err)
		case <-comp.Done:
			break Loop
		case output := <-comp.Output:
			switch r := rune(output); r {
			case '\n':
				y++
				maxX = math.IntMax(x, maxX)
				x = 0
			default:
				scaffolds[grid.NewVec2(x, y)] = r
				x++
			}
		}
	}

	sum := 0
	for yy := 0; yy < y; yy++ {
		for xx := 0; xx < maxX; xx++ {
			pos := grid.NewVec2(xx, yy)
			if scaffolds.isIntersection(pos) {
				sum += xx * yy
			}
		}
	}

	fmt.Println(sum)
}
