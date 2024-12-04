package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	dat, err := os.ReadFile("day04.txt")
	if err != nil {
		panic(err)
	}
	word_search := strings.Split(string(dat), "\n")

	total_xmas_appears := 0
	total_x_mas_appears := 0
	for i, row := range word_search {
		for j, letter := range row {
			total_xmas_appears += xmas_appears(i, j, letter, word_search)
			total_x_mas_appears += x_mas_appears(i, j, letter, word_search)
		}
	}
	fmt.Println("part1: ", total_xmas_appears)
	fmt.Println("part2: ", total_x_mas_appears)
}

func All(chars []rune, f func(index int, char rune) bool) bool {
	for index, char := range chars {
		if !f(index, char) {
			return false
		}
	}
	return true
}

func xmas_appears(row int, col int, letter rune, word_search []string) int {
	matches := 0
	if letter != rune('X') {
		return matches
	}

	row_len := len(word_search)
	col_len := len(word_search[0])

	chars := []rune{'M', 'A', 'S'}

	//                       down    up       right   left   quad_4   quad_1   quad_2    quad_3
	directions := [][2]int{{1, 0}, {-1, 0}, {0, 1}, {0, -1}, {1, 1}, {1, -1}, {-1, -1}, {-1, 1}}

	for _, direction := range directions {
		if All(chars, func(index int, char rune) bool {
			i := row + direction[0]*(index+1)
			j := col + direction[1]*(index+1)
			return i >= 0 && i < row_len && j >= 0 && j < col_len && char == rune(word_search[i][j])
		}) {
			matches += 1
		}
	}

	return matches
}

func x_mas_appears(row int, col int, letter rune, word_search []string) int {
	matches := 0
	if letter != rune('A') {
		return matches
	}

	row_len := len(word_search)
	col_len := len(word_search[0])

	chars := []rune{'S', 'S', 'M', 'M'}

	// slide diagonals around directions and check for SSMM
	directions := [][2]int{{1, 1}, {1, -1}, {-1, -1}, {-1, 1}}
	for i := 0; i < len(directions); i++ {
		is_matching := true
		for j := 0; j < 4; j++ {
			row_i := row + (directions[(i+j)%len(directions)][0])
			col_i := col + (directions[(i+j)%len(directions)][1])
			if row_i < 0 || row_i >= row_len || col_i < 0 || col_i >= col_len || rune(word_search[row_i][col_i]) != chars[j] {
				is_matching = false
			}
		}

		if is_matching {
			matches += 1
			break
		}
	}

	return matches
}
