package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
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

	lengths := make([]int, len(input)-1)

	for i, v := range input[:len(input)-1] {
		lengths[i] = int(v)
	}
	lengths = append(lengths, 17, 31, 73, 47, 23)

	list := make([]int, 256)
	for i := range list {
		list[i] = i
	}

	var curIdx, skip int
	for n := 0; n < 64; n++ {
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
	}

	dense := make([]string, 16)
	for i := 0; i < 16; i++ {
		val := list[16*i]
		for j := 16*i + 1; j < 16*i+16; j++ {
			val ^= list[j]
		}
		dense[i] = fmt.Sprintf("%02x", val)
	}

	fmt.Println(strings.Join(dense, ""))
}
