package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

var registers map[string]int

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

	registers = make(map[string]int)
	max := 0

	for scanner.Scan() {
		words := strings.Split(scanner.Text(), " ")
		reg1, op1, reg2, op2 := words[0], words[1], words[4], words[5]
		amt1, _ := strconv.Atoi(words[2])
		amt2, _ := strconv.Atoi(words[6])

		condition := false
		switch op2 {
		case "<":
			condition = registers[reg2] < amt2
		case "<=":
			condition = registers[reg2] <= amt2
		case "==":
			condition = registers[reg2] == amt2
		case ">":
			condition = registers[reg2] > amt2
		case ">=":
			condition = registers[reg2] >= amt2
		case "!=":
			condition = registers[reg2] != amt2
		default:
			log.Fatal("Invalid operator:", op2)
		}

		var sign int
		if op1 == "inc" {
			sign = 1
		} else {
			sign = -1
		}

		if condition {
			registers[reg1] += sign * amt1
		}

		if registers[reg1] > max {
			max = registers[reg1]
		}
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	fmt.Println(max)
}
