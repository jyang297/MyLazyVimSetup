# 🎮 Getting Started Adventure

**A hands-on guided tour — learn every tool by doing, not reading.**

Each mission builds on the previous one. Complete them in order for the best experience. Practice files with intentional bugs are already waiting for you in the subdirectories.

```bash
# Open this directory in Neovim to start
nvim ~/.config/nvim/adventure/
# Then press `-` to browse with Oil.nvim
```

---

## Mission Map

| # | Directory | Language | Skill | Time |
|---|-----------|----------|-------|------|
| 1 | `mission-1-lsp/` | Python | LSP navigation, strict typing | 5 min |
| 2 | *(this dir)* | Any | Oil.nvim file management | 5 min |
| 3 | `mission-3-testing/` | Python | neotest — run, fix, watch | 10 min |
| 4 | `mission-4-debugging/` | Python | Breakpoints, DAP, Variables panel | 10 min |
| 5 | `mission-5-logpoints/` | Python | Log points — no print(), no code changes | 10 min |
| 6 | `mission-6-conditions/` | Python | Conditional breakpoints | 5 min |
| 7 | *(this dir)* | Any | Git + Diffview | 10 min |
| 8 | `mission-8-typescript/` | TypeScript | Strict mode, null checks, Prettier | 10 min |
| 9 | `mission-9-go/` | Go | gopls analyses, goimports, nilness | 10 min |
| 10 | `mission-10-watchmode/` | Python | TDD watch loop | 5 min |
| 11 | `mission-11-markdown/` | Markdown | render-markdown.nvim, browser preview | 5 min |

> **Tips:**
> - Each practice file has a **CHECKLIST** at the top — tick off every item before moving on
> - Files contain **intentional bugs** — use the tools to find them, don't just read the code
> - Missions 4 → 5 → 6 are best done in order (breakpoints → log points → conditional)

---

## Mission 1: Basic Navigation & LSP (5 minutes)

**Goal:** Learn to navigate code and use Language Server features.

**Practice file:** `mission-1-lsp/main.py` — open it and you'll see red squiggles immediately.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-1-lsp/main.py
   ```

2. **See the errors (strict typing in action):**
   - Red squiggly lines mean Pyright wants type annotations
   - Press `gl` on any red line to read the error message
   - Press `<leader>xx` to open the Trouble panel and see all errors at once

3. **Fix the types:**
   - Press `i` to enter insert mode, fix each function signature
   - Press `Esc`, then `:w` to save — errors disappear as you fix them

4. **Try LSP navigation:**
   - Move cursor to a function call → press `gd` (go to definition)
   - Press `K` (capital K) → see type info in hover window
   - Press `<C-o>` to jump back

5. **Toggle inlay hints:**
   - Notice the gray text showing parameter names inline
   - Press `<leader>uh` to toggle on/off

**✅ Done when:** no red squiggles remain and you've used `gd` and `K` at least once.

---

## Mission 2: File Explorer with Oil.nvim (5 minutes)

**Goal:** Master the most intuitive file manager ever.

Practice right here in this directory.

1. **Open Oil:** press `-` from any file
2. **Create a file:** press `o`, type `scratch.py`, press `Esc`, then `:w`
3. **Rename it:** cursor on `scratch.py`, press `cw`, type `notes.py`, `Esc`, `:w`
4. **Create a directory:** press `o`, type `tmp/`, `Esc`, `:w`
5. **Navigate into it:** press `Enter` on `tmp/`; press `-` to come back
6. **Delete it:** cursor on `tmp/`, press `dd`, then `:w`
7. **Toggle hidden files:** press `g.` to show/hide dotfiles

**✅ Done when:** you've created, renamed, and deleted a file without touching the terminal.

---

## Mission 3: Testing with Neotest (10 minutes)

**Goal:** Run tests, read failures, fix them, use watch mode.

**Practice files:** `mission-3-testing/test_calculator.py`

1. **Open the test file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-3-testing/test_calculator.py
   ```

