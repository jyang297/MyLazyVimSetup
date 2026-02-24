# ============================================================
# MISSION 10: Watch Mode — TDD Feedback Loop
# ============================================================
# GOAL: Experience real-time test feedback as you edit code.
#
# SETUP (do this first):
#   1. Split your screen: this file on the left, calculator.py right
#      Press `<C-w>v` to split, then `<leader>ff` to open calculator.py
#   2. Come back to this file
#   3. Press `<leader>tw` to enable watch mode
#   4. Now every save triggers a test run automatically!
#
# THE EXERCISE — work through these in order:
#
#   STEP 1: Press `<leader>tf` → all tests pass. Good baseline.
#
#   STEP 2: Break something in calculator.py:
#           Change `return a + b` to `return a - b`
#           Save calculator.py → watch this file go red instantly!
#
#   STEP 3: Fix it back → green again.
#
#   STEP 4: Uncomment the FAILING tests below one by one,
#           implement the missing functions in calculator.py,
#           and make them green.
#
# CHECKLIST:
#   [ ] Watch mode enabled, saw auto-run on save
#   [ ] Deliberately broke and fixed a function
#   [ ] Implemented `power` and made test_power pass
#   [ ] Implemented `is_prime` and made test_is_prime pass
#   [ ] Pressed `<leader>ts` to see the full test tree
# ============================================================

import pytest
from calculator import add, divide, is_prime, multiply, power, subtract


# ── Passing baseline ─────────────────────────────────────────

def test_add() -> None:
    assert add(2, 3) == 5
    assert add(-1, 1) == 0
    assert add(0, 0) == 0


def test_subtract() -> None:
    assert subtract(10, 3) == 7
    assert subtract(0, 5) == -5


def test_multiply() -> None:
    assert multiply(4, 5) == 20
    assert multiply(-2, 3) == -6


def test_divide() -> None:
    assert divide(10, 2) == 5.0
    assert divide(7, 2) == 3.5


def test_divide_by_zero() -> None:
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)


# ── Uncomment these one at a time ────────────────────────────

def test_power() -> None:
    assert power(2, 10) == 1024.0
    assert power(3, 3) == 27.0
    assert power(5, 0) == 1.0


def test_is_prime() -> None:
    assert is_prime(2) is True
    assert is_prime(3) is True
    assert is_prime(17) is True
    assert is_prime(1) is False
    assert is_prime(4) is False
    assert is_prime(100) is False


def test_is_prime_edge_cases() -> None:
    assert is_prime(0) is False
    assert is_prime(-5) is False
    assert is_prime(97) is True   # largest prime below 100
