package main

import (
	"fmt"

	"github.com/bewuethr/advent-of-code/go/grid"
	"github.com/bewuethr/advent-of-code/go/ioutil"
	"github.com/bewuethr/advent-of-code/go/log"
	"github.com/bewuethr/advent-of-code/go/math"
)

type moon struct {
	pos grid.Vec3
	vel grid.Vec3
}

func main() {
	scanner, err := ioutil.GetInputScanner()
	if err != nil {
		log.Die("getting scanner", err)
	}

	var moons []moon

	for scanner.Scan() {
		var x, y, z int
		fmt.Sscanf(scanner.Text(), "<x=%d, y=%d, z=%d>", &x, &y, &z)
		moons = append(moons, moon{pos: grid.NewVec3(x, y, z)})
	}

	if err := scanner.Err(); err != nil {
		log.Die("reading input", err)
	}

	for i := 0; i < 1000; i++ {
		for j := 0; j < len(moons)-1; j++ {
			for k := j + 1; k < len(moons); k++ {
				dvj, dvk := getAccel(moons[j].pos, moons[k].pos)
				moons[j].vel = moons[j].vel.Add(dvj)
				moons[k].vel = moons[k].vel.Add(dvk)
			}
		}
		for i, moon := range moons {
			moons[i].pos = moon.pos.Add(moon.vel)
		}
	}

	eKinTot := 0
	for _, moon := range moons {
		eKinTot += getEKin(moon)
	}
	fmt.Println(eKinTot)
}

func getAccel(v1, v2 grid.Vec3) (grid.Vec3, grid.Vec3) {
	x1, x2 := getComponent(v1.X(), v2.X())
	y1, y2 := getComponent(v1.Y(), v2.Y())
	z1, z2 := getComponent(v1.Z(), v2.Z())
	return grid.NewVec3(x1, y1, z1), grid.NewVec3(x2, y2, z2)
}

func getComponent(n1, n2 int) (int, int) {
	switch {
	case n1 < n2:
		return 1, -1
	case n1 == n2:
		return 0, 0
	case n1 > n2:
		return -1, 1
	default:
		panic("getComponent: this never happens")
	}
}

func getEKin(m moon) int {
	return (math.IntAbs(m.pos.X()) + math.IntAbs(m.pos.Y()) + math.IntAbs(m.pos.Z())) *
		(math.IntAbs(m.vel.X()) + math.IntAbs(m.vel.Y()) + math.IntAbs(m.vel.Z()))
}
