package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

type object struct {
	name     string
	distance int
	adjacent map[string]*object
}

const (
	startID  = "YOU"
	targetID = "SAN"
)

var orbitGraph = make(map[string][]string)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	for scanner.Scan() {
		orbit := strings.Split(scanner.Text(), ")")
		orbitGraph[orbit[0]] = append(orbitGraph[orbit[0]], orbit[1])
		orbitGraph[orbit[1]] = append(orbitGraph[orbit[1]], orbit[0])
	}

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	start := &object{
		name:     startID,
		distance: 0,
		adjacent: make(map[string]*object),
	}
	traverse(start)
}

func traverse(obj *object) {
	if obj.name == targetID {
		fmt.Println(obj.distance - 2)
		os.Exit(0)
	}

	for _, id := range orbitGraph[obj.name] {
		if _, ok := obj.adjacent[id]; ok {
			continue
		}
		childObj := &object{
			name:     id,
			distance: obj.distance + 1,
			adjacent: map[string]*object{obj.name: obj},
		}
		obj.adjacent[id] = childObj
		traverse(childObj)
	}
}
