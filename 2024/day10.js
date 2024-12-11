import fs from "fs";

const directions = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1],
];

Array.prototype.sum = function () {
  return this.reduce((acc, x) => acc + x, 0);
};

function file_to_map_and_start_pos(file_path) {
  const start_positions = [];

  const map = fs
    .readFileSync(file_path, "ascii")
    .split("\n")
    .map((x, row) =>
      x.split("").map((x, col) => {
        const num = parseInt(x);
        if (num == 0) {
          start_positions.push([row, col]);
        }
        return num;
      })
    );

  return [map, start_positions];
}

function calculate_score(map, pos, visited, height) {
  if (height == 9) {
    visited.add(pos.toString());
    return 1;
  }

  return directions
    .filter(([d_row, d_col]) => {
      let [row, col] = [pos[0] + d_row, pos[1] + d_col];
      return (
        row >= 0 &&
        row < map.length &&
        col >= 0 &&
        col < map[0].length &&
        !visited.has([row, col].toString()) &&
        map[row][col] === height + 1
      );
    })
    .map(([d_row, d_col]) => {
      const pos_new = [pos[0] + d_row, pos[1] + d_col];
      visited.add(pos.toString());
      return calculate_score(map, pos_new, visited, height + 1);
    })
    .sum();
}

function calculate_rating(map, pos, height) {
  if (height == 9) {
    return 1;
  }

  return directions
    .filter(([d_row, d_col]) => {
      let [row, col] = [pos[0] + d_row, pos[1] + d_col];
      return (
        row >= 0 &&
        row < map.length &&
        col >= 0 &&
        col < map[0].length &&
        map[row][col] === height + 1
      );
    })
    .map(([d_row, d_col]) => {
      const pos_new = [pos[0] + d_row, pos[1] + d_col];
      return calculate_rating(map, pos_new, height + 1);
    })
    .sum();
}

const [map, start_positions] = file_to_map_and_start_pos("day10.txt");

const score = start_positions
  .map((x) => calculate_score(map, x, new Set(), 0))
  .sum();
console.log(`part1: ${score}`);

const rating = start_positions
  .map((x) => calculate_rating(map, x, 0))
  .sum();
console.log(`part2: ${rating}`);
