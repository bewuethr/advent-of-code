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

		min, max := nums[0], nums[0]
		for _, v := range nums {
			if v < min {
				min = v
			}
			if v > max {
				max = v
			}
		}
		checksum += max - min
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	fmt.Println(checksum)
}
