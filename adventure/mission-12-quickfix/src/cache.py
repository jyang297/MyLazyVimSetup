# Mission 12 — Quickfix Practice

from loader import fetch_record    # [QF] deprecated import

_cache: dict = {}


def get_cached(table: str, item_id: int) -> dict:
    key = f"{table}:{item_id}"
    if key not in _cache:
        _cache[key] = fetch_record(table, item_id)   # [QF] deprecated call
    return _cache[key]


def warm_cache(table: str, ids: list[int]) -> None:
    for item_id in ids:
        get_cached(table, item_id)   # indirect, but fixes here cascade
