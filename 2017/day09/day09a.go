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

	regexps := []*regexp.Regexp{
		regexp.MustCompile("!."),
		regexp.MustCompile("<.*?>"),
	}
	for _, re := range regexps {
		stream = re.ReplaceAllLiteralString(stream, "")
	}

	total, score := 0, 1
	for _, ch := range stream {
		switch ch {
		case '{':
			total += score
			score++
		case '}':
			score--
		}
	}
	fmt.Println(total)
}
