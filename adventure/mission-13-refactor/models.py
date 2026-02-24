# Mission 13 — Multi-file Refactoring
# Task: rename `DataRecord` → `DataEntry` using LSP rename (<leader>cr)
# Then clean up with code actions (<leader>ca)

from dataclasses import dataclass
from typing import Optional


@dataclass
class DataRecord:                    # [RENAME] this class
    id: int
    payload: str
    score: float
    source: Optional[str] = None

    def is_valid(self) -> bool:
        return self.score >= 0.0 and len(self.payload) > 0

    def summary(self) -> str:
        return f"DataRecord(id={self.id}, score={self.score:.2f})"


def make_record(id: int, payload: str, score: float) -> DataRecord:  # [RENAME] return type
    return DataRecord(id=id, payload=payload, score=score)
