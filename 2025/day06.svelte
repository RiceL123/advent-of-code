<script>
  let input = $state(`123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  `);

  Array.prototype.transpose = function () {
    return this.reduce((acc, x, i, arr) => i === 0
      ? x.map((_, col) => Array.from({ length: arr.length },(_, i) => arr[arr.length - 1 - i][col]))
      : acc,
      []
    );
  };

  Array.prototype.transpose2 = function () {
    return this.reduce((acc, curr, i, arr) => {
      if (i === arr.length - 1) {
        return [...curr]
          .reduce((acc, x, i) => ["*", "+"].includes(x)
                ? [...acc, [i, i + curr.slice(i + 1).match(/\s+/).at(0).length]]
                : acc,
            [],
          )
          .map(([start, finish]) => Array.from({ length: arr.length }, (_, i) =>arr[i].slice(start, finish)));
      }
      return acc;
    }, []);
  };

  Array.prototype.transpose3 = function () {
    return [...this[0]].map((_, colIndex) => {
      return this.map((row) => row[colIndex]);
    });
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

  let part2 = $derived(
    (input + " ")
      .split("\n")
      .transpose2()
      .map((x) => {
        const nums = x
          .slice(0, -1)
          .transpose3()
          .map((x) => x.filter((x) => x !== " ").join(""))
          .map(Number);
        return { op: x.at(-1).trim(), nums };
      })
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
  <div style="display: flex; align-items: center; gap: 5px">
    Part 1: <pre><code>{part1}</code></pre>
  </div>
  <div style="display: flex; align-items: center; gap: 5px">
    Part 2: <pre><code>{JSON.stringify(part2)}</code></pre>
  </div>
</main>
