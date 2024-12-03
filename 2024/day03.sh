#!/bin/bash

# part1
cat day03.txt | grep -Eo 'mul\([[:digit:]]+,[[:digit:]]+\)' | sed -r 's/mul\((.+),(.+)\)/\1*\2/g' | xargs | sed -r 's/ /+/g' | bc 

# part2
echo $(cat day03.txt) | perl -pe "s/don\'t\(\).*?do?\(\)|(don't\(\).*?$)//g" | grep -Eo 'mul\([[:digit:]]+,[[:digit:]]+\)' | sed -r 's/mul\((.+),(.+)\)/\1*\2/g' | xargs | sed -r 's/ /+/g' | bc 