package main

import (
	"fmt"
	"strings"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

var orbits = make(map[string][]string)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	for scanner.Scan() {
		orbit := strings.Split(scanner.Text(), ")")
		orbits[orbit[0]] = append(orbits[orbit[0]], orbit[1])
	}

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	fmt.Println(traverse("COM", 0))
}

func traverse(obj string, depth int) int {
	sum := depth
	for _, o := range orbits[obj] {
		sum += traverse(o, depth+1)
	}
	return sum
}
