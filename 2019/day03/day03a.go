package main

import (
	"fmt"
	"sort"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

type point struct {
	x, y int
}

func (p *point) move(dir string, dist int) error {
	switch dir {
	case "U":
		p.y -= dist
	case "R":
		p.x += dist
	case "D":
		p.y += dist
	case "L":
		p.x -= dist
	default:
		return fmt.Errorf("move: illegal direction %v", dir)
	}

	return nil
}

type path []point

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

	path1, err := makePath(wire1)
	if err != nil {
		log.Die("making first path", err)
	}

	path2, err := makePath(wire2)
	if err != nil {
		log.Die("making second path", err)
	}

	intersections := getIntersections(path1, path2)
	sort.Slice(intersections, func(i, j int) bool {
		return manhattanDistance(intersections[i]) < manhattanDistance(intersections[j])
	})

	fmt.Println(manhattanDistance(intersections[0]))
}

func getIntersections(p1, p2 path) path {
	intersectMap := make(map[point]bool)

	for _, p := range p1[1:] {
		if contains(p2, p) {
			intersectMap[p] = true
		}
	}

	for _, p := range p2[1:] {
		if contains(p1, p) {
			intersectMap[p] = true
		}
	}

	var intersectPath path
	for p := range intersectMap {
		intersectPath = append(intersectPath, p)
	}

	return intersectPath
}

func contains(points []point, p point) bool {
	for _, pp := range points {
		if pp == p {
			return true
		}
	}

	return false
}

func makePath(wireStr []string) (path, error) {
	var wire path
	pos := point{0, 0}
	wire = append(wire, pos)

	for _, instr := range wireStr {
		dir := instr[:1]
		distStr := instr[1:]
		dist, err := strconv.Atoi(distStr)
		if err != nil {
			return nil, err
		}

		for i := 0; i < dist; i++ {
			if err := pos.move(dir, 1); err != nil {
				return nil, err
			}
			wire = append(wire, pos)
		}
	}

	return wire, nil
}

func manhattanDistance(p point) int {
	return abs(p.x) + abs(p.y)
}

func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func strSliceToInt(strSlice []string) ([]int, error) {
	intSlice := make([]int, len(strSlice))
	for i, s := range strSlice {
		val, err := strconv.Atoi(s)
		if err != nil {
			return nil, err
		}
		intSlice[i] = val
	}

	return intSlice, nil
}
