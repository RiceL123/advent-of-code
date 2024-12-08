import fs from "fs";

type Antennas = {
  [key: string]: [number, number][];
};

function file_to_antennas(file_path: string): [Antennas, [number, number]] {
  let antennas: Antennas = {};

  const lines = fs.readFileSync(file_path, "utf-8").split("\n");

  lines.forEach((line, row) => {
    line.split("").forEach((char, col) => {
      if (char == "." || char == "#") {
        return;
      }

      if (!antennas[char]) {
        antennas[char] = [[row, col]];
      } else {
        antennas[char].push([row, col]);
      }
    });
  });

  return [antennas, [lines.length, lines[0].length]];
}

function is_inbounds(
  antinode: [number, number],
  bounds: [number, number]
): boolean {
  return (
    antinode[0] >= 0 &&
    antinode[0] < bounds[0] &&
    antinode[1] >= 0 &&
    antinode[1] < bounds[1]
  );
}

function get_resonant_locations1(
  antenna_a: [number, number],
  antenna_b: [number, number],
  bounds: [number, number]
): [number, number][] {
  const row_distance = antenna_a[0] - antenna_b[0];
  const col_distance = antenna_a[1] - antenna_b[1];

  const resonant_locations: [number, number][] = [
    [antenna_a[0] + row_distance, antenna_a[1] + col_distance],
    [antenna_b[0] - row_distance, antenna_b[1] - col_distance],
  ];

  return resonant_locations.filter((x) => is_inbounds(x, bounds));
}

function get_resonant_locations2(
  antenna_a: [number, number],
  antenna_b: [number, number],
  bounds: [number, number]
): [number, number][] {
  const row_distance = antenna_a[0] - antenna_b[0];
  const col_distance = antenna_a[1] - antenna_b[1];

  const resonant_locations: [number, number][] = [];

  let location = antenna_a;
  while (is_inbounds(location, bounds)) {
    resonant_locations.push(location);
    location = [location[0] + row_distance, location[1] + col_distance];
  }

  location = antenna_b;
  while (is_inbounds(location, bounds)) {
    resonant_locations.push(location);
    location = [location[0] - row_distance, location[1] - col_distance];
  }

  return resonant_locations;
}

function count_antinodes(
  antennas: Antennas,
  bounds: [number, number],
  get_resonant_locations: (
    a: [number, number],
    b: [number, number],
    bounds: [number, number]
  ) => [number, number][]
): number {
  const antinodes: Set<string> = new Set();

  for (const pos of Object.values(antennas)) {
    for (let i = 0; i < pos.length; i++) {
      for (let j = i + 1; j < pos.length; j++) {
        get_resonant_locations(pos[i], pos[j], bounds).forEach((x) =>
          antinodes.add(x.toString())
        );
      }
    }
  }

  return antinodes.size;
}

let [antennas, [rows, cols]] = file_to_antennas("./day08.txt");
console.log(
  `part1: ${count_antinodes(antennas, [rows, cols], get_resonant_locations1)}`
);
console.log(
  `part2: ${count_antinodes(antennas, [rows, cols], get_resonant_locations2)}`
);
