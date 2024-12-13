use std::{collections::HashSet, fs};

fn main() {
    let connected_components = get_connected_components("./day12.txt");
    println!(
        "part1: {}",
        connected_components
            .iter()
            .map(|x| x.len() as i32 * perimeter(x))
            .sum::<i32>()
    );

    println!(
        "part2 : {}",
        connected_components
            .iter()
            .map(|x| x.len() as i32 * num_corners(x))
            .sum::<i32>()
    );
}

fn get_connected_components(file_path: &str) -> Vec<HashSet<(i32, i32)>> {
    let farm: Vec<String> = fs::read_to_string(file_path)
        .expect("file_path not found")
        .split("\n")
        .into_iter()
        .map(|x| x.to_string())
        .collect();

    let mut connected_components = Vec::new();

    farm.iter().enumerate().for_each(|(i, row)| {
        row.chars().enumerate().for_each(|(j, plant)| {
            if !connected_components
                .iter()
                .any(|component: &HashSet<_>| component.contains(&(i as i32, j as i32)))
            {
                let mut visited = HashSet::new();
                dfs(&farm, &mut visited, (i as i32, j as i32), plant);
                connected_components.push(visited);
            }
        });
    });

    connected_components
}

static DIRECTIONS: [(i32, i32); 4] = [(1, 0), (0, -1), (-1, 0), (0, 1)];
fn dfs(farm: &Vec<String>, visited: &mut HashSet<(i32, i32)>, pos: (i32, i32), plant: char) {
    visited.insert(pos);

    DIRECTIONS.iter().for_each(|(d_row, d_col)| {
        let row = pos.0 + d_row;
        let col = pos.1 + d_col;
        if row >= 0
            && row < farm.len() as i32
            && col >= 0
            && col < farm[0].len() as i32
            && !visited.contains(&(pos.0 + d_row, pos.1 + d_col))
            && farm[row as usize].chars().nth(col as usize).expect("💀") == plant
        {
            dfs(farm, visited, (pos.0 + d_row, pos.1 + d_col), plant);
        }
    });
}

fn perimeter(component: &HashSet<(i32, i32)>) -> i32 {
    component
        .iter()
        .map(|(row, col)| {
            DIRECTIONS
                .iter()
                .map(
                    |(d_row, d_col)| match component.contains(&(row + d_row, col + d_col)) {
                        true => 0,
                        false => 1,
                    },
                )
                .sum::<i32>()
        })
        .sum()
}

static DIAGONALS: [(i32, i32); 4] = [(1, 1), (-1, -1), (-1, 1), (1, -1)];
fn num_corners(component: &HashSet<(i32, i32)>) -> i32 {
    component
        .iter()
        .map(|(row, col)| {
            DIAGONALS
                .iter()
                .map(|(d_row, d_col)| {
                    let diagonal = (row + d_row, col + d_col);
                    let vertical = (row + d_row, *col);
                    let horizontal = (*row, col + d_col);

                    // if 45degress to either side of the diagonal both are empty or both are in the component (xor)
                    // then theres a corner at that diagonal
                    match (!component.contains(&diagonal)
                        && component.contains(&vertical) == component.contains(&horizontal))
                        || (component.contains(&diagonal)
                            && component.contains(&vertical) == false
                            && component.contains(&horizontal) == false)
                    {
                        true => 1,
                        false => 0,
                    }
                })
                .sum::<i32>()
        })
        .sum::<i32>()
}
