package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
)

func main() {
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	re := regexp.MustCompile("[[:alpha:]]+")
	progCounter := make(map[string]int)

	for scanner.Scan() {
		programs := re.FindAllString(scanner.Text(), -1)
		for _, prog := range programs {
			progCounter[prog]++
		}
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	var base string
	for prog, count := range progCounter {
		if count == 1 {
			base = prog
			break
		}
	}

	fmt.Println(base)
}
