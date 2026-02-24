// Mission 15 — TypeScript DAP Debugging
//
// This pipeline processes sensor readings and computes statistics.
// It has TWO bugs — use breakpoints to find them, not your eyes.
//
// Run it with:  npx ts-node pipeline.ts   (or: node --loader ts-node/esm pipeline.ts)
// Debug it with: <leader>dc after setting a breakpoint with <leader>db
//
// CHECKLIST:
// [ ] Set a breakpoint on the line marked [BP-1]
// [ ] Start debugger with <leader>dc
// [ ] Find why `average` is wrong (check the Variables panel)
// [ ] Set a breakpoint on [BP-2]
// [ ] Find why `outliers` is missing a value
// [ ] Fix both bugs
// [ ] Run again — expected output at the bottom of this file

interface SensorReading {
  id: number;
  value: number;
  timestamp: number;
}

function normalize(readings: SensorReading[]): number[] {
  const values = readings.map((r) => r.value);
  const min = Math.min(...values);
  const max = Math.max(...values);
  const range = max - min;

  // BUG 1: division by zero guard is inverted
  if (range === 0) {
    return values.map(() => 1.0);   // [BP-1] inspect `range` and `values` here
  }
  return values.map((v) => (v - min) / range);
}

function computeStats(normalized: number[]): {
  average: number;
  outliers: number[];
} {
  const sum = normalized.reduce((acc, v) => acc + v, 0);
  const average = sum / normalized.length;

  // BUG 2: outlier threshold uses wrong comparison (> should be >=, or threshold is off)
  const threshold = 0.8;
  const outliers = normalized.filter((v) => v > threshold + 0.1);  // [BP-2] inspect threshold logic

  return { average, outliers };
}

const readings: SensorReading[] = [
  { id: 1, value: 10, timestamp: 1000 },
  { id: 2, value: 20, timestamp: 1001 },
  { id: 3, value: 85, timestamp: 1002 },
  { id: 4, value: 40, timestamp: 1003 },
  { id: 5, value: 95, timestamp: 1004 },
  { id: 6, value: 30, timestamp: 1005 },
];

const normalized = normalize(readings);
const stats = computeStats(normalized);

console.log("Normalized:", normalized.map((v) => v.toFixed(3)));
console.log("Average:", stats.average.toFixed(3));
console.log("Outliers (>0.8):", stats.outliers.map((v) => v.toFixed(3)));

// Expected output after fixing:
// Normalized: ['0.000', '0.118', '0.882', '0.353', '1.000', '0.235']
// Average: 0.431
// Outliers (>0.8): ['0.882', '1.000']
