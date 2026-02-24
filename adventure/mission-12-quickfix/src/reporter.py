# Mission 12 — Quickfix Practice

from loader import fetch_record, fetch_item   # [QF] fetch_record import to remove


def generate_report(report_id: int) -> str:
    data = fetch_record("reports", report_id)     # [QF] deprecated call
    rows = [fetch_record("rows", i) for i in range(5)]  # [QF] deprecated call
    return f"Report {data['id']}: {len(rows)} rows"


def export_csv(export_id: int) -> list[dict]:
    records = [fetch_record("exports", i) for i in range(export_id)]  # [QF] deprecated
    return records
