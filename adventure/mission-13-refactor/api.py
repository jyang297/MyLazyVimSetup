# Mission 13 — Multi-file Refactoring
# This file also uses DataRecord — rename propagates here too.

from models import DataRecord           # [RENAME] import
from processor import process_batch, filter_high_score

import json


def handle_request(body: str) -> dict:
    raw: list[dict] = json.loads(body)
    records: list[DataRecord] = process_batch(raw)    # [RENAME] type hint
    top: list[DataRecord] = filter_high_score(records)
    return {
        "total": len(records),
        "top_count": len(top),
        "top_ids": [r.id for r in top],
    }


def serialize_record(record: DataRecord) -> dict:     # [RENAME] parameter type
    return {
        "id": record.id,
        "payload": record.payload,
        "score": record.score,
        "valid": record.is_valid(),
    }
