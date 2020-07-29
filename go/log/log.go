// Package log provides logging functionality.
package log

import (
	"fmt"
	"os"
)

// Die prints msg and err, then exits.
func Die(msg string, err error) {
	fmt.Fprintf(os.Stderr, "%s: %v\n", msg, err)
	os.Exit(1)
}
