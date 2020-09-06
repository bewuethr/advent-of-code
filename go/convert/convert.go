// Package convert provides conversion helpers.
package convert

import "strconv"

// StrSliceToInt converts a slice of strings to ints; if any of the strings
// cannot be converted to an int, it returns an error.
func StrSliceToInt(strSlice []string) ([]int, error) {
	intSlice := make([]int, len(strSlice))
	for i, s := range strSlice {
		val, err := strconv.Atoi(s)
		if err != nil {
			return nil, err
		}
		intSlice[i] = val
	}

	return intSlice, nil
}

// IntSliceToStr converts a slice of ints to strings.
func IntSliceToStr(intSlice []int) []string {
	strSlice := make([]string, len(intSlice))
	for i, n := range intSlice {
		strSlice[i] = strconv.Itoa(n)
	}

	return strSlice
}
