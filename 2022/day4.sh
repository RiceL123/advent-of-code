#!/bin/sh

file="day4.txt"

# part 1
awk -F'[-,]' '{a=$1-$3; b=$2-$4; print (- (a < 0) + (a > 0))+(- (b < 0) + (b > 0))}' "$file" | grep '[10]' | wc -l

# part 2
awk -F'[-,]' '{if ((($1 >= $3) && ($1 <= $4)) || (($3 >= $1) && ($3 <= $2))) {print(1)}}' "$file" | wc -l
