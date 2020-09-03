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

type distances struct {
	d   map[grid.Vec2]int
	max int
}

func (dist *distances) update(pos, dir grid.Vec2) {
	if _, ok := dist.d[pos]; ok {
		return
	}
	dist.d[pos] = dist.d[pos.Subtract(dir)] + 1
	if dist.d[pos] > dist.max {
		dist.max = dist.d[pos]
	}
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

	distances := distances{
		d:   map[grid.Vec2]int{grid.Origin: 0},
		max: 0,
	}
	recording := false
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
				recording = true
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
				distances.d[pos] = 0

			default:
				log.Die("checking status", fmt.Errorf("unexpected status %q", status))
			}

			if recording {
				distances.update(pos, dir)
			}
			if len(area) > 3 && pos == grid.Origin {
				fmt.Println(distances.max)
				break Loop
			}
			comp.Input <- directions[newDir]
		}
	}
}
