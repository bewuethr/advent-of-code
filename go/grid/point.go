package grid

import (
	"fmt"

	"github.com/bewuethr/advent-of-code/go/math"
)

// Point represents a point in a 2-D cartesian integer grid.
type Point struct {
	x, y int
}

// NewPoint creates a new point at coordinates x/y.
func NewPoint(x, y int) *Point {
	return &Point{
		x: x,
		y: y,
	}
}

// Copy returns a copy of p.
func (p *Point) Copy() *Point {
	return NewPoint(p.x, p.y)
}

// Direction is the type for grid directions.
type Direction int

// Grid directions
const (
	Up = Direction(iota + 1)
	Right
	Down
	Left
)

// Move changes the coordinates of p in direction dir by distance dist.
func (p *Point) Move(dir Direction, dist int) error {
	switch dir {
	case Up:
		p.y -= dist
	case Right:
		p.x += dist
	case Down:
		p.y += dist
	case Left:
		p.x -= dist
	default:
		return fmt.Errorf("grid.Point.Move: illegal direction %v", dir)
	}

	return nil
}

// ManhattanDistance is the Manhattan distance from p to the origin.
func (p *Point) ManhattanDistance() int {
	return math.IntAbs(p.x) + math.IntAbs(p.y)
}
