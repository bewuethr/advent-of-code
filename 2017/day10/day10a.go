package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
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

	splits := strings.Split(strings.TrimRight(string(input), "\n"), ",")
	lengths := make([]int, len(splits))
	for i, v := range splits {
		lengths[i], _ = strconv.Atoi(v)
	}

	list := make([]int, 256)
	for i := range list {
		list[i] = i
	}

	curIdx, skip := 0, 0
	for _, l := range lengths {
		// Create reverse list
		revList := make([]int, l)
		for i := 0; i < l; i++ {
			tarIdx := l - i - 1
			srcIdx := (curIdx + i) % len(list)
			revList[tarIdx] = list[srcIdx]
		}

		// Write reverse list back to original list
		for i, v := range revList {
			list[(curIdx+i)%len(list)] = v
		}

		curIdx += l + skip
		curIdx %= len(list)
		skip++
	}

	fmt.Println(list[0] * list[1])
}
