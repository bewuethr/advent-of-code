package main

import (
	"fmt"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/intcode"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

type motion int

const (
	turn motion = iota
	straight
)

const (
	wall   = 0
	moved  = 1
	oxygen = 2
)

var directions = map[grid.Vec2]int{
	grid.Uy.ScalarMult(-1): 1, // north
	grid.Uy:                2, // south
	grid.Ux.ScalarMult(-1): 3, // west
	grid.Ux:                4, // east
}

type distances map[grid.Vec2]int

func (d distances) update(pos, dir grid.Vec2) {
	if _, ok := d[pos]; ok {
		return
	}
	d[pos] = d[pos.Subtract(dir)] + 1
	return
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

	pos := grid.Origin
	dir := grid.Uy.ScalarMult(-1)
	hand := dir.RotCW()
	area := map[grid.Vec2]rune{pos: '.'}
	comp.Input <- directions[hand]
	motion := turn

	distances := distances{grid.Origin: 0}
Loop:
	for {
		select {
		case err := <-comp.Err:
			log.Die("running op codes", err)
		case <-comp.Done:
			break Loop
		case status := <-comp.Output:
			var newDir grid.Vec2
			switch status {
			case wall:
				if motion == turn {
					area[pos.Add(hand)] = '#'
					motion = straight
					newDir = dir
				} else {
					area[pos.Add(dir)] = '#'
					motion = turn
					hand = dir
					dir = dir.RotCCW()
					newDir = hand
				}

			case moved:
				if motion == turn {
					pos = pos.Add(hand)
					dir = hand
					hand = hand.RotCW()
					newDir = dir
					motion = straight
				} else {
					pos = pos.Add(dir)
					newDir = hand
					motion = turn
				}
				area[pos] = '.'

			case oxygen:
				fmt.Println(distances[pos] + 1)
				if motion == turn {
					pos = pos.Add(hand)
					dir = hand
					hand = hand.RotCW()
					newDir = dir
					motion = straight
				} else {
					pos = pos.Add(dir)
					newDir = hand
					motion = turn
				}
				area[pos] = 'O'

			default:
				log.Die("checking status", fmt.Errorf("unexpected status %q", status))
			}

			distances.update(pos, dir)
			if len(area) > 3 && pos == grid.Origin {
				break Loop
			}
			comp.Input <- directions[newDir]
		}
	}
}

func draw(area map[grid.Vec2]rune, pos grid.Vec2) {
	minX, maxX, minY, maxY := getBoundary(area)
	for y := minY; y <= maxY; y++ {
		for x := minX; x <= maxX; x++ {
			p := grid.NewVec2(x, y)
			if p == pos {
				fmt.Print("D")
				continue
			}
			if r, ok := area[p]; ok {
				fmt.Printf("%c", r)
			} else {
				fmt.Print(" ")
			}
		}
		fmt.Println()
	}
}

func getBoundary(area map[grid.Vec2]rune) (minX, maxX, minY, maxY int) {
	for v := range area {
		switch x := v.X(); {
		case x > maxX:
			maxX = x
		case x < minX:
			minX = x
		}

		switch y := v.Y(); {
		case y > maxY:
			maxY = y
		case y < minY:
			minY = y
		}
	}

	return minX, maxX, minY, maxY
}
