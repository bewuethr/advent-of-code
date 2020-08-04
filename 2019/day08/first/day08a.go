package main

import (
	"fmt"

	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
)

const (
	w = 25
	h = 6
)

type (
	image     [][][]byte
	layerData map[byte]int
)

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	scanner.Scan()
	rawData := scanner.Text()
	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	var (
		img         image
		imgMetaData []layerData
	)
	for i := 0; i < len(rawData); {
		layer := make([][]byte, h)
		metaData := make(layerData)

		for y := 0; y < h; y++ {
			row := make([]byte, w)

			for x := 0; x < w; i, x = i+1, x+1 {
				row[x] = rawData[i]
				metaData[rawData[i]]++
			}

			layer[y] = row
		}

		img = append(img, layer)
		imgMetaData = append(imgMetaData, metaData)
	}

	var lowestIMD layerData
	lowest := imgMetaData[0]['0']
	for _, imd := range imgMetaData[1:] {
		if imd['0'] < lowest {
			lowest = imd['0']
			lowestIMD = imd
		}
	}

	fmt.Println(lowestIMD['1'] * lowestIMD['2'])
}
