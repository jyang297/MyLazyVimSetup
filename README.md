# Neovim Configuration for AI Engineers

A professional Neovim setup optimized for AI engineering work with Python, TypeScript, and Go. Built on LazyVim with strict typing enforcement, integrated testing, and smooth UX.

**🚀 New here? Jump to the [Getting Started Adventure](#-getting-started-adventure) after installation!**

## Installation

### Prerequisites

1. **Install Neovim (0.9.0+)**
   ```bash
   # macOS
   brew install neovim

   # Or download from https://github.com/neovim/neovim/releases
   ```

2. **Install dependencies**
   ```bash
   # Required
   brew install git node python3 go fzf ripgrep fd

   # Optional but recommended
   brew install lazygit bottom
   ```

3. **Clone this configuration**
   ```bash
   # Backup existing config if you have one
   mv ~/.config/nvim ~/.config/nvim.backup

   # Clone your config
   git clone <your-repo-url> ~/.config/nvim
   ```

4. **Launch Neovim**
   ```bash
   nvim
   ```

   LazyVim will automatically:
   - Install all plugins
   - Download language servers via Mason
   - Set up formatters and linters

5. **Install tools via Mason**
   ```vim
   :Mason
   ```
   Verify these are installed:
   - Python: `pyright`, `ruff-lsp`, `mypy`, `black`, `isort`, `debugpy`
   - TypeScript: `typescript-language-server`, `prettier`, `eslint_d`
   - Go: `gopls`, `golangci-lint`, `delve`

---

## 🎮 Getting Started Adventure

**New to this setup? Take this guided tour to learn each tool step-by-step!**

Each mission builds on the previous one. Complete them in order for the best experience.

### Mission 1: Basic Navigation & LSP (5 minutes)

**Goal:** Learn to navigate code and use Language Server features.

1. **Create a test Python file:**
   ```bash
   mkdir -p ~/nvim-adventure
   cd ~/nvim-adventure
   nvim main.py
   ```

2. **Enter Insert mode and type this code:**
   ```python
   def calculate(x, y):
       result = x + y
       return result

   print(calculate(5, 3))
   ```
   Press `Esc` to exit insert mode.

3. **See the errors! (strict typing in action)**
   - Notice the red squiggly lines - Pyright wants type annotations!
   - Press `gl` (while cursor is on `def`) to see the diagnostic message

4. **Fix the types:**
   - Press `i` to enter insert mode
   - Fix the function signature:
   ```python
   def calculate(x: int, y: int) -> int:
   ```
   - Press `Esc`, then `:w` to save
   - Errors gone! ✅

5. **Try LSP navigation:**
   - Move cursor to the word `calculate` on the `print` line
   - Press `gd` (go to definition) - jumps to function definition
   - Press `K` (capital K) - see function signature in hover window
   - Press `<C-o>` to jump back

6. **See inlay hints:**
   - Notice the gray text showing parameter names: `calculate(x: 5, y: 3)`
   - Press `<leader>uh` to toggle hints off, then on again
   - Pretty cool, right? 😎

**✅ Mission 1 Complete!** You've mastered basic navigation and strict typing!

---

### Mission 2: File Explorer with Oil.nvim (5 minutes)

**Goal:** Master the most intuitive file manager ever.

1. **Still in main.py, press `-`**
   - You're now in Oil.nvim file explorer
   - You can see `main.py` listed

2. **Create a new file by editing:**
   - Press `o` to create a new line below `main.py`
   - Type: `utils.py`
   - Press `Esc`
   - **Save the changes:** `:w`
   - Oil creates the file! ✨

3. **Rename main.py to app.py:**
   - Move cursor to the line with `main.py`
   - Press `cw` (change word)
   - Type: `app.py`
   - Press `Esc`, then `:w`
   - File renamed! 🎉

4. **Create a directory:**
   - Press `o` for new line
   - Type: `tests/`
   - Press `Esc`, then `:w`
   - Directory created!

5. **Navigate into tests:**
   - Move cursor to `tests/` line
   - Press `Enter`
   - You're inside the directory
   - Press `-` to go back to parent

6. **Delete utils.py:**
   - Move cursor to `utils.py` line
   - Press `dd` (delete line)
   - Press `:w`
   - File deleted!

7. **Exit oil:**
   - Press `Enter` on `app.py` to open it

**✅ Mission 2 Complete!** You can now manage files like a pro!

---

### Mission 3: Testing with Neotest (10 minutes)

**Goal:** Write and run tests interactively.

1. **Create a test file:**
   - Press `-` to open oil
   - Create new line: `test_app.py`
   - Save with `:w`
   - Press `Enter` to open it

2. **Write a test:**
   ```python
   def test_addition() -> None:
       assert 1 + 1 == 2

   def test_multiplication() -> None:
       assert 2 * 3 == 6

   def test_failing() -> None:
       assert 1 + 1 == 3  # This will fail!
   ```
   Save with `:w`

3. **Run a single test:**
   - Move cursor to the `test_addition` function
   - Press `<leader>ts` to open test summary
   - Press `<leader>tt` (run nearest test)
   - See the green checkmark? Test passed! ✅

4. **Run all tests in file:**
   - Press `<leader>tf` (run file)
   - Notice `test_failing` has a red X ❌

5. **See test output:**
   - Move cursor to `test_failing` line
   - Press `<leader>to` (test output)
   - See the assertion error details

6. **Fix the test:**
   - Change `assert 1 + 1 == 3` to `assert 1 + 1 == 2`
   - Save with `:w`
   - Press `<leader>tt` to run again
   - Green checkmark! ✅

7. **Navigate with summary:**
   - Press `<leader>ts` to toggle summary panel
   - See all tests in a tree view
   - Use `j`/`k` to navigate
   - Press `Enter` on a test to jump to it
   - Press `<leader>ts` again to close

**💡 Pro tip:** Press `<leader>tw` to enable watch mode - tests auto-run on save!

**✅ Mission 3 Complete!** You're a testing ninja now!

---

### Mission 4: Debugging with Breakpoints (10 minutes)

**Goal:** Debug code like a detective.

1. **Create a buggy function in app.py:**
   ```python
   def process_numbers(numbers: list[int]) -> int:
       total = 0
       for num in numbers:
           total += num * 2  # Double each number
       return total

   result = process_numbers([1, 2, 3, 4, 5])
   print(f"Result: {result}")
   ```

2. **Set a breakpoint:**
   - Move cursor to the line `total += num * 2`
   - Press `<leader>db` (toggle breakpoint)
   - See the red dot in the gutter? That's your breakpoint 🔴

3. **Start debugging:**
   - Press `<leader>dc` (continue/start debug)
   - DAP UI panels open!
   - Execution stops at your breakpoint

4. **Inspect variables:**
   - Look at the Variables panel (left side)
   - See `num`, `total`, `numbers`?
   - Hover your mouse over `total` in the code
   - See the current value!

5. **Step through code:**
   - Press `<leader>dO` (step over) - goes to next line
   - Watch `total` change in the Variables panel
   - Press `<leader>dO` again
   - Keep stepping to see the loop execute

6. **Continue execution:**
   - Press `<leader>dc` (continue)
   - Program runs to completion
   - See the output: `Result: 30`

7. **Clean up:**
   - Press `<leader>dD` (clear all breakpoints)

**✅ Mission 4 Complete!** You can now debug like a pro!

---

### Mission 5: Log Points - Debug Without Code Changes (10 minutes)

**Goal:** Use log points to understand code flow without modifying source.

1. **Create a complex function:**
   ```python
   def calculate_score(base: int, multiplier: int, bonus: int) -> int:
       temp = base * multiplier
       result = temp + bonus
       return result

   scores = []
   for i in range(5):
       score = calculate_score(i, 2, 10)
       scores.append(score)

   print(f"Scores: {scores}")
   ```

2. **Set a log point (no code changes!):**
   - Move cursor to line `temp = base * multiplier`
   - Press `<leader>dl` (set log point)
   - Enter: `base={base}, multiplier={multiplier}, temp={temp}`
   - Log point set! 📝

3. **Set another log point:**
   - Move cursor to line `result = temp + bonus`
   - Press `<leader>dl`
   - Enter: `Adding bonus: temp={temp} + {bonus} = {result}`

4. **Start debugging:**
   - Press `<leader>dc`
   - In the Debug Console, you'll see log messages appear!
   - Each iteration shows values WITHOUT stopping execution

5. **Compare with regular breakpoint:**
   - Press `<leader>db` on the `scores.append(score)` line
   - Press `<leader>dc` to continue
   - Now it STOPS at each iteration
   - See the difference? Log points = no stopping! 🚀

6. **View all breakpoints:**
   - Press `<leader>dL` (list breakpoints)
   - See your log points with their messages
   - See your breakpoints

7. **Clean up:**
   - Press `<leader>dD` to clear all

**💡 Pro tip:** Log points are PERFECT for production debugging - no code changes needed!

**✅ Mission 5 Complete!** You're a debugging wizard!

---

### Mission 6: Conditional Breakpoints (5 minutes)

**Goal:** Only break when specific conditions are met.

1. **Create a loop:**
   ```python
   def find_problem(data: list[int]) -> None:
       for i, value in enumerate(data):
           result = value * 2
           print(f"Index {i}: {value} -> {result}")

   find_problem(list(range(20)))
   ```

2. **Set conditional breakpoint:**
   - Move cursor to `result = value * 2`
   - Press `<leader>dC` (conditional breakpoint)
   - Enter condition: `i == 15`
   - Breakpoint only triggers when i equals 15!

3. **Start debugging:**
   - Press `<leader>dc`
   - Notice it doesn't stop at i=0, 1, 2...
   - Only stops when i=15! 🎯

4. **Try a complex condition:**
   - Clear breakpoint: `<leader>dD`
   - Set new conditional: `value > 10 and value % 2 == 0`
   - Press `<leader>dc`
   - Only stops when value is even and greater than 10!

**✅ Mission 6 Complete!** You're a conditional debugging master!

---

### Mission 7: Git Integration with Diffview (10 minutes)

**Goal:** Master Git workflows in Neovim.

1. **Make some changes to app.py:**
   - Add a new function:
   ```python
   def greet(name: str) -> str:
       return f"Hello, {name}!"
   ```
   - Save with `:w`

2. **View your changes:**
   - Press `<leader>gd` (diffview)
   - See side-by-side diff of your changes!
   - Left = original, Right = your changes
   - Navigate with `j`/`k`

3. **Navigate between files:**
   - If you have multiple changed files, press `Tab`
   - Switches to file panel
   - Use `j`/`k` to select different files
   - Press `Enter` to view that file's diff

4. **Close diffview:**
   - Press `<leader>gq`

5. **Make a commit:**
   - In normal mode: `:!git add .`
   - `:!git commit -m "Add greet function"`

6. **View file history:**
   - Press `<leader>gh` (file history)
   - See all commits that touched app.py
   - Navigate commits with `j`/`k`
   - Press `Enter` on a commit to see changes
   - Press `<leader>gq` to close

7. **View full repo history:**
   - Press `<leader>gH` (repo history)
   - See ALL commits in project
   - Navigate and explore

8. **Hunk navigation:**
   - Make another change to app.py
   - Press `]c` - jump to next change (hunk)
   - Press `[c` - jump to previous change
   - Press `<leader>gp` - preview hunk in floating window
   - Press `<leader>gb` - toggle git blame (see who changed each line)

**✅ Mission 7 Complete!** Git is now your playground!

---

### Mission 8: TypeScript Strict Mode (10 minutes)

**Goal:** Experience strict typing in TypeScript.

1. **Create a TypeScript file:**
   - Press `-`, create `app.ts`
   - Open it

2. **Write loose code (bad):**
   ```typescript
   function add(a, b) {
       return a + b;
   }

   let result = add(5, 3);
   ```
   - See the errors? Strict mode catches implicit `any`! 🚨

3. **Fix with proper types:**
   ```typescript
   function add(a: number, b: number): number {
       return a + b;
   }

   let result: number = add(5, 3);
   ```
   - Errors gone! ✅

4. **See inlay hints:**
   - Notice hints showing: `add(a: 5, b: 3)`
   - Very helpful for understanding function calls!

5. **Try strict null checks:**
   ```typescript
   let username: string | null = null;
   console.log(username.length);  // ❌ Error!
   ```
   - Strict mode catches potential null reference!

6. **Fix it:**
   ```typescript
   let username: string | null = null;
   if (username !== null) {
       console.log(username.length);  // ✅ OK
   }
   ```

7. **Auto-format with Prettier:**
   - Write some messy code:
   ```typescript
   const obj={name:"test",value:123,active:true};
   ```
   - Save with `:w`
   - Prettier auto-formats it! ✨
   ```typescript
   const obj = { name: "test", value: 123, active: true };
   ```

**✅ Mission 8 Complete!** TypeScript strict mode mastered!

---

### Mission 9: Go with Strict Analysis (10 minutes)

**Goal:** Experience Go's powerful static analysis.

1. **Create a Go file:**
   - Press `-`, create `main.go`
   - Open it

2. **Write code with issues:**
   ```go
   package main

   import "fmt"

   func process(data string, unused int) {
       var result string
       result = data
       fmt.Println(data)
   }

   func main() {
       var ptr *int
       fmt.Println(*ptr)
       process("hello", 42)
   }
   ```

3. **See the errors:**
   - `unused` parameter - gopls catches it! 🚨
   - `result` written but never used - caught!
   - `*ptr` potential nil pointer - caught!

4. **Fix the issues:**
   ```go
   package main

   import "fmt"

   func process(data string) {
       fmt.Println(data)
   }

   func main() {
       value := 42
       ptr := &value
       fmt.Println(*ptr)
       process("hello")
   }
   ```

5. **Auto-imports:**
   - Remove the `import "fmt"` line
   - Save with `:w`
   - goimports adds it back automatically! 🎉

6. **See inlay hints:**
   - Notice parameter hints in function calls
   - Type hints for variables

**✅ Mission 9 Complete!** You're a Go strict typing champion!

---

### Mission 10: Advanced - Watch Mode Testing (5 minutes)

**Goal:** Tests auto-run as you code!

1. **Open test_app.py:**
   - Press `<leader>ff`, type `test_app`, press `Enter`

2. **Enable watch mode:**
   - Press `<leader>tw` (toggle watch)
   - You'll see a notification: "Watch mode enabled"

3. **Make a change:**
   - Edit one of the tests
   - Save with `:w`
   - Tests automatically run! 🚀
   - See results in status line

4. **Break a test:**
   - Change `assert 1 + 1 == 2` to `assert 1 + 1 == 3`
   - Save
   - Instantly see failure!

5. **Fix it:**
   - Change back to `== 2`
   - Save
   - Instantly green! ✅

6. **Disable watch mode:**
   - Press `<leader>tw` again

**✅ Mission 10 Complete!** You're a TDD master!

---

### Mission 11: Reading Markdown in Neovim (5 minutes)

**Goal:** Read and write beautiful docs without leaving Neovim.

1. **Open this README:**
   ```bash
   nvim ~/.config/nvim/README.md
   ```
   Markdown renders inline — headers are colored, code blocks have backgrounds, bullets have icons, tables are drawn with lines.

2. **Toggle rendering off and on:**
   - Press `<leader>um` to toggle rendering
   - Off = raw markdown source
   - On = rendered view
   - Very useful when editing so you can see the raw syntax

3. **Navigate headings fast:**
   - Press `]]` - jump to next heading
   - Press `[[` - jump to previous heading
   - Use this to skim long documents quickly

4. **Check your task lists:**
   - Find a `- [ ]` checkbox in this README
   - Notice it renders as an unchecked box: `󰄱`
   - `- [x]` renders as a checked box: `󰱒`

5. **Open browser preview (for sharing):**
   - Press `<leader>mp` (Markdown Preview)
   - Your browser opens with a live preview
   - Edit the file — browser updates in real time!
   - Press `<leader>mp` again to close

6. **Try writing your own note:**
   - Open a new file: `:e ~/notes.md`
   - Write some markdown:
     ```markdown
     # My Notes

     ## Today
     - [x] Set up Neovim
     - [ ] Build something cool

     ## Code
     ```python
     def hello() -> str:
         return "world"
     ```
     ```
   - Watch it render as you type!

**✅ Mission 11 Complete!** Neovim is now your documentation hub!

---

### 🎓 Adventure Complete!

**Congratulations! You've mastered:**
- ✅ LSP navigation and strict typing
- ✅ File management with Oil.nvim
- ✅ Testing with neotest
- ✅ Debugging with breakpoints
- ✅ Log points (production debugging)
- ✅ Conditional breakpoints
- ✅ Git integration with diffview
- ✅ TypeScript strict mode
- ✅ Go static analysis
- ✅ Watch mode testing
- ✅ Reading & writing markdown

**What's Next?**
- Read the full documentation below for advanced features
- Customize keybindings to your preference
- Add AI completion when ready
- Build something awesome! 🚀

**Remember the key commands:**
- `<leader>` = `Space`
- `-` = Oil file explorer
- `<leader>ff` = Find files
- `<leader>tt` = Run test
- `<leader>db` = Breakpoint
- `<leader>gd` = Git diff
- `K` = Hover docs
- `gd` = Go to definition

---

## Table of Contents

- [🎮 Getting Started Adventure](#-getting-started-adventure) ⭐ **Start here if you're new!**
- [Language Support](#language-support)
  - [Python](#python)
  - [TypeScript/JavaScript](#typescriptjavascript)
  - [Go](#go)
- [Testing](#testing)
- [Debugging](#debugging)
- [Git Integration](#git-integration)
- [File Management](#file-management)
- [Markdown](#markdown)
- [Key Features](#key-features)
- [Keybindings Reference](#keybindings-reference)

---

## Language Support

### Python

**Features:**
- **Strict type checking** with Pyright (`typeCheckingMode: "strict"`)
- **Static type analysis** with mypy
- **Fast linting** with Ruff
- **Formatting** with Black + isort (auto on save)
- **Debugging** with debugpy
- **Inlay hints** showing types and parameters
- **Testing** with pytest via neotest

**Keybindings:**
- `<leader>cr` - Organize imports (Pyright)
- `gl` - Show diagnostics in floating window
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>ca` - Code actions

**Type Checking:**
```python
# Pyright strict mode will catch:
def greet(name):  # ❌ Missing type annotation
    return f"Hello {name}"

def greet(name: str) -> str:  # ✅ Properly typed
    return f"Hello {name}"
```

**Configuration:**
- File: `lua/extras/python.lua`
- LSP: Pyright (strict) + Ruff LSP
- Linter: mypy
- Formatter: Black + isort

---

### TypeScript/JavaScript

**Features:**
- **Strict type checking** with tsserver (strictNullChecks, noImplicitAny, etc.)
- **Comprehensive inlay hints** for parameters, return types, variables
- **FAANG-standard formatting** with Prettier
- **Linting** with ESLint (via eslint_d)
- **Debugging** with vscode-js-debug (Node.js/TypeScript)
- **Testing** with Jest via neotest

**Keybindings:**
- `<leader>co` - Organize imports
- `<leader>cR` - Rename file (updates imports)
- `gl` - Show diagnostics
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Go to references

**Type Checking:**
```typescript
// Strict mode catches:
function add(a, b) {  // ❌ Implicit any
    return a + b;
}

function add(a: number, b: number): number {  // ✅ Strict
    return a + b;
}

let value: string | null = null;
console.log(value.length);  // ❌ Caught by strictNullChecks
```

**Inlay Hints:**
```typescript
// You'll see hints like:
function process(data: string, count: number) { }
process("test", 42)
// Displays: process(data: "test", count: 42)
```

**Configuration:**
- File: `lua/extras/typescript.lua`
- LSP: tsserver with strict preferences
- Linter: eslint_d
- Formatter: Prettier

---

### Go

**Features:**
- **Strict static analysis** (nilness, unused params/writes, staticcheck)
- **Advanced formatting** with gofumpt (stricter than gofmt)
- **Auto-import management** with goimports
- **Comprehensive linting** with golangci-lint
- **Debugging** with Delve
- **Inlay hints** for types and parameters
- **Testing** with go test via neotest
- **Code generation** via go.nvim (tags, tests, etc.)

**Keybindings:**
- `<leader>cr` - Run go generate
- `gl` - Show diagnostics
- `K` - Hover documentation
- `gd` - Go to definition
- `gr` - Go to references

**Static Analysis:**
```go
// gopls strict mode catches:
func process(data string, unused int) {  // ❌ unused parameter
    var result string  // ❌ unused write
    result = data
    fmt.Println(data)
}

var ptr *int
fmt.Println(*ptr)  // ❌ nilness: potential nil pointer dereference
```

**Configuration:**
- File: `lua/extras/go.lua`
- LSP: gopls with strict analyses
- Linter: golangci-lint
- Formatter: goimports + gofumpt

---

## Testing

Integrated test running with **neotest** for all three languages.

### Keybindings (all under `<leader>t`)

| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run all tests in current file |
| `<leader>td` | Debug nearest test (with DAP) |
| `<leader>ts` | Toggle test summary panel |
| `<leader>to` | Show test output |
| `<leader>tO` | Toggle output panel |
| `<leader>tS` | Stop running test |
| `<leader>tw` | Toggle watch mode (auto-run on save) |

### Usage Examples

**Python (pytest):**
```python
def test_addition():
    assert 1 + 1 == 2

# Cursor on test, press <leader>tt to run
# Press <leader>td to debug with breakpoints
```

**TypeScript (Jest):**
```typescript
test('should add numbers', () => {
    expect(1 + 1).toBe(2);
});

// <leader>tt runs this test
// <leader>tf runs all tests in file
```

**Go:**
```go
func TestAddition(t *testing.T) {
    if 1+1 != 2 {
        t.Error("Math is broken")
    }
}

// <leader>tt runs test
// <leader>ts shows summary
```

**Test Summary Panel:**
- Press `<leader>ts` to see all tests in project
- Navigate with `j`/`k`
- Press `Enter` to jump to test
- Shows pass/fail status with icons

---

## Debugging

Full DAP (Debug Adapter Protocol) support for all languages.

### Core Debugging Keybindings

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Toggle breakpoint (old conditional) |
| `<leader>dl` | **Set log point** (NEW) |
| `<leader>dC` | **Set conditional breakpoint** (NEW) |
| `<leader>dD` | **Clear all breakpoints** (NEW) |
| `<leader>dL` | **List all breakpoints** (NEW) |
| `<leader>dc` | Continue/Start debugging |
| `<leader>dO` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dr` | Toggle REPL |
| `<leader>du` | Toggle UI |
| `<leader>dw` | Show widgets |

### Log Points (NEW!)

**What are log points?**
- Print messages during debugging WITHOUT modifying source code
- Variables in `{curly braces}` are evaluated
- Execution continues (doesn't pause like breakpoints)

**How to use:**
1. Position cursor on the line
2. Press `<leader>dl`
3. Enter log message: `Value is {variable_name}`
4. Run debugger - message appears in console
5. No source code changes needed!

**Example:**
```python
def calculate(x, y):
    result = x + y  # Set log point here: "x={x}, y={y}, result={result}"
    return result
```

### Conditional Breakpoints

**Only pause when condition is true:**
1. Press `<leader>dC`
2. Enter condition: `x > 10`
3. Debugger only pauses when `x > 10` is true

**Example:**
```typescript
for (let i = 0; i < 100; i++) {
    process(i);  // Conditional breakpoint: i === 50
}
// Only breaks when i is 50
```

### Debugging Workflow

1. **Set breakpoint**: `<leader>db`
2. **Start debugging**: `<leader>dc`
3. **Step through code**: `<leader>dO` (over), `<leader>di` (into)
4. **Inspect variables**: Hover or check UI panels
5. **Continue**: `<leader>dc`

### Debug UI Panels

When debugging:
- **Variables** - Shows all variables in current scope
- **Watches** - Custom expressions to watch
- **Call Stack** - Function call hierarchy
- **Breakpoints** - All breakpoints with conditions/log points
- **REPL** - Execute code in debug context

**Toggle panels:** `<leader>du`

---

## Git Integration

### Gitsigns (in-buffer git info)

**Features:**
- Git blame in virtual text
- Hunk preview and navigation
- Stage/unstage hunks

**Keybindings:**
| Key | Action |
|-----|--------|
| `]c` | Next git hunk |
| `[c` | Previous git hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gu` | Unstage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Toggle git blame line |

### Diffview (NEW!)

**Beautiful diff viewer and history browser.**

**Keybindings:**
| Key | Action |
|-----|--------|
| `<leader>gd` | Open diff view (current changes) |
| `<leader>gh` | File history (current file) |
| `<leader>gH` | Repo history (all files) |
| `<leader>gq` | Close diffview |

**Usage:**

**View uncommitted changes:**
```bash
# In Neovim, press <leader>gd
# Shows side-by-side diff of all changes
# Navigate with j/k, toggle files with Tab
```

**View file history:**
```bash
# Press <leader>gh to see current file's history
# Shows all commits that changed this file
# Press Enter on a commit to see changes
```

**Merge conflict resolution:**
- Diffview automatically detects conflicts
- Shows 3-way merge view
- Use `<leader>co` (choose ours), `<leader>ct` (choose theirs)

### Git Conflict Resolution

When you have conflicts:
1. Open file with conflicts
2. Press `<leader>gd` for visual merge
3. Use conflict markers or choose sides
4. Save and commit

---

## File Management

### Oil.nvim (NEW!)

**Edit your filesystem like a buffer - the most intuitive file manager.**

**Open Oil:**
- `-` - Open parent directory
- `<leader>e` - Open oil in current directory

**Inside Oil:**
| Key | Action |
|-----|--------|
| `Enter` | Open file/directory |
| `-` | Go to parent directory |
| `_` | Open cwd |
| `<C-s>` | Open in vertical split |
| `<C-h>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview file |
| `g.` | Toggle hidden files |
| `gs` | Change sort order |
| `gx` | Open with system default |

**Editing workflow:**
1. Press `-` to open oil
2. Navigate with `j`/`k`
3. **Edit filenames like text** - change, delete, yank
4. **Create files** - add new lines with file names
5. **Delete files** - delete lines
6. Save buffer (`:w`) to apply changes
7. Oil executes all file operations atomically

**Examples:**
```
# Rename multiple files:
old-name-1.ts    → new-name-1.ts
old-name-2.ts    → new-name-2.ts
# Just edit and :w

# Create new file:
# Add line: new-file.py
# Save with :w

# Delete file:
# Delete line with dd
# Save with :w
```

### Neo-tree (built-in alternative)

If you prefer a traditional tree:
- `<leader>fe` - Toggle file explorer
- `<leader>fE` - Toggle explorer (cwd)

---

## Markdown

Read and write docs beautifully without leaving Neovim.

### Inline Rendering (render-markdown.nvim)

Markdown renders live in the buffer — no browser, no split, just pretty text.

**What gets rendered:**
| Element | Raw | Rendered |
|---------|-----|----------|
| Headings | `# Title` | Large, colored text with icon |
| Code blocks | ` ```python ` | Syntax-highlighted with background |
| Bullets | `- item` | `●`, `○`, `◆`, `◇` icons |
| Checkboxes | `- [ ]` / `- [x]` | `󰄱` / `󰱒` |
| Tables | `\| a \| b \|` | Drawn with line characters |
| Quotes | `> text` | `▋` accent bar |
| Links | `[text](url)` | `󰌹` icon prefix |
| Images | `![alt](url)` | `󰥶` icon prefix |
| Horizontal rule | `---` | Full-width `─` line |

**Keybindings:**
| Key | Action |
|-----|--------|
| `<leader>um` | Toggle rendering on/off |
| `]]` | Jump to next heading |
| `[[` | Jump to previous heading |
| `<leader>mp` | Browser preview (live reload) |

**Tips:**
- Toggle off with `<leader>um` when editing to see raw syntax
- Use `]]`/`[[` to skim long docs like this README
- Browser preview (`<leader>mp`) is useful before pushing docs to GitHub

**Configuration:** `lua/extras/markdown.lua`

---

## Key Features

### Inlay Hints

**See type information inline as you code.**

**What you see:**
```typescript
function process(data: string, count: number) {
    const result = transform(data);  // Shows: const result: TransformedData
    return result;
}

process("test", 42);  // Shows: process(data: "test", count: 42)
```

**Keybinding:**
- `<leader>uh` - Toggle inlay hints on/off

**Configuration:** Enabled by default for Python, TypeScript, and Go with tasteful gray styling.

### Better Quickfix (nvim-bqf)

**Enhanced quickfix window with preview and fuzzy search.**

**When to use:**
- After `:Grep` or `:grep`
- After LSP find references (`gr`)
- After diagnostics list

**Inside quickfix:**
- `<Tab>` - Preview item
- `<C-o>` - Toggle all items
- `<C-s>` - Open in split
- `<C-t>` - Open in tab
- Type to fuzzy search results

### Auto-formatting

**Formats on save for all languages:**
- Python: Black + isort
- TypeScript/JavaScript: Prettier
- Go: goimports + gofumpt

**Manual format:**
- `<leader>cf` - Format current buffer

### Linting

**Automatic linting on save and when leaving insert mode:**
- Python: mypy (types) + ruff (style)
- TypeScript: eslint_d
- Go: golangci-lint

**View diagnostics:**
- `gl` - Floating diagnostic window
- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `<leader>xx` - Trouble diagnostics panel

### LSP Features

**Available in all languages:**

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>cf` | Format buffer |

---

## Keybindings Reference

### Leader Key

`<leader>` = `Space`

### General Navigation

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate splits |
| `<C-w>s` | Split horizontal |
| `<C-w>v` | Split vertical |
| `<leader><Tab>` | Last buffer |
| `<leader>bd` | Delete buffer |

### File Navigation

| Key | Action |
|-----|--------|
| `-` | Oil file explorer (parent) |
| `<leader>e` | Oil file explorer (cwd) |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fg` | Grep files |
| `<leader>fb` | Find buffers |

### LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `K` | Hover docs |
| `gd` | Go to definition |
| `gr` | Find references |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename |
| `<leader>cf` | Format |
| `gl` | Show diagnostic |
| `]d` / `[d` | Next/prev diagnostic |

### Testing (`<leader>t`)

| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>td` | Debug test |
| `<leader>ts` | Test summary |
| `<leader>to` | Test output |
| `<leader>tw` | Watch mode |

### Debugging (`<leader>d`)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dl` | Log point |
| `<leader>dC` | Conditional breakpoint |
| `<leader>dc` | Continue |
| `<leader>dO` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>du` | Toggle UI |
| `<leader>dD` | Clear breakpoints |

### Git (`<leader>g`)

| Key | Action |
|-----|--------|
| `<leader>gd` | Diffview (changes) |
| `<leader>gh` | File history |
| `<leader>gH` | Repo history |
| `<leader>gq` | Close diffview |
| `<leader>gb` | Toggle blame |
| `<leader>gp` | Preview hunk |
| `]c` / `[c` | Next/prev hunk |

### UI Toggles (`<leader>u`)

| Key | Action |
|-----|--------|
| `<leader>uh` | Toggle inlay hints |
| `<leader>ul` | Toggle line numbers |
| `<leader>uw` | Toggle wrap |
| `<leader>us` | Toggle spell |

### Diagnostics (`<leader>x`)

| Key | Action |
|-----|--------|
| `<leader>xx` | Trouble diagnostics |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xs` | Symbols (outline) |
| `<leader>xq` | Quickfix list |

---

## Tips & Tricks

### For Python Developers

1. **Strict typing from the start:**
   ```python
   # Pyright strict mode requires types everywhere
   # Good practice for production code
   ```

2. **Use mypy for CI/CD:**
   ```bash
   # Same config as your editor
   mypy --strict your_module.py
   ```

3. **Debug tests easily:**
   - Set breakpoint in test with `<leader>db`
   - Press `<leader>td` to debug test
   - Step through with `<leader>dO`

### For TypeScript Developers

1. **Inlay hints show everything:**
   - Parameter names in function calls
   - Inferred return types
   - Variable types
   - Toggle with `<leader>uh` if too noisy

2. **Prettier + ESLint:**
   - Prettier handles formatting (auto on save)
   - ESLint handles code quality
   - Both run automatically

3. **Debug Node.js apps:**
   - Set breakpoints with `<leader>db`
   - Start with `<leader>dc`
   - Full Chrome DevTools-like experience

### For Go Developers

1. **Use gopls strict checks:**
   - Catches nil pointers before runtime
   - Finds unused code
   - Enforces best practices

2. **Auto-import on save:**
   - Just use packages, imports auto-add
   - Unused imports auto-remove

3. **Table-driven tests:**
   - neotest-go supports running individual table cases
   - Cursor on case, press `<leader>tt`

### General Tips

1. **Use log points for production debugging:**
   - No code changes needed
   - Add/remove during debug session
   - Perfect for understanding flow

2. **Oil.nvim for bulk operations:**
   - Rename multiple files with visual mode
   - Create file structure by typing it out
   - Safer than rm/mv commands

3. **Diffview for code review:**
   - Review your changes before commit: `<leader>gd`
   - Check file history: `<leader>gh`
   - Better than `git diff`

4. **Test summary as TODO list:**
   - `<leader>ts` shows all tests
   - Red = needs fixing
   - Green = working
   - Use as project health dashboard

---

## Configuration Files

```
~/.config/nvim/
├── lua/
│   ├── config/              # Core Neovim settings
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── options.lua     # Vim options
│   │   ├── keymaps.lua     # Custom keymaps
│   │   └── autocmds.lua    # Auto-commands
│   ├── extras/              # Language-specific configs
│   │   ├── python.lua      # Python: Pyright + mypy + black
│   │   ├── typescript.lua  # TypeScript: tsserver + prettier + eslint
│   │   ├── go.lua          # Go: gopls + golangci-lint
│   │   └── dap.lua         # Debugger configurations
│   └── plugins/             # Plugin customizations
│       ├── testing.lua     # Neotest configuration
│       ├── ux.lua          # Oil, Diffview, nvim-bqf
│       ├── dap-keybindings.lua  # Debug keybindings + log points
│       └── ...
├── lazy-lock.json          # Plugin version lockfile
└── README.md               # This file
```

---

## Troubleshooting

### LSP not working

```vim
:LspInfo          " Check LSP status
:Mason            " Check installed tools
:checkhealth      " Run health checks
```

### Formatter not running

```vim
:ConformInfo      " Check conform.nvim status
:Mason            " Ensure formatter is installed
```

### Tests not running

```vim
:Neotest summary  " Check test detection
" Ensure test files match patterns:
" Python: test_*.py or *_test.py
" TypeScript: *.test.ts or *.spec.ts
" Go: *_test.go
```

### Debugger not starting

```vim
:DapInstall       " Install debug adapters
:Mason            " Check debugpy/delve installed
```

### Inlay hints not showing

```vim
:lua vim.lsp.inlay_hint.enable(true)  " Force enable
<leader>uh        " Toggle hints
```

---

## Adding AI Completion Later

When you're ready to add AI completion (GitHub Copilot, Supermaven, etc.):

1. **For GitHub Copilot:**
   ```lua
   -- Add to lua/plugins/ai-completion.lua
   return {
     {
       "zbirenbaum/copilot.lua",
       event = "InsertEnter",
       opts = {
         suggestion = { enabled = true, auto_trigger = true },
         panel = { enabled = true },
       },
     },
   }
   ```

2. **For Supermaven:**
   ```lua
   return {
     {
       "supermaven-inc/supermaven-nvim",
       event = "InsertEnter",
       opts = {},
     },
   }
   ```

Just create the file, restart Neovim, and it will work with your existing setup.

---

## Resources

- **LazyVim Docs:** https://lazyvim.github.io
- **Neovim Docs:** https://neovim.io/doc
- **Report Issues:** Your repo issues page

---

**Enjoy your professional AI engineering environment!** 🚀
