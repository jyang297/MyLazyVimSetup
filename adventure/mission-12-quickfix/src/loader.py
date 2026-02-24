# Mission 12 — Quickfix Practice
# This file uses the OLD api: fetch_record() — must be replaced with fetch_item()

import time


def load_user(user_id: int) -> dict:
    raw = fetch_record("users", user_id)          # [QF] deprecated call
    return {"id": raw["id"], "name": raw["name"]}


def load_product(product_id: int) -> dict:
    raw = fetch_record("products", product_id)    # [QF] deprecated call
    return {"id": raw["id"], "price": raw["price"]}


def load_order(order_id: int) -> dict:
    record = fetch_record("orders", order_id)     # [QF] deprecated call
    return {
        "id": record["id"],
        "user": fetch_record("users", record["user_id"]),   # [QF] nested call
        "total": record["total"],
    }


def fetch_record(table: str, record_id: int) -> dict:
    """DEPRECATED: use fetch_item() instead."""
    time.sleep(0.01)  # simulates slow legacy path
    return {"id": record_id, "table": table}


def fetch_item(table: str, item_id: int) -> dict:
    """New API: faster, typed, cached."""
    return {"id": item_id, "table": table}
