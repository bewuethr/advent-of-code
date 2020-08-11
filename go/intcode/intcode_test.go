package intcode

import (
	"fmt"
	"reflect"
	"strings"
	"testing"

	"github.com/bewuethr/advent-of-code/go/convert"
)

func TestComputerDay02(t *testing.T) {
	var tests = []struct {
		program string
		wantIdx int
		wantVal int
	}{
		{"1,9,10,3,2,3,11,0,99,30,40,50", 0, 3500},
		{"1,0,0,0,99", 0, 2},
		{"2,3,0,3,99", 3, 6},
		{"2,4,4,5,99,0", 5, 9801},
		{"1,1,1,4,99,5,6,0,99", 0, 30},
		{"1,1,1,4,99,5,6,0,99", 4, 2},
	}

	for _, test := range tests {
		opcodesStr := strings.Split(test.program, ",")
		opcodes, err := convert.StrSliceToInt(opcodesStr)
		if err != nil {
			t.Fatalf("unable to convert string slice: %v\n", err)
		}

		c := NewComputer(opcodes)
		c.StartProgram()
		select {
		case err := <-c.Err:
			t.Fatalf("got %v, want nil\n", err)
		case <-c.Done:
			if c.Value(test.wantIdx) != test.wantVal {
				t.Errorf("c.RunProgram(%v), v(%d) == %d, want %d\n",
					test.program, test.wantIdx, c.Value(test.wantIdx), test.wantVal)
			}
		}
	}
}

func TestComputerDay05(t *testing.T) {
	largeInput := "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31," +
		"1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104," +
		"999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"

	var tests = []struct {
		program string
		input   int
		want    int
	}{
		{"3,0,4,0,99", 123, 123},           // input is output
		{"3,9,8,9,10,9,4,9,99,-1,8", 8, 1}, // pos.mode, input == 8, true
		{"3,9,8,9,10,9,4,9,99,-1,8", 9, 0}, // pos.mode, input == 8, false
		{"3,9,7,9,10,9,4,9,99,-1,8", 7, 1}, // pos.mode, input < 8, true
		{"3,9,7,9,10,9,4,9,99,-1,8", 8, 0}, // pos.mode, input < 8, false
		{"3,3,1108,-1,8,3,4,3,99", 8, 1},   // imm. mode, input == 8, true
		{"3,3,1108,-1,8,3,4,3,99", 9, 0},   // imm. mode, input == 8, false
		{"3,3,1107,-1,8,3,4,3,99", 7, 1},   // imm. mode, input < 8, true
		{"3,3,1107,-1,8,3,4,3,99", 8, 0},   // imm. mode, input < 8, false

		// Jump tests: output 0 if input is zero, 1 if non-zero
		{"3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", 0, 0}, // pos. mode, zero
		{"3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", 1, 1}, // pos. mode, non-zero
		{"3,3,1105,-1,9,1101,0,0,12,4,12,99,1", 0, 0},      // imm. mode, zero
		{"3,3,1105,-1,9,1101,0,0,12,4,12,99,1", 1, 1},      // imm. mode, non-zero

		// Compare value to 8, output 999/1000/1001 for less/equal/greater
		{largeInput, 7, 999},  // input < 8
		{largeInput, 8, 1000}, // input == 8
		{largeInput, 9, 1001}, // input > 8
	}

	for _, test := range tests {
		opcodesStr := strings.Split(test.program, ",")
		opcodes, err := convert.StrSliceToInt(opcodesStr)
		if err != nil {
			t.Fatalf("unable to convert string slice: %v\n", err)
		}

		c := NewComputer(opcodes)
		c.StartProgram()
		c.Input <- test.input
		var got int
	Loop:
		for {
			select {
			case v := <-c.Output:
				got = v
			case <-c.Done:
				break Loop
			case err := <-c.Err:
				t.Fatalf("input %v caused %v, want nil", test.program, err)
			}
		}

		if got != test.want {
			t.Errorf("program %v, input %v, got %v, want %v",
				test.program, test.input, got, test.want)
		}
	}
}

func TestComputerDay09(t *testing.T) {
	quine := "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
	expected, err := convert.StrSliceToInt(strings.Split(quine, ","))
	if err != nil {
		t.Fatalf("converting strings to ints: %v", err)
	}

	var tests = []struct {
		program string
		want    []int
	}{
		{quine, expected}, // program prints itself
		{"1102,34915192,34915192,7,4,7,99,0", []int{1219070632396864}}, // 16 digit number
		{"104,1125899906842624,99", []int{1125899906842624}},           // print large middle number
	}

	for _, test := range tests {
		opcodesStr := strings.Split(test.program, ",")
		opcodes, err := convert.StrSliceToInt(opcodesStr)
		if err != nil {
			t.Fatalf("unable to convert string slice: %v\n", err)
		}

		c := NewComputer(opcodes)
		c.StartProgram()
		var got []int
	Loop:
		for {
			select {
			case v := <-c.Output:
				got = append(got, v)
				fmt.Println(v)
			case <-c.Done:
				break Loop
			case err := <-c.Err:
				t.Fatalf("input %v caused %v, want nil", test.program, err)
			}
		}

		if !reflect.DeepEqual(got, test.want) {
			t.Errorf("program %v, got %v, want %v", test.program, got, test.want)
		}
	}
}
