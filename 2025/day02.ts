import { readFileSync } from 'fs'

const filePath = process.argv[2]

const ranges = readFileSync(filePath)
  .toString('ascii')
  .trim()
  .split(',').map(x => {
    const [start, finish] = x.split('-')
    return [Number(start), Number(finish)]
  })
  .map(([start, finish]) => Array.from({ length: finish - start + 1 }, (x, i) => start + i))
  .flat()
  .map(String);

const print = (isInvalid: (x: string) => boolean) => ranges
  .filter(isInvalid)
  .map(Number)
  .reduce((acc, x) => acc + x, 0);

function* chunkGenerator(array: string, size: number) {
  for (let i = 0; i < array.length; i += size) {
    yield array.slice(i, i + size);
  }
}

const isInvalid1 = (x: string) => x.length % 2 === 0 && x.slice(0, x.length / 2) === x.slice(x.length / 2);
const isInvalid2 = (x: string) => Array
  .from({ length: Math.floor(x.length / 2) }, (_, i) => i + 1)
  .filter(window => x.length % window === 0)
  .some(window => [...chunkGenerator(x, window)].every(chunk => chunk === x.slice(0, window)));

console.log(`part1: ${print(isInvalid1)}`);
console.log(`part2: ${print(isInvalid2)}`);
