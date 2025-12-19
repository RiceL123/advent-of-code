import { render } from "solid-js/web";
import { createSignal } from "solid-js";

function Day07() {
  const [input, setInput] = createSignal(`.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
`);

  const output = () =>
    input()
      .trim()
      .split("\n")
      .reduce((acc: string[], value, index) => {
        if (index === 0) return [...acc, value.replace("S", "|")];

        const prevValue = acc[index - 1];
        const transformed = [...prevValue]
          .map((x, i) => (x === "|" ? i : -1))
          .filter((x) => x !== -1)
          .flatMap((x) => (value[x] === "^" ? [x - 1, x + 1] : x));
        const newValue = [...value]
          .map((x, i) => (transformed.includes(i) ? "|" : x))
          .join("");
        return [...acc, newValue];
      }, [])
      .join("\n");

  const part1 = () =>
    output()
      .trim()
      .split("\n")
      .reduce(
        (acc, curr, index, arr) =>
          acc +
          [...curr]
            .map((x, i) => (x === "^" ? i : -1))
            .filter((x) => index >= 1 && arr[index - 1][x] === "|").length,
        0,
      );

  const cache = new Map<string, number>();
  function agnesTachyon(row: number, col: number, manifold: string[]): number {
    const key = `${row},${col}`;
    if (cache.has(key)) return cache.get(key) ?? 0;

    if (manifold.length - 1 === row) return 1;
    
    if (manifold[row][col] !== "^") {
      cache.set(key, agnesTachyon(row + 1, col, manifold));
    } else {
      cache.set(key, agnesTachyon(row + 1, col - 1, manifold) + agnesTachyon(row + 1, col + 1, manifold));
    }
    return cache.get(key) ?? 0;
  }

  const part2 = () => {
    cache.clear();
    return agnesTachyon(1, input().indexOf("S"), input().trim().split("\n"));
  };

  return (
    <main>
      <h1>Advent of Code 2025: Day07 (Agnes Tachyon!!!)</h1>
      <div style={{ display: "flex", gap: "8px" }}>
        <textarea
          textContent={input()}
          onInput={(e) => setInput(e.target.value)}
          rows={17}
          style={{ "font-size": "0.5em", "font-family": "mono" }}
        />
        <div>
          <div
            style={{ display: "flex", "align-items": "center", gap: "10px" }}
          >
            <p>Part 1</p>
            <pre style={{ "background-color": "lightgray", padding: "10px" }}>
              <code>{part1()}</code>
            </pre>
          </div>
          <div
            style={{ display: "flex", "align-items": "center", gap: "10px" }}
          >
            <p>Part 2</p>
            <pre style={{ "background-color": "lightgray", padding: "10px" }}>
              <code>{part2()}</code>
            </pre>
          </div>
        </div>
      </div>
      <pre style={{ padding: "10px" }}>{output()}</pre>
    </main>
  );
}

render(() => <Day07 />, document.getElementById("app")!);
