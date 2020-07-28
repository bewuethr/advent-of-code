package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/log"
)

type point struct {
	x, y int
}

type stepPoint struct {
	point
	steps int
}

func (sp *stepPoint) move(dir string, dist int) error {
	switch dir {
	case "U":
		sp.y -= dist
	case "R":
		sp.x += dist
	case "D":
		sp.y += dist
	case "L":
		sp.x -= dist
	default:
		return fmt.Errorf("move: illegal direction %v", dir)
	}

	sp.steps += dist
	return nil
}

type path []stepPoint

func main() {
	scanner, err := getInputScanner()
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
		return intersections[i].steps < intersections[j].steps
	})

	fmt.Println(intersections[0].steps)
}

func getIntersections(p1, p2 path) path {
	pointSet1 := pathToSet(p1[1:])
	pointSet2 := pathToSet(p2[1:])

	intersections := make(map[point]int)

	for p1, d1 := range pointSet1 {
		if d2, ok := pointSet2[p1]; ok {
			intersections[p1] = d1 + d2
		}
	}

	var intersectPath path
	for p, d := range intersections {
		intersectPath = append(intersectPath, stepPoint{p, d})
	}

	return intersectPath
}

func pathToSet(p path) map[point]int {
	steps := make(map[point]int)
	for _, pp := range p {
		if _, ok := steps[pp.point]; !ok {
			steps[pp.point] = pp.steps
		}
	}

	return steps
}

func contains(points []stepPoint, sp stepPoint) bool {
	for _, pp := range points {
		if pp.point == sp.point {
			return true
		}
	}

	return false
}

func makePath(wireStr []string) (path, error) {
	var wire path
	var pos stepPoint
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

func getInputScanner() (*bufio.Scanner, error) {
	if len(os.Args) == 1 {
		os.Args = append(os.Args, "input")
	}
	input, err := os.Open(os.Args[1])
	if err != nil {
		return nil, err
	}

	return bufio.NewScanner(input), nil
}
