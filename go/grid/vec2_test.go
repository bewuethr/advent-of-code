package grid

import (
	"testing"
)

func TestAzimuth(t *testing.T) {
	var vecs = []Vec2{
		NewVec2(1, 0),
		NewVec2(0, 1),
		NewVec2(-3, 0),
		NewVec2(0, -2),
	}

	var angles []float64
	for _, v := range vecs {
		angles = append(angles, v.Azimuth())
	}

	for i := 0; i < len(angles)-1; i++ {
		if angles[i] > angles[i+1] {
			t.Errorf("angle for %+v is larger than for %+v, expected smaller", vecs[i], vecs[i+1])
		}
	}
}