2. **Run all tests:** press `<leader>tf` — you'll see some pass (green) and some fail (red)

3. **Read a failure:** move cursor to a failing test, press `<leader>to` (test output)

4. **Fix the broken tests:** the expected values are wrong — correct them

5. **Run nearest test:** cursor inside a test function → `<leader>tt`

6. **Open test summary:** press `<leader>ts` — see the full tree, navigate with `j`/`k`

7. **Enable watch mode:** press `<leader>tw` — now save any change and tests auto-run

8. **Debug a test:** cursor on a test → `<leader>td` (starts DAP on that test)

**✅ Done when:** all tests are green and you've used watch mode.

---

## Mission 4: Debugging with Breakpoints (10 minutes)

**Goal:** Find a real bug using the debugger — not by reading the code.

**Practice file:** `mission-4-debugging/buggy_pipeline.py`

The pipeline calculates weighted scores but ranks students wrong. Find why.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-4-debugging/buggy_pipeline.py
   ```

2. **Set a breakpoint:** cursor on the line marked `[set a breakpoint here]` → `<leader>db`

3. **Start debugger:** `<leader>dc` — DAP UI panels open

4. **Inspect variables:** look at the Variables panel on the left

5. **Step through:** `<leader>dO` (step over), `<leader>di` (step into a function)

6. **Find the bug:** watch the values change — something is off in `calculate_score`

7. **Fix it and verify:** expected output is `['Charlie', 'Alice', 'Bob']`

8. **Clean up:** `<leader>dD` to clear all breakpoints

**✅ Done when:** the ranking prints correctly.

---

## Mission 5: Log Points — Debug Without Code Changes (10 minutes)

**Goal:** Trace data flow through a pipeline using only log points.

**Practice file:** `mission-5-logpoints/data_processor.py`

You must NOT add any `print()` calls. Use log points only.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-5-logpoints/data_processor.py
   ```

2. **Set a log point:** cursor on a line marked `[LP-A]` → `<leader>dl`
   - Enter message: `raw={raw_value}, after_clip={value}`

3. **Set more log points** on lines marked `[LP-B]`, `[LP-C]`, `[LP-D]`

4. **Run the debugger:** `<leader>dc` — watch the Debug Console, not the code

5. **Answer:** which record has the highest encoded value?

6. **List all your log points:** `<leader>dL`

7. **Clear all:** `<leader>dD`

**✅ Done when:** you've read data flow from the console without touching the source.

---

## Mission 6: Conditional Breakpoints (5 minutes)

**Goal:** Only pause execution when specific conditions are met.

**Practice file:** `mission-6-conditions/find_bug.py`

