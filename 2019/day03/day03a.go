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
	fmt.Println(nearest.ManhattanDistanceOrigin())
}

var directions = map[string]grid.Vec2{
	"U": grid.Uy.ScalarMult(-1),
	"R": grid.Ux,
	"D": grid.Uy,
	"L": grid.Ux.ScalarMult(-1),
}

func getLocations(wireStr []string) (map[grid.Vec2]bool, error) {
	locations := make(map[grid.Vec2]bool)
	pos := grid.Origin

	for _, instr := range wireStr {
		dir := instr[:1]
		distStr := instr[1:]
		dist, err := strconv.Atoi(distStr)
		if err != nil {
			return nil, err
		}

		for i := 0; i < dist; i++ {
			pos = pos.Add(directions[dir])
			locations[pos] = true
		}
	}

	return locations, nil
}

func getIntersections(locs1, locs2 map[grid.Vec2]bool) map[grid.Vec2]bool {
	intersections := make(map[grid.Vec2]bool)

	for loc := range locs1 {
		if _, ok := locs2[loc]; ok {
			intersections[loc] = true
		}
	}

	return intersections
}

func getNearest(vecs map[grid.Vec2]bool) grid.Vec2 {
	var nearest grid.Vec2

	for v := range vecs {
		v := v
		if nearest == grid.Origin || v.ManhattanDistanceOrigin() < nearest.ManhattanDistanceOrigin() {
			nearest = v
		}
	}

	return nearest
}
