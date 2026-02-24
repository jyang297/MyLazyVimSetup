// ============================================================
// MISSION 8: TypeScript Strict Mode
// ============================================================
// GOAL: Fix every type error ts_ls reports, using strict mode
//       features: noImplicitAny, strictNullChecks, strictFunctionTypes.
//
// HOW TO START:
//   Open this file — red squiggles should appear immediately.
//   Press `gl`           → read the error under the cursor
//   Press `K`            → hover any symbol for its type
//   Press `<leader>ca`   → code actions (quick-fix suggestions)
//   Save (`:w`)          → Prettier auto-formats the file
//
// CHECKLIST:
//   [ ] All red squiggles gone
//   [ ] Inlay hints visible — press `<leader>uh` to toggle
//   [ ] Used `gd` to jump to a type definition
//   [ ] Saved the file and watched Prettier reformat it
// ============================================================


// ❌ PROBLEM 1: implicit `any` — add proper parameter types
function multiply(a, b) {
  return a * b
}


// ❌ PROBLEM 2: return type mismatch
function getUserName(id: number): number {
  return `user_${id}`
}


// ❌ PROBLEM 3: strictNullChecks — value might be null
function getLength(value: string | null): number {
  return value.length           // value could be null!
}


// ❌ PROBLEM 4: property access on possibly-undefined array element
function firstItem(arr: string[]): string {
  return arr[0].toUpperCase()   // arr might be empty!
}


// ❌ PROBLEM 5: wrong type in object literal
interface User {
  id: number
  name: string
  active: boolean
}

const user: User = {
  id: "123",          // should be number
  name: "Alice",
  active: 1,          // should be boolean
}


// ❌ PROBLEM 6: strictFunctionTypes — callback signature mismatch
function runCallback(cb: (value: number) => void): void {
  cb(42)
}

// This callback accepts `any` — stricter type needed
runCallback((x: any) => console.log(x))


// ❌ PROBLEM 7: Promise not awaited (common async bug)
async function fetchData(url: string): Promise<string> {
  const response = fetch(url)   // missing await!
  return response.text()        // response is a Promise here, not a Response
}


// ── Playground: try these after fixing everything ───────────
// 1. Hover over `multiply` call below — see the inlay hints?
// 2. Press `gd` on `User` to see the interface definition
// 3. Make the code messy (no spaces) and save → Prettier fixes it
const result = multiply(6, 7)
const name = getUserName(1)
const len = getLength("hello")
console.log(result, name, len)
