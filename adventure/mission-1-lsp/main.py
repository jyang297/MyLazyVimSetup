# ============================================================
# MISSION 1: LSP & Strict Typing
# ============================================================
# GOAL: Fix every type error Pyright flags, then explore LSP.
#
# HOW TO START:
#   Open this file — you should see red squiggles immediately.
#   Press `gl` on any red line to read the error.
#   Press `K` on any symbol to see its docs / type.
#   Press `gd` on a function call to jump to its definition.
#   Press `<leader>ca` on an underlined symbol for quick fixes.
#
# CHECKLIST (mark with x when done):
#   [ ] All type errors fixed (no more red squiggles)
#   [ ] Used `gd` to jump to a definition
#   [ ] Used `K` to hover a symbol
#   [ ] Used `<leader>uh` to toggle inlay hints on/off
# ============================================================


# ❌ PROBLEM 1: missing parameter types and return type
def add(a, b):
    return a + b


# ❌ PROBLEM 2: return type mismatch — says int, returns str
def greet(name: str) -> int:
    return f"Hello, {name}!"


# ❌ PROBLEM 3: variable assigned wrong type
def get_score() -> float:
    score: int = 9.5       # int can't hold 9.5
    return score


# ❌ PROBLEM 4: possible None not guarded
def find_user(users: list[str], target: str) -> str:
    result = next((u for u in users if u == target), None)
    return result.upper()  # result might be None!


# ❌ PROBLEM 5: unused import (ruff will flag this)
import os  # noqa — try removing the noqa and saving to see ruff lint

# ── Try these after fixing everything ──────────────────────
# 1. Put cursor on `add` below and press `gd`  → jump to definition
# 2. Put cursor on `str` in any signature, press `K` → hover docs
# 3. Press `<leader>xx` → open Trouble panel to see all diagnostics at once
result = add(1, 2)
greeting = greet("world")
score = get_score()
user = find_user(["alice", "bob"], "alice")
