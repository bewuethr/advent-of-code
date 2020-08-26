package main

import (
	"bufio"
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

type node string

// quantities maps the name of a chemical to the smallest quantity it can be
// produced in.
type quantities map[node]int

type edge struct {
	from, to node
	weight   int
}

type graph map[node][]edge

const (
	fuel node = "FUEL"
	ore  node = "ORE"
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	graph, amounts, err := getGraph(scanner)
	if err != nil {
		log.Die("getting graph", err)
	}

	sorted, err := topoSort(graph)
	if err != nil {
		log.Die("sorting graph", err)
	}

	required := quantities{fuel: 1}
	for _, c := range sorted {
		if c == ore {
			break
		}
		for q := 0; q < required[c]; q += amounts[c] {
			for _, e := range graph[c] {
				required[e.to] += e.weight
			}
		}
	}

	fmt.Println(required[ore])
}

func getGraph(scanner *bufio.Scanner) (graph, quantities, error) {
	quantities := make(quantities)
	graph := make(graph)

	for scanner.Scan() {
		inputs, outputs, err := parseLine(scanner.Text())
		if err != nil {
			return nil, nil, err
		}

		// Loop over the one output key/value pair
		for outKey, outVal := range outputs {
			outChem := node(outKey)
			quantities[outChem] = outVal

			for inKey, inVal := range inputs {
				inChem := node(inKey)
				graph[outChem] = append(graph[outChem], edge{
					from:   outKey,
					to:     inChem,
					weight: inVal,
				})
			}
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, nil, err
	}

	return graph, quantities, nil
}

func parseLine(s string) (inputs, outputs quantities, err error) {
	fields := strings.Split(s, " => ")
	ins := strings.Split(fields[0], ", ")
	outs := strings.Fields(fields[1])

	inputs, outputs = make(quantities), make(quantities)
	for _, inPair := range ins {
		f := strings.Fields(inPair)
		name := node(f[1])
		q, err := strconv.Atoi(f[0])
		if err != nil {
			return nil, nil, err
		}
		inputs[name] = q
	}

	name := node(outs[1])
	q, err := strconv.Atoi(outs[0])
	if err != nil {
		return nil, nil, err
	}
	outputs[name] = q

	return inputs, outputs, nil
}

func topoSort(g graph) ([]node, error) {
	// Copy g because the graph gets modified
	gg := make(graph, len(g))
	for k, v := range g {
		gg[k] = append([]edge(nil), v...)
	}

	var sorted []node
	noIncoming := []node{fuel}

	for len(noIncoming) > 0 {
		var n node
		n, noIncoming = noIncoming[0], noIncoming[1:]
		// fmt.Println("Looking at node", n)
		sorted = append(sorted, n)
		for _, e := range gg[n] {
			// fmt.Println("Looking at edge", e)
			if len(getIncoming(gg, e.to)) == 1 {
				// fmt.Printf("Appending %v to noIncoming\n", e.to)
				noIncoming = append(noIncoming, e.to)
			}
		}
		delete(gg, n)
	}

	if len(gg) > 0 {
		return nil, errors.New("graph has at least one cycle")
	}

	return sorted, nil
}

func getIncoming(g graph, n node) []edge {
	var incoming []edge
	for _, outgoing := range g {
		for _, e := range outgoing {
			if e.to == n {
				incoming = append(incoming, e)
			}
		}
	}
	return incoming
}
