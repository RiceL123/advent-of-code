use regex::Regex;
use std::fs::File;
use std::io::Read;

fn main() {
    let mut f = File::open("src/input.txt").unwrap();
    // let mut f = File::open("src/input.txt").unwrap();
    let mut buffer = String::new();

    f.read_to_string(&mut buffer).unwrap();

    let file_line_arr: Vec<&str> = buffer.split("\n").collect();

    println!("task1: {}", task1(&file_line_arr));
    println!("task2: {}", task2(&file_line_arr));
}

fn task2(file_line_arr: &Vec<&str>) -> i32 {
    let re = Regex::new(r"[^.\d]").unwrap();
    let mut sum = 0;
    for (i, line) in file_line_arr.clone().into_iter().enumerate() {
        let symbols: Vec<regex::Match<'_>> = re.find_iter(line).collect();
        for symbol in symbols {
            sum += gear_ratio(file_line_arr, i, symbol.start());
        }
    }

    sum
}

fn gear_ratio(arr: &Vec<&str>, row: usize, col: usize) -> i32 {
    // check there are exactly 2 number parts

    let mut adjacent_numbers: Vec<u32> = Vec::new();

    // print check for numbers in row above and below
    for i in [row - 1, row + 1] {
        let adjacent_nums = arr[i].get(col - 1..col + 2).unwrap().char_indices();

        let mut bruh = adjacent_nums.clone();

        let mut adj_num = bruh.next();
        while adj_num.is_some() {
            let mut full_nums: Vec<u32> = Vec::new();
            let tuple = adj_num.unwrap_or_default();
            if tuple.1.is_numeric() {
                let mut num_str = String::new();

                let mut index = tuple.0 + col - 1;
                let mut c: char = ' ';

                if tuple.0 == 0 {
                    // search left
                    loop {
                        c = arr[i].chars().nth(index).unwrap_or_default();
                        if c.is_numeric() {
                            num_str.insert(0, c);
                        } else {
                            break;
                        }
                        if index == 0 {
                            break;
                        }
                        index -= 1;
                    }

                    index = tuple.0 + col;
                } else {
                    index = tuple.0 + col - 1;
                }

                // search right
                loop {
                    c = arr[i].chars().nth(index).unwrap_or_default();
                    if c.is_numeric() {
                        num_str.push(c);
                    } else {
                        break;
                    }
                    if index == arr[i].len() - 1 {
                        break;
                    }
                    index += 1;
                    adj_num = bruh.next();
                }

                full_nums.push(num_str.parse::<u32>().unwrap_or_default());
                adjacent_numbers.extend(&full_nums);
            }
            adj_num = bruh.next();
        }
    }

    // search left on the same row
    if arr[row].chars().nth(col - 1).unwrap().is_digit(10) {
        let mut index = col - 1;
        let mut value = 0;

        let mut i = 1;
        loop {
            if arr[row].chars().nth(index).unwrap().is_digit(10) {
                value += i * arr[row].chars().nth(index).unwrap().to_digit(10).unwrap();
            } else {
                break;
            }
            if index == 0 {
                break;
            }
            index -= 1;

            i *= 10;
        }

        adjacent_numbers.push(value);
    }

    // search right on same row
    if arr[row].chars().nth(col + 1).unwrap().is_digit(10) {
        let mut index = col + 1;
        let mut value = arr[row].chars().nth(index).unwrap().to_string();

        loop {
            index += 1;
            if arr[row].chars().nth(index).unwrap().is_digit(10) {
                value.push(arr[row].chars().nth(index).unwrap())
            } else {
                break;
            }
            if index == arr[row].len() - 1 {
                break;
            }
        }

        adjacent_numbers.push(value.parse::<u32>().unwrap_or_default());
    }

    if adjacent_numbers.len() == 2 {
        return adjacent_numbers[0] as i32 * adjacent_numbers[1] as i32;
    }

    0
}

fn task1(file_line_arr: &Vec<&str>) -> i32 {
    let re = Regex::new(r"\d+").unwrap();
    let mut sum = 0;
    for (i, line) in file_line_arr.clone().into_iter().enumerate() {
        let nums: Vec<regex::Match<'_>> = re.find_iter(line).collect();
        for num in nums {
            if is_adjacent_to_symbol(&file_line_arr, i, num.start(), num.end()) {
                sum += num.as_str().parse::<i32>().unwrap();
            }
        }
    }

    sum
}

fn is_adjacent_to_symbol(
    file_line_arr: &Vec<&str>,
    row: usize,
    start_col: usize,
    end_col: usize,
) -> bool {
    // check left
    let valid_left = start_col != 0;
    let valid_right = end_col + 1 <= file_line_arr[0].len();
    let valid_top = row != 0;
    let valid_bottom = row + 1 < file_line_arr.len();

    if valid_left {
        if is_symbol(file_line_arr[row].chars().nth(start_col - 1).unwrap()) {
            return true;
        }
    }

    if valid_right {
        if is_symbol(file_line_arr[row].chars().nth(end_col).unwrap()) {
            return true;
        }
    }

    if valid_top {
        let mut i = start_col;
        while i < end_col {
            if is_symbol(file_line_arr[row - 1].chars().nth(i).unwrap()) {
                return true;
            }
            i += 1;
        }
    }

    if valid_bottom {
        let mut i = start_col;
        while i < end_col {
            if is_symbol(file_line_arr[row + 1].chars().nth(i).unwrap()) {
                return true;
            }
            i += 1;
        }
    }

    // check corners

    if valid_left && valid_top {
        if is_symbol(file_line_arr[row - 1].chars().nth(start_col - 1).unwrap()) {
            return true;
        }
    }

    if valid_right && valid_top {
        if is_symbol(file_line_arr[row - 1].chars().nth(end_col).unwrap()) {
            return true;
        }
    }

    if valid_left && valid_bottom {
        if is_symbol(file_line_arr[row + 1].chars().nth(start_col - 1).unwrap()) {
            return true;
        }
    }

    if valid_right && valid_bottom {
        if is_symbol(file_line_arr[row + 1].chars().nth(end_col).unwrap()) {
            return true;
        }
    }

    return false;
}

fn is_symbol(char: char) -> bool {
    return "!@#$%^&*/_-+=[]{}\\|;':,/<>?\"`~".contains(char);
}
