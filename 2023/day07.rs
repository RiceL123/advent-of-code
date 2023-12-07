use std::cmp::Ordering;
use std::collections::HashMap;

#[aoc(day7, part1)]
pub fn part1(input: &str) -> u64 {
    let mut cards = input
        .split("\n")
        .into_iter()
        .map(|line: &str| {
            let tuple = line.splitn(2, " ").collect::<Vec<&str>>();

            (
                Hand::new(tuple[0]),
                tuple[1].parse::<u64>().expect("bid amount = NaN"),
            )
        })
        .collect::<Vec<(Hand, u64)>>();

    cards.sort_by(|a, b| b.0.compare(&a.0));

    // println!("{:?}", cards);

    let sum = cards
        .iter()
        .enumerate()
        .fold(0, |acc, (i, (_, bid))| acc + bid * (i as u64 + 1));

    println!("{:?}", sum);

    sum
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    FiveOfAKind,
    FourOfAKind,
    FullHouse,
    ThreeOfAKind,
    TwoPair,
    OnePair,
    HighestCard,
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct Hand<'a>(&'a str, HandType);

impl<'a> Hand<'a> {
    fn new(cards: &'a str) -> Self {
        let mut card_counts = HashMap::new();

        for c in cards.chars() {
            *card_counts.entry(c).or_insert(0) += 1;
        }

        let max_count = *card_counts.values().max().unwrap_or(&0);

        let hand_type = match max_count {
            5 => HandType::FiveOfAKind,
            4 => HandType::FourOfAKind,
            3 => {
                if card_counts.values().any(|&count| count == 2) {
                    HandType::FullHouse
                } else {
                    HandType::ThreeOfAKind
                }
            }
            2 => {
                if card_counts.values().filter(|&&count| count == 2).count() == 2 {
                    HandType::TwoPair
                } else {
                    HandType::OnePair
                }
            }
            _ => HandType::HighestCard,
        };

        Self(cards, hand_type)
    }

    fn compare(&self, other: &Hand<'_>) -> Ordering {
        match self.1.cmp(&other.1) {
            Ordering::Equal => {
                for i in 0..5 {
                    let self_first_letter = self.0.chars().nth(i).unwrap_or(' ');
                    let other_first_letter = other.0.chars().nth(i).unwrap_or(' ');
                    let face_order = "AKQJT98765432";

                    let self_face_value = face_order.find(self_first_letter);
                    let other_face_value = face_order.find(other_first_letter);

                    let res = self_face_value.cmp(&other_face_value);
                    if res != Ordering::Equal {
                        return res;
                    }
                }

                return self.0.cmp(&other.0);
            }
            other => other,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        assert_eq!(
            part1("32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483"),
            6440
        );
    }

    #[test]
    fn test_part_2() {
        assert_eq!(
            part1("32T3K 765\nT55J5 684\nKK677 28\nKTJJT 220\nQQQJA 483"),
            5905
        );
    }
}
