# ============================================================
# MISSION 3: Testing with Neotest
# ============================================================
# GOAL: Run tests, see failures, fix them, use watch mode.
#
# HOW TO START:
#   Open this file in Neovim.
#   Press `<leader>ts`  → open test summary panel
#   Press `<leader>tf`  → run ALL tests in this file
#   Move cursor inside a test function and press `<leader>tt`
#                       → run only THAT test
#
# CHECKLIST:
#   [ ] Ran all tests with `<leader>tf` — spotted the failing ones
#   [ ] Fixed the broken tests until everything is green
#   [ ] Used `<leader>to` to read the failure output
#   [ ] Enabled watch mode with `<leader>tw`, edited a test, saw auto-run
#   [ ] Used `<leader>td` to debug a test with DAP
# ============================================================

from calculator import add, divide, factorial, multiply, subtract


# ✅ This one passes — use it as a reference
def test_add_positive() -> None:
    assert add(2, 3) == 5


# ✅ Passes
def test_subtract() -> None:
    assert subtract(10, 4) == 6


# ❌ BROKEN: wrong expected value — fix it
def test_multiply() -> None:
    assert multiply(3, 4) == 999   # what should this be?


# ❌ BROKEN: divide(10, 2) does NOT equal 6 — fix the expected value
def test_divide() -> None:
    assert divide(10, 2) == 6.0


# ✅ Passes
def test_divide_by_zero_raises() -> None:
    import pytest
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(5, 0)


# ❌ BROKEN: factorial(5) is not 100 — fix it
def test_factorial() -> None:
    assert factorial(5) == 100


# ✅ Edge case — passes
def test_factorial_zero() -> None:
    assert factorial(0) == 1


# ❌ BROKEN: should raise ValueError, but we're passing a valid input
def test_factorial_negative_raises() -> None:
    import pytest
    with pytest.raises(ValueError):
        factorial(5)   # 5 is NOT negative — change the argument


# ── Bonus: add your own tests below ──────────────────────────
# Try writing a test for: add(0, 0), multiply(0, 99), divide(7, 2)
