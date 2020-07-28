package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"

	"github.com/bewuethr/advent-of-code/go/log"
)

func main() {
	scanner, err := getInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	fuel := 0
	for scanner.Scan() {
		module, err := strconv.Atoi(scanner.Text())
		if err != nil {
			log.Die("converting to int", err)
		}

		fuel += module/3 - 2
	}
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	fmt.Println(fuel)
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
