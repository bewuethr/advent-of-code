// Package grid provides helpers to operate on a grid.
package grid

import (
	"math"

	aocmath "github.com/bewuethr/advent-of-code/go/math"
)

// Vec2 represents a 2d vector with integer components.
type Vec2 struct {
	x, y int
}

// Special 2d vectors
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

// X returns the x component of v.
func (v Vec2) X() int {
	return v.x
}

// Y returns the y component of v.
func (v Vec2) Y() int {
	return v.y
}

// Norm returns the length of v.
func (v Vec2) Norm() float64 {
	return math.Sqrt(math.Pow(float64(v.x), 2) + math.Pow(float64(v.y), 2))
}

// Azimuth returns the polar angle of v, normalized to the range [0, 2π).
func (v Vec2) Azimuth() float64 {
	return math.Mod(math.Atan2(float64(v.y), float64(v.x))+math.Pi*2, math.Pi*2)
}

// Add returns the sum of vectors v and w.
func (v Vec2) Add(w Vec2) Vec2 {
	return NewVec2(v.x+w.x, v.y+w.y)
}

// Subtract returns the difference of vectors v and w.
func (v Vec2) Subtract(w Vec2) Vec2 {
	return NewVec2(v.x-w.x, v.y-w.y)
}

// ScalarMult is the result of multiplying v by n.
func (v Vec2) ScalarMult(n int) Vec2 {
	return NewVec2(v.x*n, v.y*n)
}

// ScalarDiv reuturns a Vec2 with components of v divided by n.
func (v Vec2) ScalarDiv(n int) Vec2 {
	return NewVec2(v.x/n, v.y/n)
}

// ManhattanDistance is the Manhattan distance between v and w.
func (v Vec2) ManhattanDistance(w Vec2) int {
	return aocmath.IntAbs(v.x-w.x) + aocmath.IntAbs(v.y-w.y)
}

// ManhattanDistanceOrigin is the Manhattan distance from v to the origin.
func (v Vec2) ManhattanDistanceOrigin() int {
	return v.ManhattanDistance(Origin)
}

// RotCCW returns v rotated counterclockwise by 90 degrees (assuming the y axis
// pointing down).
func (v Vec2) RotCCW() Vec2 {
	return NewVec2(v.y, -v.x)
}

// RotCW returns v rotated clockwise by 90 degrees (assuming the y axis pointing
// down).
func (v Vec2) RotCW() Vec2 {
	return NewVec2(-v.y, v.x)
}
