package main

import (
	"fmt"
	"strconv"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	fuel := 0
	for scanner.Scan() {
		module, err := strconv.Atoi(scanner.Text())
		if err != nil {
			log.Die("converting to int", err)
		}

		fuel += getFuel(module)
	}
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	fmt.Println(fuel)
}

func getFuel(module int) int {
	fuel := module/3 - 2
	if fuel <= 0 {
		return 0
	}

	return fuel + getFuel(fuel)
}
