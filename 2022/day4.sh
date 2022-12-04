#!/bin/sh

file="day4.txt"

# part 1
awk -F'[-,]' '{a=$1-$3; b=$2-$4; print (- (a < 0) + (a > 0))+(- (b < 0) + (b > 0))}' "$file" | grep '[10]' | wc -l

# part 2
awk -F'[-,]' '{if ((($1 >= $3) && ($1 <= $4)) || (($3 >= $1) && ($3 <= $2))) {print(1)}}' "$file" | wc -l

# python script thats meant to do a similar thing idk lmao
# with open("day4.txt") as f:
#     total = 0
#     for line in f:
#         line = line.split('\n')
#         ranges = line[0].split(',')
#         nums = [[],[]]
#         for i in range(2):
#             nums[i] = ranges[i].split('-')
#             nums[i][0] = int(nums[i][0])
#             nums[i][1] = int(nums[i][1])
#         if (nums[0][0] >= nums[1][0] and nums[0][0] <= nums[1][1]):
#             total += 1
#         elif (nums[1][0] >= nums[0][0] and nums[1][0] <= nums[0][1]):
#             total += 1

# print(total)
