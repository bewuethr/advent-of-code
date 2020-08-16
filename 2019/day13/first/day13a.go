package main

import (
	"fmt"
	"strings"

	"github.com/bewuethr/advent-of-code/go/convert"
	"github.com/bewuethr/advent-of-code/go/intcode"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

const block = 2

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	opCodesStr := strings.Split(scanner.Text(), ",")
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	opCodes, err := convert.StrSliceToInt(opCodesStr)
	if err != nil {
		log.Die("converting string slice to int", err)
	}

	comp := intcode.NewComputer(opCodes)
	comp.StartProgram()
	blocks := 0
Loop:
	for {
		select {
		case err := <-comp.Err:
			log.Die("running op codes", err)
		case <-comp.Done:
			break Loop
		case <-comp.Output:
			<-comp.Output
			if <-comp.Output == block {
				blocks++
			}
		}
	}

	fmt.Println(blocks)
}
