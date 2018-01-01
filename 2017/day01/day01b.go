package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
)

func main() {
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		panic(err)
	}

	s := strings.TrimRight(string(input), "\n")

	var sum int

	len := len(s)

	for i, r := range s {
		if string(r) == string(s[(i+len/2)%len]) {
			if num, err := strconv.Atoi(string(r)); err == nil {
				sum += num
			}
		}
	}

	fmt.Println(sum)
}
