package main

import (
	"fmt"
	"math"
	"sort"

	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	aocmath "github.com/bewuethr/advent-of-code/go/math"
)

type astLine struct {
	direction grid.Vec2
	asteroids []grid.Vec2
}

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

	idx, station := getStation(asteroids)
	asteroids = append(asteroids[:idx], asteroids[idx+1:]...)

	byAngle := make(map[grid.Vec2][]grid.Vec2)
	for _, a := range asteroids {
		direction := normalize(station, a)
		byAngle[direction] = append(byAngle[direction], a)
	}

	var sortedAsteroids []astLine
	for dir, asts := range byAngle {
		sort.Slice(asts, func(i, j int) bool {
			return asts[i].Subtract(station).Norm() < asts[j].Subtract(station).Norm()
		})
		sortedAsteroids = append(sortedAsteroids, astLine{
			direction: dir,
			asteroids: asts,
		})
	}

	sort.Slice(sortedAsteroids, func(i, j int) bool {
		angle := func(v grid.Vec2) float64 {
			return math.Mod(v.Azimuth()+math.Pi/2, math.Pi*2)
		}

		return angle(sortedAsteroids[i].direction) < angle(sortedAsteroids[j].direction)

	})

	var cur grid.Vec2
	pointer := 0
	for i := 0; i < 200; i++ {
		if pointer == len(sortedAsteroids) {
			pointer = 0
		}
		astLine := sortedAsteroids[pointer].asteroids
		cur = astLine[0]
		if len(astLine) == 1 {
			sortedAsteroids = append(sortedAsteroids[:pointer], sortedAsteroids[pointer+1:]...)
			continue
		}

		sortedAsteroids[pointer].asteroids = astLine[1:]
		pointer++
	}

	fmt.Println(cur.X()*100 + cur.Y())
}

func getStation(asteroids []grid.Vec2) (int, grid.Vec2) {
	var (
		max     int
		idx     int
		station grid.Vec2
	)

	for i, a := range asteroids {
		visible := make(map[grid.Vec2]int)
		for j, aa := range asteroids {
			if i == j {
				continue
			}
			visible[normalize(a, aa)]++
		}
		if len(visible) > max {
			max = len(visible)
			idx = i
			station = a
		}
	}

	return idx, station
}

func normalize(a1, a2 grid.Vec2) grid.Vec2 {
	diff := a2.Subtract(a1)
	return diff.ScalarDiv(aocmath.GCD(diff.X(), diff.Y()))
}
