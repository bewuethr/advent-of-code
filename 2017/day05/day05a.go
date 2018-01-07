package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	lines := strings.Split(string(input), "\n")
	// Drop last element (is empty)
	lines = lines[:len(lines)-1]

	// Convert to integer slice
	offsets := make([]int, len(lines))
	for i, v := range lines {
		offsets[i], err = strconv.Atoi(v)
		if err != nil {
			log.Fatal(err)
		}
	}

	ctr := 0

	for idx := 0; idx >= 0 && idx < len(offsets); {
		next := idx + offsets[idx]
		offsets[idx]++
		ctr++
		idx = next
	}

	fmt.Println(ctr)
}
