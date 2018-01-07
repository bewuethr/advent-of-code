package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"sort"
	"strings"
)

func main() {
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	valid := 0

Loop:
	for scanner.Scan() {
		words := strings.Split(scanner.Text(), " ")

		counts := make(map[string]int)
		for _, word := range words {
			runes := []rune(word)
			sort.Slice(runes, func(i, j int) bool { return runes[i] < runes[j] })
			word = string(runes)
			counts[word]++
			if counts[word] > 1 {
				continue Loop
			}
		}
		valid++
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	fmt.Println(valid)
}
