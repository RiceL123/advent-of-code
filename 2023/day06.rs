use std::{fs, path::Path};

fn main() {
    let path = Path::new("src/input.txt");

    let part1_races = part1(path);
    let part2_race = part2(path);

    let beat_record_combinations = part1_races
        .iter()
        .fold(1,|acc, (time, distance)| acc * num_ways_to_win(*time as f64, *distance as f64));

    println!("part1: {:?}", beat_record_combinations);
    println!("part2: {:?}", num_ways_to_win(part2_race.0 as f64, part2_race.1 as f64))
}

fn part2(path: &Path) -> (u64, u64) {
    let time_distance = fs::read_to_string(path)
    .expect("couldn't open file")
    .splitn(2, "\n")
    .into_iter()
    .map(|line| {
        line[10..]
            .trim()
            .replace(" ", "")
            .parse()
            .expect("time || dist === NaN")
    })
    .collect::<Vec<u64>>();

    (time_distance[0], time_distance[1])
}

fn part1(path: &Path) -> Vec<(u32, u32)> {
    let time_distance = fs::read_to_string(path)
        .expect("couldn't open file")
        .splitn(2, "\n")
        .into_iter()
        .map(|line| {
            line[10..]
                .split_whitespace()
                .into_iter()
                .map(|x| x.parse().expect("time || dist === NaN"))
                .collect::<Vec<u32>>()
        })
        .collect::<Vec<Vec<u32>>>();

    let races = time_distance[0].clone()
        .into_iter()
        .zip(time_distance[1].clone().into_iter())
        .collect::<Vec<(u32, u32)>>();

    races
}

fn num_ways_to_win(time: f64, distance: f64) -> i32 {
    // y = -x^2 + (time)x
    // to find the range of positive y values that are within the range,
    // vertical shift curve down; y = -x^2 + (time)x - distance
    // so that x-intercepts correspond to lower and upper range bounds non-inclusive

    // quadratic formula x = (-b±√(b²-4ac))/(2a)
    let a: f64 = -1.0;
    let b = time;
    let c = -distance;

    let mut lower = (-b + (b * b - 4.0 * a * c).sqrt()) / (2.0 * a);
    let mut upper = (-b - (b * b - 4.0 * a * c).sqrt()) / (2.0 * a);

    // ranges must be strictly greater than the distance - lower and upper are non-inclusive
    if upper - upper.floor() == 0.0 { upper = upper.floor() - 1.0 }
    if lower.ceil() - lower == 0.0 { lower = lower.ceil() + 1.0 }
    
    (upper.floor() - lower.ceil()) as i32 + 1
}
