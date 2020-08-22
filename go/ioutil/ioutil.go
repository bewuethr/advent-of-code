// Package ioutil provides functionality to read input files.
package ioutil

import (
	"bufio"
	"os"
)

// GetInputScanner returns a scanner for newline separated input in a file
// specified as a command line argument, or "../input" if none is specified.
func GetInputScanner() (*bufio.Scanner, error) {
	if len(os.Args) == 1 {
		os.Args = append(os.Args, "../input")
	}
	input, err := os.Open(os.Args[1])
	if err != nil {
		return nil, err
	}

	return bufio.NewScanner(input), nil
}
