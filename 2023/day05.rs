use std::fs;

fn main() {
    let part_1_seeds = fs::read_to_string("src/seeds.txt")
        .expect("unable to open seeds file")
        .get(6..)
        .expect("file does not start with 'seeds: '")
        .split_whitespace()
        .map(|x| return x.parse().expect("seed = NaN"))
        .collect::<Vec<i64>>();

    let part_2_seeds = part_1_seeds
        .windows(2)
        .map(|x| (x[0]..x[1]))
        .flat_map(|x| x)
        .collect::<Vec<i64>>();

    println!("{:?}", part_2_seeds);
    
    let maps = fs::read_to_string("src/input.txt")
        .expect("unable to open maps file")
        .split("\n\n")
        .into_iter()
        .map(|x| {
            let mut line = x
                .split("\n")
                .skip(1)
                .map(|x| {
                    let mut iter = x.splitn(3, ' ');
                    (
                        iter.next().expect("missing value").parse().expect("src = NaN"),
                        iter.next().expect("missing value").parse().expect("dest = NaN"),
                        iter.next().expect("missing value").parse().expect("range = NaN"),
                    )
                })
                .collect::<Vec<(i64, i64, i64)>>();

            line.sort_by_key(|k| k.0);
            line
        })
        .collect::<Vec<Vec<(i64, i64, i64)>>>();

    println!("part1: {}", part_1_seeds
        .into_iter()
        .map(|x| find_location(&maps, x))
        .min()
        .expect("no seeds")
    );

    println!("part1: {}", part_2_seeds
        .into_iter()
        .map(|x| find_location(&maps, x))
        .min()
        .expect("no seeds")
    );
}

fn find_location(maps: &Vec<Vec<(i64, i64, i64)>>, seed: i64) -> i64 {
    let mut id = seed;
    maps.iter().for_each(|map| {
        map.iter().any(|(src, dest, range)| {
            if id >= *dest && id <= *dest + *range {
                id += *src - *dest;
                true
            } else {
                false
            }
        });
    });

    // for map in maps {
    //     for (src, dest, range) in map {
    //         if id >= *dest && id <= *dest + *range {
    //             id += *src - *dest;
    //             break;
    //         }
    //     }
    // }

    id
}
