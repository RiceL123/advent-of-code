use std::{fs::{File, self}, io::{BufReader, BufRead}, collections::HashMap, path::Path};
fn main() {
    let path = Path::new("src/test.txt");
    let file = File::open(&path).expect("couldn't open file");
    let mut reader = BufReader::new(&file);

    let mut instructions = String::new();
    reader.read_line(&mut instructions).expect("couldn't read line");
    
    let (elements_suffix_a, node_map) = file_to_node_map(&path);

    println!("part 1: {}", part1(&instructions.trim(), &node_map));
    println!("part 2: {}", part2(&instructions.trim(), &node_map, &elements_suffix_a));
}

fn file_to_node_map(path: &Path) -> (Vec<String>, HashMap<String, (String, String)>) {
    let mut node_map: HashMap<String, (String, String)> = HashMap::new();
    let mut elements_suffix_a: Vec<String> = Vec::new();

    fs::read_to_string(path)
        .expect("couldn't open file")
        .lines()
        .skip(2)
        .map(|x| {
            let key = x.get(0..3).expect("no key").to_string();
            if key.chars().last().expect("key not a char") == 'A' { elements_suffix_a.push(key.clone()) }

            let left = x.get(7..10).expect("no left").to_string();
            let right = x.get(12..15).expect("no right").to_string();
            (key, (left, right))
        })
        .for_each(|(key, value)| { node_map.entry(key).or_insert(value); });

    (elements_suffix_a, node_map)
}

fn part1(instructions: &str, node_map: &HashMap<String, (String, String)>) -> u32 {
    let mut element = "AAA";
    let mut steps: u32 = 0;
    while element != "ZZZ" {
        for c in instructions.chars() {
            steps += 1;
            match c {
                'L' => element = &node_map.get(element).expect("left key not found").0,
                'R' => element = &node_map.get(element).expect("right key not found").1,
                _ => { eprintln!("!instruction.match([LR])")}
            }
        }
    }

    steps
}

fn part2(instructions: &str, node_map: &HashMap<String, (String, String)>, starting_elements: &Vec<String>) -> u64 {
    let mut steps: u64 = 0;

    let mut elements = starting_elements.clone();
    // println!("{:?}", elements);

    loop {
        for c in instructions.chars() {
            steps += 1;

            let mut i = 0;
            while i < elements.len() {
                match c {
                    'L' => elements[i] = node_map.get(&elements[i]).expect("left key not found").0.clone(),
                    'R' => elements[i] = node_map.get(&elements[i]).expect("right key not found").1.clone(),
                    _ => { eprintln!("!instruction.match([LR])")}
                }
                i += 1
            }

            if elements.iter().all(|x| x.chars().last().expect("elements Vec is not filled") == 'Z') { return steps; }
        }
    }
}   
