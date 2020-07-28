package math

// IntAbs returns the absolute value of n.
func IntAbs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}
