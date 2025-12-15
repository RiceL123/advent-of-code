import React, { useState, useEffect } from 'react'

const test = `987654321111111
811111111111119
234234234234278
818181911112111`

export const useDebounce = (value, delay = 500) => {
  const [debouncedValue, setDebouncedValue] = useState(value);

  useEffect(() => {
    const timeout = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => clearTimeout(timeout);
  }, [value, delay]);

  return debouncedValue;
};

const getJoltageFromBank = (bank, remainingBatteries, joltage) => {
  if (remainingBatteries === 1) return joltage + Math.max(...bank);
  if (bank.length === remainingBatteries) return joltage + bank.join("");
  const battery = Math.max(...bank.slice(0, -remainingBatteries + 1))
  const index = bank.slice(0, -remainingBatteries + 1).indexOf(battery)
  return getJoltageFromBank(bank.slice(index + 1), remainingBatteries - 1, joltage + battery)
}

const getOutputJoltage = (input, batteries) => input
  .trim()
  .split('\n')
  .map(bank => [...bank].map(Number))
  .map(bank => getJoltageFromBank(bank, batteries, ''))
  .map(Number)
  .reduce((acc, x) => acc + x)

const Day03 = () => {
  const [part1, setPart1] = useState('...');
  const [part2, setPart2] = useState('...');
  const [input, setInput] = useState(test);
  const debouncedInput = useDebounce(input);

  useEffect(() => {
    setPart1(getOutputJoltage(debouncedInput, 2));
    setPart2(getOutputJoltage(debouncedInput, 12));
  }, [debouncedInput]);

  return (
    <main style={{ display: 'flex', flexDirection: 'column', maxWidth: '400px', marginInline: 'auto', gap: '5px', alignItems: 'stretch' }}>
      <h1>Day 3 - Advent of Code 2025</h1>
      <textarea value={input} onChange={e => setInput(e.target.value)} rows={5} />
      <div style={{ display: 'flex', gap: '0.5em' }}>
        <button style={{ flexGrow: 1 }} onClick={() => setInput(test)}>Reset Input</button>
        <button style={{ flexGrow: 1 }} onClick={() => setPart1(getOutputJoltage(input, 2)) && setPart2(getOutputJoltage(input, 12))}>Get Output Joltage</button>
      </div>
      <hr style={{ width: '100%' }} />
      <div style={{ display: 'flex', alignItems: 'center', gap: '0.5em' }}>
        <p>Part 1:</p>
        <pre style={{ backgroundColor: 'lightgray', padding: '8px' }}><code>{part1}</code></pre>
      </div>
      <hr style={{ width: '100%' }} />
      <div style={{ display: 'flex', alignItems: 'center', gap: '0.5em' }}>
        <p>Part 2:</p>
        <pre style={{ backgroundColor: 'lightgray', padding: '8px' }}><code>{part2}</code></pre>
      </div>
      <hr style={{ width: '100%' }} />
    </main>
  )
}

export default Day03
