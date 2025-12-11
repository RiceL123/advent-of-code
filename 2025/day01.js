const fs = require("fs");

const rotations = fs
  .readFileSync("./day01.txt")
  .toString('ascii')
  .split('\n')
  .filter(x => x !== '')
  .map(x => ([x[0], Number(x.slice(1))]));

console.log(
  "part1: " +
  rotations.reduce(([dial, zeros], [operation, value]) => {
    if (operation == 'L') {
      dial -= value;
      dial = (dial % 100 + 100) % 100;
    } else if (operation == 'R') {
      dial += value;
      dial %= 100
    }

    return [dial, dial === 0 ? zeros + 1 : zeros];
  }, [50, 0])[1]
)

console.log(
  "part2: " +
  rotations.reduce(([dial, zeros], [operation, distance]) => {
    let newZeros = 0;

    if (operation === 'R') {
      if (dial !== 0) {
        let clicksToZero = 100 - dial;
        if (clicksToZero <= distance) {
          newZeros++;
          let remaining = distance - clicksToZero;
          newZeros += Math.floor(remaining / 100);
        }
      } else {
        newZeros += Math.floor(distance / 100);
      }

      dial = (dial + distance) % 100;
    } else if (operation === 'L') {
      if (dial !== 0) {
        let clicksToZero = dial;
        if (clicksToZero <= distance) {
          newZeros++;
          let remaining = distance - clicksToZero;
          newZeros += Math.floor(remaining / 100);
        }
      } else {
        newZeros += Math.floor(distance / 100);
      }

      dial -= distance;
      dial = (dial % 100 + 100) % 100;
    }

    return [dial, zeros + newZeros];
  }, [50, 0])[1]
)
