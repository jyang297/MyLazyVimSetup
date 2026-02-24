# Mission 16 — Macros & Bulk Editing
#
# This file uses the OLD verbose logging pattern:
#   print(f"[DEBUG] functionName: message")
#
# Your task: replace every print() call with proper logging.
# Target pattern:  logger.debug("message")
#
# RULES:
#   - Do NOT use find-and-replace (:%s) for this mission
#   - Record ONE macro that handles a single line, then replay it on the rest
#   - The macro must: delete the print line, write the logger line correctly
#
# CHECKLIST:
# [ ] Add `import logging` at the top (manually, just once)
# [ ] Add `logger = logging.getLogger(__name__)` after imports (manually)
# [ ] Position cursor on the FIRST print() call below
# [ ] Press `qq` to start recording macro into register q
# [ ] Do the edit: change print(f"[DEBUG] ...: {x}") → logger.debug(f"{x}")
# [ ] Press `q` to stop recording
# [ ] Move to the next print() line, press `@q` to replay
# [ ] Press `5@@` to repeat 5 more times
# [ ] BONUS: use `:norm @q` on a visual selection to bulk-apply
#
# HINT: a good macro sequence is:
#   0        → go to start of line
#   f"       → jump to the opening quote
#   dt:      → delete up to the colon+space (removes "[DEBUG] funcName: ")
#   ...      → fix closing

import time


def load_config(path: str) -> dict:
    print(f"[DEBUG] load_config: reading from {path}")          # macro target 1
    time.sleep(0.01)
    config = {"path": path, "loaded": True}
    print(f"[DEBUG] load_config: config keys = {list(config.keys())}")  # macro target 2
    return config


def validate_config(config: dict) -> bool:
    print(f"[DEBUG] validate_config: checking {config}")        # macro target 3
    result = "path" in config and config.get("loaded", False)
    print(f"[DEBUG] validate_config: result = {result}")        # macro target 4
    return result


def apply_config(config: dict) -> None:
    print(f"[DEBUG] apply_config: applying {config['path']}")   # macro target 5
    time.sleep(0.02)
    print(f"[DEBUG] apply_config: done")                        # macro target 6


def run_pipeline(path: str) -> bool:
    print(f"[DEBUG] run_pipeline: starting with {path}")        # macro target 7
    cfg = load_config(path)
    if not validate_config(cfg):
        print(f"[DEBUG] run_pipeline: invalid config")          # macro target 8
        return False
    apply_config(cfg)
    print(f"[DEBUG] run_pipeline: complete")                    # macro target 9
    return True
