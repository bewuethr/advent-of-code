package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	input, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Fprintln(os.Stderr, "opening file:", err)
		os.Exit(1)
	}
	scanner := bufio.NewScanner(input)

	fuel := 0
	for scanner.Scan() {
		module, err := strconv.Atoi(scanner.Text())
		if err != nil {
			fmt.Fprintln(os.Stderr, "converting to int:", err)
			os.Exit(1)
		}

		fuel += module/3 - 2
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading input:", err)
		os.Exit(1)
	}

	fmt.Println(fuel)
}
