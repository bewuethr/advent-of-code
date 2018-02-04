package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strings"
)

type coord struct {
	col, row int
}

func abs(n int) int {
	if n > 0 {
		return n
	}
	return -n
}

func dist(pos coord) int {
	// Convert to cube coordinates
	x := pos.col
	z := pos.row - (pos.col-(pos.col&1))/2
	y := -x - z

	// Distance from origin
	return (abs(x) + abs(y) + abs(z)) / 2
}

func main() {
	if len(os.Args) == 1 {
		log.Fatal("Filename not specified")
	}
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	steps := strings.Split(strings.TrimRight(string(input), "\n"), ",")

	var pos coord
	var max int

	// Using odd-q vertical layout
	for _, step := range steps {
		switch step {
		case "n":
			pos.row--
		case "ne":
			if pos.col&1 == 0 {
				pos.row--
			}
			pos.col++
		case "se":
			if pos.col&1 == 1 {
				pos.row++
			}
			pos.col++
		case "s":
			pos.row++
		case "sw":
			if pos.col&1 == 1 {
				pos.row++
			}
			pos.col--
		case "nw":
			if pos.col&1 == 0 {
				pos.row--
			}
			pos.col--
		default:
			log.Fatal("Illegal direction:", step)
		}
		if dist(pos) > max {
			max = dist(pos)
		}
	}

	fmt.Println(max)
}
