import { Component, signal, ChangeDetectionStrategy, computed } from '@angular/core';
import { form, Field, debounce } from '@angular/forms/signals';

const directions = [
  [0, 1],
  [1, 0],
  [-1, 0],
  [0, -1],
  [1, 1],
  [-1, -1],
  [-1, 1],
  [1, -1],
]

@Component({
  selector: 'app-root',
  imports: [Field],
  standalone: true,
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <main [style]="{width: '100%', display: 'flex', 'flex-direction': 'column', gap: '5px', 'justify-content': 'center', padding: '10px', 'box-sizing': 'border-box'}">
      <h1>Advent of Code: Day 4</h1>
      <textarea rows="12" [field]="input"></textarea>
      <p>Part 1: </p>
      <pre [style]="{padding: '10px', 'background-color': 'lightgray'}"><code>{{ part1() }}</code></pre>
      <hr />
      <p>Part 2:</p>
      <pre [style]="{padding: '10px', 'background-color': 'lightgray'}"><code>{{ part2() }}</code></pre>
    </main>
  `,
})
export class Day04 {
  inputModel = signal<string>(`..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.`);

  input = form(this.inputModel, x => debounce(x, 200));

  grid = computed(() => this
    .input()
    .value()
    .split('\n')
    .reduce((acc, line, row) => acc.union(
      new Set([...line]
        .map((x, col) => [x, row, col])
        .filter(x => x.at(0) === '@')
        .map(x => `${x.at(1)},${x.at(2)}`))),
      new Set<string>()
    )
  );

  removeRolls = (grid: Set<string>): Set<string> => new Set(
    Array.from(grid)
      .filter(x => directions
        .map(([drow, dcol]) => `${Number(x.split(",").at(0)) + drow},${Number(x.split(',').at(1)) + dcol}`)
        .filter(x => grid.has(x))
        .length < 4
      )
  );

  removeRollsRecursive = (grid: Set<string>): number => {
    const removedRolls = this.removeRolls(grid);
    if (removedRolls.size === 0) return 0;
    return this.removeRollsRecursive(grid.difference(removedRolls)) + removedRolls.size;
  }

  part1 = computed(() => this.removeRolls(this.grid()).size);
  part2 = computed(() => this.removeRollsRecursive(this.grid()));
}
