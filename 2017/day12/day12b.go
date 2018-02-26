package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

func visit(g map[int][]int, s map[int]bool, id int) {
	s[id] = true
	for _, prog := range g[id] {
		if _, ok := s[prog]; ok {
			continue
		}
		visit(g, s, prog)
	}
}

func main() {
	if len(os.Args) == 1 {
		log.Fatal("Filename not specified")
	}
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	graph := make(map[int][]int)
	re := regexp.MustCompile(`\d+`)

	for scanner.Scan() {
		progStrings := re.FindAllString(scanner.Text(), -1)
		programs := make([]int, 0)
		for _, v := range progStrings {
			prog, err := strconv.Atoi(v)
			if err != nil {
				log.Fatal(err)
			}
			programs = append(programs, prog)
		}
		graph[programs[0]] = programs[1:]
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	// Graph traversal starting from program 0
	seen := make(map[int]bool)
	var groups int
OuterLoop:
	for {
		// Find first unseen program
		curProg := -1
		for prog := range graph {
			if _, ok := seen[prog]; !ok {
				curProg = prog
				break
			}
		}
		if curProg == -1 {
			// We have visited every program
			break OuterLoop
		}
		visit(graph, seen, curProg)
		groups++
	}

	fmt.Println(groups)
}
