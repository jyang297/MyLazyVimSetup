# Mission 11: Reading Markdown in Neovim

This file is your render-markdown.nvim playground.
Toggle rendering on/off with **`<leader>um`** and see the difference.

---

## What to Try

### 1. Headings
Each heading level gets a different color and icon.
Try jumping between them:
- `]]` → next heading
- `[[` → previous heading

### 2. Inline Formatting

This is **bold**, this is *italic*, this is `inline code`, and this is ~~strikethrough~~.

### 3. Code Blocks

```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("Neovim"))
```

```typescript
const add = (a: number, b: number): number => a + b;
console.log(add(1, 2));
```

```go
package main

import "fmt"

func main() {
    fmt.Println("Hello from Go!")
}
```

### 4. Task Lists

- [x] Install Neovim
- [x] Set up LazyVim
- [x] Configure Python, TypeScript, Go
- [ ] Build an AI project
- [ ] Become a Neovim wizard

### 5. Tables

| Language   | LSP       | Formatter  | Linter       |
|------------|-----------|------------|--------------|
| Python     | Pyright   | Black      | mypy + ruff  |
| TypeScript | ts_ls     | Prettier   | eslint_d     |
| Go         | gopls     | gofumpt    | golangci     |

### 6. Blockquote

> "Any sufficiently advanced technology is indistinguishable from magic."
> — Arthur C. Clarke

### 7. Links and Images

- [LazyVim Docs](https://lazyvim.github.io)
- [Neovim Docs](https://neovim.io/doc)

---

## Exercise

1. Press `<leader>um` to toggle rendering off — notice the raw markdown
2. Press `<leader>um` again to turn it back on
3. Edit this file: add a new task under section 4 and check it off `- [x]`
4. Add a new row to the table in section 5
5. Press `<leader>mp` to open the browser preview
6. Make a change and watch the browser update live

---

## Your Notes

*(Add your own notes here — this file is yours to edit!)*
