package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	if len(os.Args) < 2 {
		log.Fatal("No input file specified")
	}

	file, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	var secScanners = make(map[int]int)

	for scanner.Scan() {
		line := strings.Split(strings.TrimRight(scanner.Text(), "\n"), ": ")
		d, err := strconv.Atoi(line[0])
		if err != nil {
			log.Fatal(err)
		}
		r, err := strconv.Atoi(line[1])
		if err != nil {
			log.Fatal(err)
		}
		secScanners[d] = r
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	var severity int
	for d, r := range secScanners {
		if d%((r-1)*2) == 0 {
			severity += d * r
		}
	}
	fmt.Println(severity)
}
