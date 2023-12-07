use std::fs;

fn main() {
    let file_str = fs::read_to_string("src/input.txt")
        .expect("couldn't open file");

    let part1_races = part1(&file_str);
    let part2_race = part2(&file_str);

    let beat_record_combinations = part1_races
        .iter()
        .fold(1,|acc, (time, distance)| acc * num_ways_to_win_opt(*time as f64, *distance as f64));

    println!("part1: {:?}", beat_record_combinations);

    // num_ways_to_win_opt may return an incorrect value off by a small margin
    println!("part2: {:?}", num_ways_to_win(part2_race.0 as f64, part2_race.1 as f64))
}

fn part2(input: &String) -> (u64, u64) {
    let time_distance = input
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

fn part1(input: &String) -> Vec<(u32, u32)> {
    let time_distance = input
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

fn num_ways_to_win_opt(time: f64, distance: f64) -> i32 {
    // 0 = ax^2 + bx + c
    // a = -1
    // distance between x intercepts given the function is concave down
    // (-b-√(b²-4ac))/(2a) - (-b+√(b²-4ac))/(2a)
    // ((-b-√(b²-4ac)) - (-b+√(b²-4ac))) / (2a)
    // (-2√(b²-4ac)) / (2a)
    // (-√(b²-4ac)) / (a)
    // √(b²-4c); when subbing in a = -1
    
    let range = (time * time + 4.0 * -distance).sqrt();
    
    // since we need the range between the x-intercepts to be non-inclusive
    if (range - range.floor()).abs() < f64::EPSILON {
        return range as i32 - 1;
    }

    range as i32
}