100 items to process — one is broken. Don't step through all of them.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-6-conditions/find_bug.py
   ```

2. **Task A:** conditional breakpoint on `[CB-A]` with condition `result < 0` → find which index breaks

3. **Task B:** conditional breakpoint on `[CB-B]` with condition `cumulative > 1000` → find the index

4. **Task C:** condition `i % 2 == 0 and item["value"] > 40` on `[CB-C]`

5. **Fix the bug:** remove the injected bad value so total ≈ 2550

**✅ Done when:** all three tasks answered and the total is correct.

---

## Mission 7: Git Integration with Diffview (10 minutes)

**Goal:** Master Git workflows without leaving Neovim.

Practice right here — make real changes and commit them.

1. **Make a change:** edit any file in this directory (add a comment, etc.)

2. **View your diff:** `<leader>gd` — side-by-side diff view
   - Navigate files with `Tab`
   - Navigate lines with `j`/`k`
   - Close with `<leader>gq`

3. **Commit from Neovim:**
   ```vim
   :!git add .
   :!git commit -m "adventure: practice changes"
   ```

4. **View file history:** `<leader>gh` — all commits that touched this file

5. **View repo history:** `<leader>gH` — every commit ever

6. **Hunk navigation:** make another change, then:
   - `]c` → next changed hunk
   - `[c` → previous hunk
   - `<leader>gp` → preview hunk in float
   - `<leader>gb` → toggle git blame per line

**✅ Done when:** you've committed something and explored the history.

---

## Mission 8: TypeScript Strict Mode (10 minutes)

**Goal:** Fix strict type errors in TypeScript.

**Practice file:** `mission-8-typescript/strict_challenge.ts`

7 type errors waiting for you — implicit any, null checks, type mismatches.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-8-typescript/strict_challenge.ts
   ```

2. **Read each error:** `gl` on red lines, `K` to hover for type info

3. **Use code actions:** `<leader>ca` for quick-fix suggestions

4. **Save to format:** `:w` — Prettier auto-formats the file

5. **Toggle inlay hints:** `<leader>uh` — see parameter names and inferred types

**✅ Done when:** no red squiggles and you've used `<leader>ca` at least once.

---

## Mission 9: Go with Strict Analysis (10 minutes)

**Goal:** Fix every gopls warning using the tools, not intuition.

**Practice file:** `mission-9-go/main.go`

6 issues: unused import, unused parameter, unused write, nil dereference, interface{} usage, variable shadowing.

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-9-go/main.go
   ```

2. **Read diagnostics:** `gl` on each warning

3. **Fix issues** one by one — save with `:w` after each fix to see progress

4. **Let goimports work:** delete an import line, save — watch it come back automatically

5. **Check inlay hints:** notice type hints on variables and function calls

**✅ Done when:** no gutter diagnostics remain.

---

## Mission 10: Watch Mode — TDD Loop (5 minutes)

**Goal:** Experience tests running automatically as you type.

**Practice files:** `mission-10-watchmode/`

1. **Split screen:** open `test_calculator.py` on left, `calculator.py` on right
   - `<C-w>v` to split, `<leader>ff` to open the other file

2. **Enable watch mode:** in the test file → `<leader>tw`

3. **Break something:** in `calculator.py`, change `return a + b` to `return a - b`, save
   - Watch the test file go red instantly!

4. **Fix it:** change back, save → green again

5. **Add a feature:** uncomment `test_power` in the test file, implement `power()` in `calculator.py`

6. **Disable watch:** `<leader>tw` again

**✅ Done when:** you've gone red → green at least twice in watch mode.

---

## Mission 11: Markdown in Neovim (5 minutes)

**Goal:** Read and write docs beautifully without leaving Neovim.

**Practice file:** `mission-11-markdown/sample.md`

1. **Open the file:**
   ```bash
   nvim ~/.config/nvim/adventure/mission-11-markdown/sample.md
   ```
   Everything renders inline — headings, tables, checkboxes, code blocks.

2. **Toggle rendering:** `<leader>um` — off shows raw source, on shows rendered

3. **Navigate headings:** `]]` next, `[[` previous

4. **Edit the file:** add a new task to the checklist, check it off with `[x]`

5. **Browser preview:** `<leader>mp` — live preview in your browser

**✅ Done when:** you've toggled rendering, navigated headings, and edited the file.

---

## 🎓 Adventure Complete!

**You've mastered:**
- ✅ LSP navigation and strict typing
- ✅ File management with Oil.nvim
- ✅ Testing with neotest
- ✅ Debugging with breakpoints
- ✅ Log points (production debugging)
- ✅ Conditional breakpoints
- ✅ Git integration with diffview
- ✅ TypeScript strict mode
- ✅ Go static analysis
- ✅ Watch mode TDD
- ✅ Markdown rendering

**Quick reference — the commands you'll use every day:**

| Key | Action |
|-----|--------|
| `-` | File explorer |
| `gd` | Go to definition |
| `K` | Hover docs |
| `<leader>tt` | Run nearest test |
| `<leader>db` | Toggle breakpoint |
| `<leader>dl` | Set log point |
| `<leader>gd` | Git diff |
| `<leader>uh` | Toggle inlay hints |
| `<leader>xx` | Diagnostics panel |
