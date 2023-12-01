use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() {
    let path = "src/day01.txt";

    let file = File::open(&path).expect("plz open blud");
    let reader = BufReader::new(file);

    let mut task_1_sum = 0;
    let mut task_2_sum = 0;

    for line in reader.lines() {
        match line {
            Ok(l) => {
                task_1_sum += task1(&l);
                task_2_sum += task2(&l);
            }
            Err(err) => eprintln!("Error: {}", err),
        }
    }

    println!("task1: {}", task_1_sum);
    println!("task2: {}", task_2_sum);
}

fn task1(line: &str) -> i32 {
    let mut first: i32 = 0;
    let mut end: i32 = 0;

    for c in line.chars() {
        if c.is_numeric() {
            first = c as i32 - 0x30;
            break;
        }
    }

    for c in line.chars().rev() {
        if c.is_numeric() {
            end = c as i32 - 0x30;
            break;
        }
    }

    return first * 10 + end;
}

fn get_word_number(str: &str) -> Option<i32> {
    let word_numbers = [
        "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    ];

    for (number, word_number) in word_numbers.iter().enumerate() {
        match str.find(word_number) {
            Some(_) => return Some(number as i32 + 1),
            None => continue,
        }
    }

    None
}

fn task2(line: &str) -> i32 {
    let mut first = 0;
    let mut last = 0;

    for (i, c) in line.chars().enumerate() {
        if c.is_numeric() {
            first = c as i32 - 0x30;
            break;
        }

        match get_word_number(&line[..i + 1]) {
            Some(num) => {
                first = num;
                break;
            }
            None => continue,
        }
    }

    for i in (0..line.len()).rev() {
        let c = line.chars().nth(i).expect("yourmother");

        if c.is_numeric() {
            last = c as i32 - 0x30;
            break;
        }

        match get_word_number(&line[i..]) {
            Some(num) => {
                last = num;
                break;
            }
            None => continue,
        }
    }

    return first * 10 + last;
}
