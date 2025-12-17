<script setup>
import { customRef, computed } from "vue";

function useDebouncedRef(value, delay = 500) {
  let timeout;
  return customRef((track, trigger) => {
    return {
      get() {
        track();
        return value;
      },
      set(newValue) {
        clearTimeout(timeout);
        timeout = setTimeout(() => {
          value = newValue;
          trigger();
        }, delay);
      },
    };
  });
}

const input = useDebouncedRef(`3-5
10-14
16-20
12-18

1
5
8
11
17
32
`, 200);

const parsedInput = computed(() => input
  .value
  .trim()
  .split("\n\n")
  .map((x) => x.trim().split("\n"))
);

const ranges = computed(() => parsedInput
  .value
  .at(0)
  .map((x) => x.split("-").map(Number)));

const ingredients = computed(() => parsedInput
  .value
  .at(1));

const isInRange = (ingredient) => ranges
  .value
  .some(([start, end]) => ingredient >= start && ingredient <= end);

const part1 = computed(() => ingredients
  .value
  .map(Number)
  .filter(isInRange)
  .length);

const part2 = computed(() => [...ranges.value]
  .sort((a, b) => a[0] - b[0])
  .reduce((acc, [start, end]) => acc.length > 0 && start <= acc.at(-1)[1] + 1
    ? [...acc.slice(0, -1), [acc.at(-1)[0], Math.max(end, acc.at(-1)[1])]]
    : [...acc, [start, end]]
    , []
  )
  .reduce((count, [start, end]) => count + (end - start + 1), 0)
);
</script>

<template>
  <main style="display: flex; flex-direction: column; gap: 5px">
    <h1>Advent of Code 2025: Day 5 🤩🤩🤩</h1>
    <textarea rows="12" v-model="input" style="width: 100%; box-sizing: border-box" />
    <div style="display: flex; gap: 8px; align-items: center">
      <p>Part 1:</p>
      <pre style="background-color: lightgray; padding: 5px"><code>{{ part1 }}</code></pre>
    </div>
    <div style="display: flex; gap: 8px; align-items: center">
      <p>Part 2:</p>
      <pre style="background-color: lightgray; padding: 5px"><code>{{ part2 }}</code></pre>
    </div>
  </main>
</template>
