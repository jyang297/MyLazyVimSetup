# ============================================================
# MISSION 6: Conditional Breakpoints
# ============================================================
# GOAL: Use conditional breakpoints to catch the exact moment
#       a computation goes wrong — without stopping 100 times.
#
# THE STORY:
#   A batch-processing function claims the total should be 2550,
#   but it keeps returning something else. There are 100 items
#   to process. You can't afford to step through all of them.
#
# TASKS:
#
#   TASK A — Pinpoint the bad item:
#     Set a conditional breakpoint on the line marked [CB-A]
#     Condition: `result < 0`
#     Run → the debugger stops ONLY when result goes negative.
#     Which index causes it?
#
#   TASK B — Catch the exact value:
#     Set a conditional breakpoint on the line marked [CB-B]
#     Condition: `cumulative > 1000`
#     Run → debugger stops the first time cumulative exceeds 1000.
#     What is `i` at that point?
#
#   TASK C — Find the first even-index anomaly:
#     Set a conditional breakpoint on the line marked [CB-C]
#     Condition: `i % 2 == 0 and item["value"] > 40`
#     Run → stops on the first even-index item with value > 40.
#
# HOW TO SET A CONDITIONAL BREAKPOINT:
#   1. Move cursor to the target line
#   2. Press `<leader>dC`
#   3. Enter the condition string
#   4. Press `<leader>dc` to run
#
# CHECKLIST:
#   [ ] Completed Task A — found the negative result at index _____
#   [ ] Completed Task B — cumulative crossed 1000 at index _____
#   [ ] Completed Task C — first even-index anomaly at index _____
#   [ ] Fixed the bug so total == 2550
# ============================================================
from __future__ import annotations

import random

random.seed(42)


def generate_batch(size: int) -> list[dict[str, int]]:
    items = []
    for i in range(size):
        # Most values are normal, but one item has a bug injected
        value = random.randint(1, 50)
        if i == 37:
            value = -999   # ← the injected bug
        items.append({"id": i, "value": value})
    return items


def process_batch(items: list[dict[str, int]]) -> int:
    cumulative = 0
    for i, item in enumerate(items):
        result = item["value"] * 2       # [CB-A]  conditional: result < 0
        cumulative += result             # [CB-B]  conditional: cumulative > 1000
        _ = i                            # [CB-C]  conditional: i % 2 == 0 and item["value"] > 40
    return cumulative


if __name__ == "__main__":
    batch = generate_batch(100)
    total = process_batch(batch)
    print(f"Total: {total}")
    print(f"Expected: 2550 (approx)")
    print(f"Match: {abs(total - 2550) < 500}")
