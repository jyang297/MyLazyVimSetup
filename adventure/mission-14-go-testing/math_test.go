// Mission 14 — Go Neotest
// Run with: <leader>tf  (run all tests in file)
//           <leader>tt  (run test under cursor)
//           <leader>to  (see test output)
//           <leader>ts  (test summary panel)
//
// All tests below are CORRECT — the bugs are in math.go.
// Use neotest to find which functions fail, then fix math.go.

package math

import (
	"math/rand"
	"testing"
)

func TestAdd(t *testing.T) {
	cases := []struct {
		a, b, want int
	}{
		{1, 2, 3},
		{0, 0, 0},
		{-1, 1, 0},
		{100, -50, 50},
	}
	for _, c := range cases {
		got := Add(c.a, c.b)
		if got != c.want {
			t.Errorf("Add(%d, %d) = %d, want %d", c.a, c.b, got, c.want)
		}
	}
}

func TestSubtract(t *testing.T) {
	cases := []struct {
		a, b, want int
	}{
		{5, 3, 2},
		{0, 0, 0},
		{-3, -1, -2},
	}
	for _, c := range cases {
		got := Subtract(c.a, c.b)
		if got != c.want {
			t.Errorf("Subtract(%d, %d) = %d, want %d", c.a, c.b, got, c.want)
		}
	}
}

func TestMultiply(t *testing.T) {
	cases := []struct {
		a, b, want int
	}{
		{3, 4, 12},
		{0, 100, 0},
		{-2, 5, -10},
		{7, 7, 49},
	}
	for _, c := range cases {
		got := Multiply(c.a, c.b)
		if got != c.want {
			t.Errorf("Multiply(%d, %d) = %d, want %d", c.a, c.b, got, c.want)
		}
	}
}

func TestDivide(t *testing.T) {
	got, err := Divide(10, 2)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if got != 5.0 {
		t.Errorf("Divide(10, 2) = %f, want 5.0", got)
	}

	_, err = Divide(1, 0)
	if err == nil {
		t.Error("Divide(1, 0) should return an error")
	}
}

func TestPower(t *testing.T) {
	cases := []struct {
		base, exp, want int
	}{
		{2, 0, 1},
		{2, 1, 2},
		{2, 10, 1024},
		{3, 3, 27},
		{5, 0, 1},
	}
	for _, c := range cases {
		got := Power(c.base, c.exp)
		if got != c.want {
			t.Errorf("Power(%d, %d) = %d, want %d", c.base, c.exp, got, c.want)
		}
	}
}

func TestAbs(t *testing.T) {
	for range 20 {
		n := rand.Intn(1000) - 500
		got := Abs(n)
		if got < 0 {
			t.Errorf("Abs(%d) = %d, should be non-negative", n, got)
		}
	}
}
