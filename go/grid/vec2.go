package grid

import (
	"github.com/bewuethr/advent-of-code/go/math"
)

// Vec2 represents a 2d vector with integer components.
type Vec2 struct {
	x, y int
}

// Special vectors
var (
	Origin = Vec2{0, 0} // Origin of the grid
	Ux     = Vec2{1, 0} // Horizontal unit vector
	Uy     = Vec2{0, 1} // Vertical unit vector
)

// NewVec2 creates a new vector with components x and y.
func NewVec2(x, y int) Vec2 {
	return Vec2{
		x: x,
		y: y,
	}
}

// Add returns the sum of vectors v and w.
func (v Vec2) Add(w Vec2) Vec2 {
	return NewVec2(v.x+w.x, v.y+w.y)
}

// ScalarMult is the result of multiplying v by n.
func (v Vec2) ScalarMult(n int) Vec2 {
	return NewVec2(v.x*n, v.y*n)
}

// ManhattanDistance is the Manhattan distance between v and w.
func (v Vec2) ManhattanDistance(w Vec2) int {
	return math.IntAbs(v.x-w.x) + math.IntAbs(v.y-w.y)
}

// ManhattanDistanceOrigin is the Manhattan distance from v to the origin.
func (v Vec2) ManhattanDistanceOrigin() int {
	return v.ManhattanDistance(Origin)
}
