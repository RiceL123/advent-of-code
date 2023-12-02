use std::fs::File;
use std::io::{BufRead, BufReader};

fn main() -> Result<(), std::io::Error> {
    let input = File::open("src/input.txt")?;
    let reader = BufReader::new(input);

    let mut task_1 = 0;
    let mut task_2 = 0;

    for line in reader.lines() {
        match line {
            Ok(l) => {
                task_1 += add_game_id(&l);
                task_2 += add_power_set(&l);
            },
            Err(e) => eprint!("{}", e)
        }
    }

    println!("task1: {task_1}");
    println!("task2: {task_2}");
    Ok(())
}

fn add_game_id(line: &str) -> i32 {
    let c: Vec<&str> = line.split(":").collect();

    let game_id = &c[0][5..].parse::<i32>().unwrap();

    let games: Vec<&str> = c[1].split(";").collect();

    for game in games {
        let dice: Vec<&str> = game.split(",").collect();

        for die in dice {
            let num: Vec<&str> = die.split(" ").collect();
            let dice_count = num[1].parse::<i32>().unwrap();
            let color = num[2];
            
            match color {
                "red" if dice_count > 12 => return 0,
                "green" if dice_count > 13 => return 0,
                "blue" if dice_count > 14 => return 0,
                _ => {}
            }
        }
    }

    return *game_id;
}

fn add_power_set(line: &str) -> i32 {
    let c: Vec<&str> = line.split(":").collect();

    let games: Vec<&str> = c[1].split(";").collect();

    let mut red = 0;
    let mut green = 0;
    let mut blue = 0;

    for game in games {
        let dice: Vec<&str> = game.split(",").collect();

        for die in dice {
            let num: Vec<&str> = die.split(" ").collect();
            let dice_count = num[1].parse::<i32>().unwrap();
            let color = num[2];
            
            match color {
                "red" if dice_count > red => red = dice_count,
                "green" if dice_count > green => green = dice_count,
                "blue" if dice_count > blue => blue = dice_count,
                _ => {}
            }
        }
    }

    return red * green * blue;
}
