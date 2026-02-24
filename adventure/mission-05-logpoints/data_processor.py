# ============================================================
# MISSION 5: Log Points — Debug Without Touching the Code
# ============================================================
# GOAL: Understand the data flow using ONLY log points.
#       You must NOT add any print() calls to this file.
#
# THE STORY:
#   An ML feature-engineering pipeline is producing unexpected
#   output. You need to trace the data through three stages
#   without modifying the source (imagine this is prod code).
#
# HOW TO USE LOG POINTS:
#   1. Position cursor on the target line
#   2. Press `<leader>dl`
#   3. Enter a message — use {variable} to evaluate expressions
#      e.g.  "stage=normalize, value={value}, result={result}"
#   4. Press `<leader>dc` to run — read the Debug Console output
#
# SUGGESTED LOG POINT LOCATIONS (try them all):
#   Line marked [LP-A]: log `raw={raw_value}, after_clip={value}`
#   Line marked [LP-B]: log `normalized={value}, mean={mean}`
#   Line marked [LP-C]: log `feature={name}, final={encoded}`
#   Line marked [LP-D]: log `batch size={len(batch)}, result={result}`
#
# CHECKLIST:
#   [ ] Set at least 3 log points
#   [ ] Read the console output while the program runs (no pausing!)
#   [ ] Answer: which feature has the highest encoded value?
#   [ ] Press `<leader>dL` to list all your log points
#   [ ] Press `<leader>dD` to clear them all when done
# ============================================================
from __future__ import annotations

import math


RAW_DATA = [
    {"age": 250, "income": 55000, "score": 0.82},   # age=250 is an outlier
    {"age": 34,  "income": 120000, "score": 0.91},
    {"age": 28,  "income": 42000, "score": 0.67},
    {"age": 45,  "income": 88000, "score": 0.75},
]


def clip(value: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, value))


def normalize(values: list[float]) -> list[float]:
    mean = sum(values) / len(values)
    std = math.sqrt(sum((v - mean) ** 2 for v in values) / len(values))
    if std == 0:
        return [0.0] * len(values)
    return [(v - mean) / std for v in values]


def stage_1_clip(records: list[dict[str, float]]) -> list[dict[str, float]]:
    """Clip outliers to sensible ranges."""
    out = []
    for rec in records:
        raw_value = rec["age"]                              # [LP-A] log here
        value = clip(raw_value, 18, 80)
        out.append({**rec, "age": value})
    return out


def stage_2_normalize(records: list[dict[str, float]]) -> list[dict[str, float]]:
    """Z-score normalize each numeric feature."""
    features = ["age", "income", "score"]
    columns = {f: [r[f] for r in records] for f in features}
    normed = {f: normalize(vals) for f, vals in columns.items()}
    result = []
    for i, rec in enumerate(records):
        mean = sum(columns["income"]) / len(columns["income"])  # [LP-B] log here
        value = normed["income"][i]
        result.append({f: normed[f][i] for f in features})
    return result


def stage_3_encode(records: list[dict[str, float]]) -> list[dict[str, float]]:
    """Combine features into a single encoded value per record."""
    encoded_records = []
    for rec in records:
        for name, value in rec.items():                     # [LP-C] log here
            encoded = value * 1.5 + 0.1
            _ = encoded  # used below
        total = sum(v * 1.5 + 0.1 for v in rec.values())
        encoded_records.append({"encoded": total})
    return encoded_records


def process_batch(batch: list[dict[str, float]]) -> list[dict[str, float]]:
    step1 = stage_1_clip(batch)
    step2 = stage_2_normalize(step1)
    result = stage_3_encode(step2)                          # [LP-D] log here
    return result


if __name__ == "__main__":
    output = process_batch(RAW_DATA)
    for i, rec in enumerate(output):
        print(f"Record {i}: encoded={rec['encoded']:.4f}")
