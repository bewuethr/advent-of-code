package main

import (
	"fmt"

	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	"github.com/bewuethr/advent-of-code/go/math"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	var asteroids []grid.Vec2

	for y := 0; scanner.Scan(); y++ {
		line := scanner.Text()
		for x, c := range line {
			if c == '#' {
				asteroids = append(asteroids, grid.NewVec2(x, y))
			}
		}
	}

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	var max int
	for i, a := range asteroids {
		visible := make(map[grid.Vec2]int)
		for j, aa := range asteroids {
			if i == j {
				continue
			}
			visible[normalize(a, aa)]++
		}
		max = math.IntMax(max, len(visible))
	}

	fmt.Println(max)
}

func normalize(a1, a2 grid.Vec2) grid.Vec2 {
	diff := a2.Subtract(a1)
	return diff.ScalarDiv(math.GCD(diff.X(), diff.Y()))
}
