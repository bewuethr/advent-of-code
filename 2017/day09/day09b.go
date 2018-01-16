package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"
)

func main() {
	if len(os.Args) == 1 {
		log.Fatal("Filename not specified")
	}
	input, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}

	stream := strings.TrimRight(string(input), "\n")

	re1 := regexp.MustCompile("!.")
	re2 := regexp.MustCompile("<.*?>")

	// Remove escapes
	stream = re1.ReplaceAllLiteralString(stream, "")

	// Get all garbage sequences
	garbage := re2.FindAllString(stream, -1)

	// Length includes two angle brackets each
	totalLen := 0
	for _, seq := range garbage {
		totalLen += len(seq) - 2
	}

	fmt.Println(totalLen)
}
