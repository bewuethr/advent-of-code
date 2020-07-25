package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	scanner, err := getInputScanner()
	if err != nil {
		die("getting scanner", err)
	}

	scanner.Scan()
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		die("reading input", err)
	}

	initOpCodes, err := strSliceToInt(opCodesStr)
	if err != nil {
		die("converting string slice to int", err)
	}

	const target = 19690720

	for noun := 0; noun < 100; noun++ {
		for verb := 0; verb < 100; verb++ {
			opCodes := make([]int, len(initOpCodes))
			copy(opCodes, initOpCodes)
			opCodes[1], opCodes[2] = noun, verb

			opCodes, err = runProgram(opCodes)
			if err != nil {
				die("running op codes", err)
			}

			if opCodes[0] == target {
				fmt.Println(100*noun + verb)
				os.Exit(0)
			}
		}
	}
}

func runProgram(codes []int) ([]int, error) {
	const (
		add  = 1
		mult = 2
		halt = 99
	)

	instrPtr := 0
	for {
		switch codes[instrPtr] {
		case halt:
			return codes, nil

		case add:
			codes[codes[instrPtr+3]] = codes[codes[instrPtr+1]] + codes[codes[instrPtr+2]]

		case mult:
			codes[codes[instrPtr+3]] = codes[codes[instrPtr+1]] * codes[codes[instrPtr+2]]

		default:
			return nil, fmt.Errorf("illegal opcode %d", codes[instrPtr])
		}

		instrPtr += 4
	}
}

func strSliceToInt(strSlice []string) ([]int, error) {
	intSlice := make([]int, len(strSlice))
	for i, s := range strSlice {
		val, err := strconv.Atoi(s)
		if err != nil {
			return nil, err
		}
		intSlice[i] = val
	}

	return intSlice, nil
}

func getInputScanner() (*bufio.Scanner, error) {
	if len(os.Args) == 1 {
		os.Args = append(os.Args, "input")
	}
	input, err := os.Open(os.Args[1])
	if err != nil {
		return nil, err
	}

	return bufio.NewScanner(input), nil
}

func die(msg string, err error) {
	fmt.Fprintf(os.Stderr, "%s: %v\n", msg, err)
	os.Exit(1)
}
