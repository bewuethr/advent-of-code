package main

import (
	"fmt"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	wire1 := strings.Split(scanner.Text(), ",")

	scanner.Scan()
	wire2 := strings.Split(scanner.Text(), ",")

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	locs1, err := getLocations(wire1)
	if err != nil {
		log.Die("making first location map", err)
	}

	locs2, err := getLocations(wire2)
	if err != nil {
		log.Die("making second location map", err)
	}

	intersections := getIntersections(locs1, locs2)
	nearest := getNearest(intersections)
	fmt.Println(nearest.ManhattanDistance())
}

var directions = map[string]grid.Direction{
	"U": grid.Up,
	"R": grid.Right,
	"D": grid.Down,
	"L": grid.Left,
}

func getLocations(wireStr []string) (map[grid.Point]bool, error) {
	locations := make(map[grid.Point]bool)
	pos := grid.NewPoint(0, 0)

	for _, instr := range wireStr {
		dir := instr[:1]
		distStr := instr[1:]
		dist, err := strconv.Atoi(distStr)
		if err != nil {
			return nil, err
		}

		for i := 0; i < dist; i++ {
			if err := pos.Move(directions[dir], 1); err != nil {
				return nil, err
			}

			locations[*pos.Copy()] = true
		}
	}

	return locations, nil
}

func getIntersections(locs1, locs2 map[grid.Point]bool) map[grid.Point]bool {
	intersections := make(map[grid.Point]bool)

	for p := range locs1 {
		if _, ok := locs2[p]; ok {
			intersections[p] = true
		}
	}

	return intersections
}

func getNearest(points map[grid.Point]bool) *grid.Point {
	var nearest *grid.Point

	for p := range points {
		p := p
		if nearest == nil || p.ManhattanDistance() < nearest.ManhattanDistance() {
			nearest = &p
		}
	}

	return nearest
}
