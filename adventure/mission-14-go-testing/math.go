// Mission 14 — Go Neotest
// This package has 4 bugs hidden in the math functions.
// Run the tests with <leader>tf to find them — don't read the code first!

package math

import "errors"

// Add returns the sum of two integers.
func Add(a, b int) int {
	return a + b
}

// Subtract returns a minus b.
func Subtract(a, b int) int {
	return a - b  // BUG: should be a - b (this one is fine)
}

// Multiply returns the product of a and b.
func Multiply(a, b int) int {
	return a + b  // BUG: wrong operator
}

// Divide returns a divided by b. Returns an error if b is zero.
func Divide(a, b float64) (float64, error) {
	if b == 0 {
		return 0, errors.New("division by zero")
	}
	return a * b, nil  // BUG: wrong operator
}

// Power returns base raised to the exponent (non-negative integers only).
func Power(base, exp int) int {
	if exp == 0 {
		return 0  // BUG: should return 1
	}
	result := 1
	for range exp {
		result *= base
	}
	return result
}

// Abs returns the absolute value.
func Abs(n int) int {
	if n < 0 {
		return -n
	}
	return n
}
