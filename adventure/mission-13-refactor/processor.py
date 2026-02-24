# Mission 13 — Multi-file Refactoring
# After renaming DataRecord → DataEntry in models.py,
# use <leader>cr on the import below and watch it propagate.

from models import DataRecord, make_record   # [RENAME] DataRecord here


def process_batch(raw: list[dict]) -> list[DataRecord]:   # [RENAME] type hint
    results: list[DataRecord] = []                         # [RENAME] type hint
    for item in raw:
        record = make_record(
            id=item["id"],
            payload=item.get("payload", ""),
            score=float(item.get("score", 0.0)),
        )
        if record.is_valid():
            results.append(record)
    return results


def filter_high_score(records: list[DataRecord], threshold: float = 0.8) -> list[DataRecord]:
    return [r for r in records if r.score >= threshold]
