package main

import (
	"fmt"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	"github.com/bewuethr/advent-of-code/go/math"
)

type axis struct {
	pos int
	vel int
}

const dims = 3

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	axes := make([][]axis, dims)

	for scanner.Scan() {
		var x, y, z int
		fmt.Sscanf(scanner.Text(), "<x=%d, y=%d, z=%d>", &x, &y, &z)
		axes[0] = append(axes[0], axis{pos: x})
		axes[1] = append(axes[1], axis{pos: y})
		axes[2] = append(axes[2], axis{pos: z})
	}

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	var initAxes []string
	for _, a := range axes {
		initAxes = append(initAxes, fmt.Sprint(a))
	}

	var phases []int

Outer:
	for i := 0; i < dims; i++ {
		ax := axes[i]
		for j := 0; ; j++ {
			for k := 0; k < len(ax)-1; k++ {
				for l := k + 1; l < len(ax); l++ {
					dvk, dvl := getComponent(ax[k].pos, ax[l].pos)
					ax[k].vel += dvk
					ax[l].vel += dvl
				}
			}
			for idx, moon := range ax {
				ax[idx].pos += moon.vel
			}
			if fmt.Sprint(ax) == initAxes[i] {
				phases = append(phases, j+1)
				continue Outer
			}

		}
	}

	fmt.Println(math.LCM(phases...))
}

func getComponent(n1, n2 int) (int, int) {
	switch {
	case n1 < n2:
		return 1, -1
	case n1 == n2:
		return 0, 0
	case n1 > n2:
		return -1, 1
	default:
		panic("getComponent: this never happens")
	}
}
