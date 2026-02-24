# ============================================================
# MISSION 4: Debugging with Breakpoints
# ============================================================
# GOAL: Find the bug using the debugger — NOT by reading the code.
#
# THE STORY:
#   This data pipeline is supposed to calculate a "weighted score"
#   for each student and then rank them. Something is wrong —
#   the rankings are scrambled. Use the debugger to find why.
#
# HOW TO START:
#   1. Press `<leader>db` on a suspicious line to set a breakpoint
#   2. Press `<leader>dc` to start the debugger
#   3. Press `<leader>dO` to step over lines
#   4. Press `<leader>di` to step INTO a function call
#   5. Watch the Variables panel on the left
#   6. Press `<leader>du` to toggle the DAP UI if it's not visible
#
# SPOILER-FREE HINT:
#   Start by setting a breakpoint inside `calculate_score`.
#   Watch what happens to `weight` on each call.
#
# CHECKLIST:
#   [ ] Found the bug using the debugger (no peeking at the hint below!)
#   [ ] Fixed the bug
#   [ ] Output shows students ranked: Charlie, Alice, Bob
# ============================================================
from __future__ import annotations


WEIGHTS = {"math": 0.5, "english": 0.3, "science": 0.2}

students = [
    {"name": "Alice",   "math": 88, "english": 72, "science": 95},
    {"name": "Bob",     "math": 60, "english": 85, "science": 70},
    {"name": "Charlie", "math": 95, "english": 90, "science": 88},
]


def calculate_score(student: dict[str, int | str]) -> float:
    total = 0.0
    weight = 0.0                     # ← set a breakpoint here
    for subject, w in WEIGHTS.items():
        grade = student[subject]     # type: ignore[literal-required]
        total += grade * weight      # BUG is somewhere around here
        weight = w                   # think carefully about the order
    return total


def rank_students(students: list[dict[str, int | str]]) -> list[str]:
    scored = [(s["name"], calculate_score(s)) for s in students]
    scored.sort(key=lambda x: x[1], reverse=True)
    return [name for name, _ in scored]


if __name__ == "__main__":
    ranking = rank_students(students)
    print("Ranking:", ranking)
    # Expected: ['Charlie', 'Alice', 'Bob']
    # Got something else? The debugger will show you why.
