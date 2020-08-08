package math

import (
	"fmt"
	"strings"
	"testing"
)

func TestFactorial(t *testing.T) {
	var tests = []struct {
		in, want int
	}{
		{0, 1},
		{1, 1},
		{2, 2},
		{3, 6},
		{4, 24},
		{5, 120},
		{6, 720},
		{7, 5040},
	}

	for _, test := range tests {
		if got := Factorial(test.in); got != test.want {
			t.Errorf("Factorial(%d) = %d, want %d", test.in, got, test.want)
		}
	}
}

func TestIntPermutations(t *testing.T) {
	var inputs = [][]int{
		{0, 1},
		{0, 1, 2},
		{0, 1, 2, 3},
		{0, 1, 2, 3, 4},
		{0, 1, 2, 3, 4, 5},
		{0, 1, 2, 3, 4, 5, 6},
		{5, 4, 3, 2, 1, 0},
	}

	for _, input := range inputs {
		perms := IntPermutations(input)

		if len(perms) != Factorial(len(input)) {
			t.Errorf("got %d permutations, want %d", len(perms), Factorial(len(input)))
		}

		uniquePerms := make(map[string]bool)
		for _, p := range perms {
			if len(p) != len(input) {
				t.Errorf("permutation %v has length %d, want %d", p, len(p), len(input))
			}
			key := strings.Join(strings.Fields(fmt.Sprint(p)), "-")
			if uniquePerms[key] {
				t.Errorf("permutation %v appears more than once", p)
			}
			uniquePerms[key] = true
		}
	}
}

func TestGCD(t *testing.T) {
	var tests = []struct {
		a, b int
		want int
	}{
		{60, 24, 12},
		{24, 60, 12},
		{60, -24, 12},
		{-60, -24, 12},
		{3, 0, 3},
		{0, 3, 3},
		{-3, 0, 3},
	}

	for _, test := range tests {
		if got := GCD(test.a, test.b); got != test.want {
			t.Errorf("GCD(%d, %d) = %d, want %d\n", test.a, test.b, got, test.want)
		}
	}
}

func TestGCDPanic(t *testing.T) {
	defer func() {
		if r := recover(); r == nil {
			t.Errorf("expected panic, did not get one")
		}
	}()

	GCD(0, 0)
}
