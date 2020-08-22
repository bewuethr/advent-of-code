package grid

// Vec3 represents a 3d vector with integer components.
type Vec3 struct {
	x, y, z int
}

// Special 3d vectors
var (
	Origin3 = Vec3{0, 0, 0} // Origin of the grid
	Ux3     = Vec3{1, 0, 0} // x unit vector
	Uy3     = Vec3{0, 1, 0} // y unit vector
	Uz3     = Vec3{0, 0, 1} // z unit vector
)

// NewVec3 creates a new vector with components x, y, and z.
func NewVec3(x, y, z int) Vec3 {
	return Vec3{
		x: x,
		y: y,
		z: z,
	}
}

// X returns the x component of v.
func (v Vec3) X() int {
	return v.x
}

// Y returns the y component of v.
func (v Vec3) Y() int {
	return v.y
}

// Z returns the z component of v.
func (v Vec3) Z() int {
	return v.z
}

// Add returns the sum of vectors v and w.
func (v Vec3) Add(w Vec3) Vec3 {
	return NewVec3(v.x+w.x, v.y+w.y, v.z+w.z)
}

// Subtract returns the difference of vectors v and w.
func (v Vec3) Subtract(w Vec3) Vec3 {
	return NewVec3(v.x-w.x, v.y-w.y, v.z-w.z)
}
