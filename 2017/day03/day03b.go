package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
)

type coord struct {
	x, y int
}

type direction coord

type walker struct {
	idx               int
	pos               coord
	dir               direction
	secondCycle       bool
	curDist, distLeft int
}

func abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

func (w *walker) rotLeft() {
	w.dir.x, w.dir.y = -w.dir.y, w.dir.x
}

func (w *walker) move() {
	w.pos.x += w.dir.x
	w.pos.y += w.dir.y
	w.distLeft--
}

func (w *walker) update() {
	w.idx++
	if w.distLeft == 0 {
		if w.secondCycle {
			w.secondCycle = false
			w.curDist++
		} else {
			w.secondCycle = true
		}
		w.rotLeft()
		w.distLeft = w.curDist
	}
}

func updateMap(m map[coord]int, pos coord) {
	next := 0
	for _, dx := range []int{-1, 0, 1} {
		for _, dy := range []int{-1, 0, 1} {
			val, ok := m[coord{pos.x + dx, pos.y + dy}]
			if ok {
				next += val
			}
		}
	}
	m[pos] = next
}

func main() {
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	s, _ := strconv.Atoi(strings.TrimRight(string(input), "\n"))

	walker := walker{
		idx:         1,
		pos:         coord{0, 0},
		dir:         direction{1, 0},
		secondCycle: false,
		curDist:     1,
		distLeft:    1,
	}

	m := make(map[coord]int)
	m[walker.pos] = 1

	for m[walker.pos] < s {
		walker.move()
		walker.update()
		updateMap(m, walker.pos)
	}
	fmt.Println(m[walker.pos])
}
