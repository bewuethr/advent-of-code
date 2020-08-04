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

type image [][][]byte

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

	var img image
	for i := 0; i < len(rawData); {
		layer := make([][]byte, h)

		for y := 0; y < h; y++ {
			row := make([]byte, w)

			for x := 0; x < w; i, x = i+1, x+1 {
				row[x] = rawData[i]
			}

			layer[y] = row
		}

		img = append(img, layer)
	}

	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
		Loop:
			for z := 0; z < len(img); z++ {
				switch img[z][y][x] {
				case '2':
					continue
				case '0':
					fmt.Print(" ")
					break Loop
				case '1':
					fmt.Print("█")
					break Loop
				default:
					panic(fmt.Sprintf("illegal pixel %c", img[z][y][x]))
				}
			}
		}
		fmt.Printf("\n")
	}
}
