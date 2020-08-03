// Package math provides math helper functions.
package math

// IntAbs returns the absolute value of n.
func IntAbs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}

// IntMax returns the larger of a and b.
func IntMax(a, b int) int {
	if a > b {
		return a
	}
	return b
}
