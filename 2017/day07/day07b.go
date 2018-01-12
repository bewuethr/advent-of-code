package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"regexp"
	"strconv"
	"strings"
)

type progProps struct {
	weight   int
	subprogs map[string]int
}

type badWeight struct {
	weight int
	diff   int
}

func findSubWeights(p map[string]progProps, r string) int {
	weight := p[r].weight
	for subprog := range p[r].subprogs {
		subweight := findSubWeights(p, subprog)
		p[r].subprogs[subprog] = subweight
		weight += subweight
	}
	return weight
}

func oddOneOut(m map[string]int) (string, int) {
	weightCount := make(map[int]int)

	// Count frequency of weights
	for _, v := range m {
		weightCount[v]++
	}

	// Identify weight that occurs only once
	var outVal int
	for k, v := range weightCount {
		if v == 1 {
			outVal = k
			break
		}
	}

	// Return if all subtowers are balanced
	if outVal == 0 {
		sum := 0
		for k, v := range weightCount {
			sum += k * v
		}
		return "", sum
	}

	// Find weight of balanced towers
	var bWeight int
	for _, v := range m {
		if v != outVal {
			bWeight = v
			break
		}
	}

	// Find and return name of odd one out
	for k, v := range m {
		if v == outVal {
			return k, bWeight
		}
	}

	// We should never get here
	return "", -1
}

func main() {
	if len(os.Args) == 1 {
		log.Fatal("Filename not specified")
	}
	f, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	// Get root: result from first part
	out, err := exec.Command("go", "run", "day07a.go", os.Args[1]).Output()
	if err != nil {
		log.Fatal(err)
	}

	re := regexp.MustCompile("[[:alnum:]]+")
	programs := make(map[string]progProps)

	scanner := bufio.NewScanner(f)

	for scanner.Scan() {
		words := re.FindAllString(scanner.Text(), -1)
		weight, err := strconv.Atoi(words[1])
		if err != nil {
			log.Fatal(err)
		}
		subProgMap := make(map[string]int)
		for _, word := range words[2:] {
			subProgMap[word] = 0
		}
		programs[words[0]] = progProps{
			weight:   weight,
			subprogs: subProgMap,
		}
	}
	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "Reading from file:", err)
	}

	root := strings.TrimRight(string(out), "\n")
	fmt.Println("Name of root program is", root)
	findSubWeights(programs, root)

	// Find weight to correct
	weights := []badWeight{badWeight{programs[root].weight, 0}}
	for cur, diff := root, 0; cur != ""; {
		cur, diff = oddOneOut(programs[cur].subprogs)
		weights = append(weights, badWeight{programs[cur].weight, diff})
	}
	diff := weights[len(weights)-2].weight
	diff -= (weights[len(weights)-1].diff + weights[len(weights)-2].weight - weights[len(weights)-2].diff)
	fmt.Println(diff)
}
