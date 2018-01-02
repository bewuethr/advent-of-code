package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	f, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer f.Close()

	scanner := bufio.NewScanner(f)

	checksum := 0

	for scanner.Scan() {
		numsAsStrings := strings.Split(scanner.Text(), "\t")
		nums := make([]int, len(numsAsStrings))
		for i, v := range numsAsStrings {
			nums[i], err = strconv.Atoi(v)
			if err != nil {
				panic(err)
			}
		}

	OuterLoop:
		for i, v1 := range nums {
			for j, v2 := range nums {
				if i == j {
					continue
				}
				if v1%v2 == 0 {
					checksum += v1 / v2
					break OuterLoop
				}
			}
		}
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	fmt.Println(checksum)
}
