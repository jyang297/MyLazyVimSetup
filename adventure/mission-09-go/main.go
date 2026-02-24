// ============================================================
// MISSION 9: Go with Strict Static Analysis
// ============================================================
// GOAL: Fix every warning/error gopls and golangci-lint report.
//
// HOW TO START:
//   Open this file — diagnostics appear in the gutter.
//   Press `gl`          → read the diagnostic under cursor
//   Press `K`           → hover symbol for docs + type info
//   Press `<leader>ca`  → code actions (add import, fix, etc.)
//   Save (`:w`)         → goimports auto-adds/removes imports,
//                         gofumpt formats the code
//
// CHECKLIST:
//   [ ] All diagnostics fixed (no red gutter signs)
//   [ ] Removed the unused import by saving — goimports did it
//   [ ] Used `gd` to jump to a function definition
//   [ ] Saw inlay hints on function calls
// ============================================================
package main

import (
	"errors"
	"fmt"
	"math"
	"strings" // ❌ PROBLEM 1: imported but never used — just save to fix
)

// ❌ PROBLEM 2: unusedparams — `ctx` is never used inside the function
func fetchUser(ctx interface{}, id int) (string, error) {
	if id <= 0 {
		return "", errors.New("id must be positive")
	}
	return fmt.Sprintf("user_%d", id), nil
}

// ❌ PROBLEM 3: unusedwrite — `result` is written but never read
func computeArea(radius float64) float64 {
	result := math.Pi * radius * radius
	result = 0 // overwritten without ever reading the first value
	return math.Pi * radius * radius
}

// ❌ PROBLEM 4: nilness — dereferencing a pointer that may be nil
func printName(name *string) {
	fmt.Println(*name) // name could be nil!
}

// ❌ PROBLEM 5: useany — function parameter typed as `interface{}`
// gopls suggests using `any` (Go 1.18+) or a concrete type
func process(data interface{}) string {
	return fmt.Sprintf("%v", data)
}

// ❌ PROBLEM 6: variable shadowing — inner `err` shadows outer `err`
func riskyOperation() error {
	err := doStep1()
	if err != nil {
		return err
	}
	{
		err := doStep2() // shadows outer err — use `=` not `:=`
		if err != nil {
			return err
		}
	}
	return nil
}

// Helpers — do not edit
func doStep1() error { return nil }
func doStep2() error { return nil }

func main() {
	// After fixing fetchUser, notice goimports removes the unused `strings` import
	_ = strings.ToUpper // remove this line once you understand the import issue

	user, err := fetchUser(nil, 1)
	if err != nil {
		fmt.Println("error:", err)
		return
	}
	fmt.Println(user)

	area := computeArea(5.0)
	fmt.Printf("area = %.2f\n", area)

	name := "Alice"
	printName(&name)
	printName(nil) // ← this will panic — fix printName to guard against nil

	fmt.Println(process(42))
}
