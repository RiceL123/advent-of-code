use std::fs::File;
use std::io::{BufRead, BufReader};
use std::path::Path;

fn main() {
    let path = Path::new("src/input.txt");
    let file = File::open(path).unwrap();
    let reader = BufReader::new(file);

    let mut part_1 = 0;
    let mut part_2 = 0;

    let line_count = BufReader::new(File::open(path).expect("Failed to open file"))
        .lines()
        .count();

    let mut multiplier: Vec<i32> = vec![1; line_count];

    for (row, line) in reader.lines().enumerate() {
        let (num_matches, num_scratchcards): (i32, i32) = calc(&line.unwrap()[9..], &mut multiplier, row);
        part_1 += num_matches;
        part_2 += num_scratchcards;
    }

    println!("part 1: {}", part_1);
    println!("part 2: {}", part_2);
}

fn calc(line: &str, multiplier: &mut Vec<i32>, row: usize) -> (i32, i32) {
    if let Some((winning_card_str, input_card_str)) = line.split_once(" | ") {
        let winning_cards: Vec<&str> = winning_card_str.split_whitespace().collect();
        let input_cards: Vec<&str> = input_card_str.split_whitespace().collect();

        let num_matching_cards = input_cards
            .into_iter()
            .filter(|x| winning_cards.contains(x))
            .collect::<Vec<&str>>()
            .len();

        for i in row + 1..row + 1 + num_matching_cards {
            multiplier[i] += 1 * multiplier[row];
        }

        if num_matching_cards > 0 {
            return ((2 as i32).pow((num_matching_cards as u32) - 1), num_matching_cards as i32 * multiplier[row] + 1);
        }
        return (0, num_matching_cards as i32 * multiplier[row] + 1)
    }

    (0, 1)
}
