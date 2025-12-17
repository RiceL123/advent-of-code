<script>
  let input = $state(`123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
`);

  Array.prototype.transpose = function () {
    return this.reduce(
      (acc, x, i, arr) =>
        i === 0
          ? x.map((_, col) => Array.from({ length: arr.length }, (_, i) => arr[arr.length - 1 - i][col]))
          : acc,
      [],
    );
  };

  let part1 = $derived(
    input
      .trim()
      .split("\n")
      .map((x) => x.trim().split(/\s+/))
      .transpose()
      .map(([op, ...nums]) => ({ op, nums: nums.map(Number) }))
      .map(({ op, nums }) => {
        switch (op) {
          case "*": return nums.reduce((acc, x) => acc * x);
          case "+": return nums.reduce((acc, x) => acc + x);
        }
      })
      .reduce((acc, x) => acc + x),
  );
</script>

<main style="display: flex; flex-direction: column; gap: 5px;">
  <h1>Advent of Code</h1>
  <textarea bind:value={input} rows={5}></textarea>
  <div>
    Part 1: <pre><code>{part1}</code></pre>
  </div>
</main>
