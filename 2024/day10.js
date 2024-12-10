import fs from "fs";

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

function calculate_score(map, pos, visisted, height) {
  if (height == 9) {
    visisted.add(pos.toString());
    return 1;
  }

  let score = 0;
  const directions = [
    [-1, 0],
    [0, 1],
    [1, 0],
    [0, -1],
  ];
  for (const [d_row, d_col] of directions) {
    const pos_new = [pos[0] + d_row, pos[1] + d_col];
    if (
      pos_new[0] >= 0 &&
      pos_new[0] < map.length &&
      pos_new[1] >= 0 &&
      pos_new[1] < map[0].length &&
      !visisted.has(pos_new.toString()) &&
      map[pos_new[0]][pos_new[1]] === height + 1
    ) {
      score += calculate_score(map, pos_new, visisted, height + 1);
      visisted.add(pos.toString());
    }
  }

  return score;
}

function calculate_rating(map, pos, height) {
  if (height == 9) {
    return 1;
  }

  let score = 0;
  const directions = [
    [-1, 0],
    [0, 1],
    [1, 0],
    [0, -1],
  ];
  for (const [d_row, d_col] of directions) {
    const pos_new = [pos[0] + d_row, pos[1] + d_col];
    if (
      pos_new[0] >= 0 &&
      pos_new[0] < map.length &&
      pos_new[1] >= 0 &&
      pos_new[1] < map[0].length &&
      map[pos_new[0]][pos_new[1]] === height + 1
    ) {
      score += calculate_rating(map, pos_new, height + 1);
    }
  }

  return score;
}

const [map, start_positions] = file_to_map_and_start_pos("day10.txt");
const score = start_positions.reduce(
  (acc, x) => acc + calculate_score(map, x, new Set(), 0),
  0
);
console.log(`part1: ${score}`);

const rating = start_positions.reduce(
  (acc, x) => acc + calculate_rating(map, x, 0),
  0
);
console.log(`part2: ${rating}`);
