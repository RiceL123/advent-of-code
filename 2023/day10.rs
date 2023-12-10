use std::fs;

fn main() {
    let mut start: (usize, usize) = (0, 0);
    let lines = fs::read_to_string("src/input.txt")
        .expect("couldn't open file")
        .lines()
        .enumerate()
        .map(|(row_index, x)| {
            let row = x.chars().collect::<Vec<char>>();

            match row.iter().position(|&x| x == 'S') {
                Some(col) => start = (row_index, col),
                _ => {}
            }

            row
        })
        .collect::<Vec<Vec<char>>>();

    println!("start: {:?}", start);

    part1(&start, &lines);
}

fn part1(start: &(usize, usize), lines: &Vec<Vec<char>>) {
    let neigbouring_cells: Vec<(_, _)> = [
        if start.0 > 0 {
            Ok(((start.0 - 1, start.1), "up"))
        } else {
            Err(())
        }, // up
        if start.1 < lines[0].len() - 1 {
            Ok(((start.0, start.1 + 1), "right"))
        } else {
            Err(())
        }, // right
        if start.0 < lines.len() - 1 {
            Ok(((start.0 + 1, start.1), "down"))
        } else {
            Err(())
        }, // down
        if start.1 > 0 {
            Ok(((start.0, start.1 - 1), "left"))
        } else {
            Err(())
        }, // left
    ]
    .iter()
    .filter_map(|&result| result.ok())
    .collect();

    let mut visited = lines.clone();
    visited[start.0][start.1] = 'O';

    for (i, dir) in neigbouring_cells {
        match dir {
            "up" => match lines[i.0][i.1] {
                '|' | '7' | 'F' => {
                    println!("{:?}", dfs(&i, &lines, &mut visited));
                }
                _ => {}
            },
            "right" => match lines[i.0][i.1] {
                '-' | '7' | 'J' => {
                    println!("{:?}", dfs(&i, &lines, &mut visited));
                }
                _ => {}
            },
            "down" => match lines[i.0][i.1] {
                '|' | 'L' | 'J' => {
                    println!("{:?}", dfs(&i, &lines, &mut visited));
                }
                _ => {}
            },
            "left" => match lines[i.0][i.1] {
                '-' | 'L' | 'F' => {
                    println!("{:?}", dfs(&i, &lines, &mut visited));
                }
                _ => {}
            },
            _ => panic!(),
        }
        // println!("{:?}: {:?}", i, graph[i.0][i.1]);
    }

    // visited.iter().for_each(|row| {
    //     let mut s = String::new();
    //     row.iter().for_each(|&c| s.push(c));
    //     println!("{s}");
    // });
}

fn dfs(curr: &(usize, usize), graph: &Vec<Vec<char>>, visited: &mut Vec<Vec<char>>) -> u32 {
    let neigbouring_cells: Vec<(_, _)> = [
        if curr.0 > 0 && ['|', 'L', 'J'].contains(&graph[curr.0][curr.1]) {
            Ok(((curr.0 - 1, curr.1), "up"))
        } else {
            Err(())
        }, // up
        if curr.1 < graph[0].len() - 1 && ['-', 'L', 'F'].contains(&graph[curr.0][curr.1]) {
            Ok(((curr.0, curr.1 + 1), "right"))
        } else {
            Err(())
        }, // right
        if curr.0 < graph.len() - 1 && ['|', 'F', '7'].contains(&graph[curr.0][curr.1]) {
            Ok(((curr.0 + 1, curr.1), "down"))
        } else {
            Err(())
        }, // down
        if curr.1 > 0 && ['-', 'J', '7'].contains(&graph[curr.0][curr.1]) {
            Ok(((curr.0, curr.1 - 1), "left"))
        } else {
            Err(())
        }, // left
    ]
    .iter()
    .filter_map(|&result| result.ok())
    .collect();

    visited[curr.0][curr.1] = 'O';
    // visited.iter().for_each(|row| {
    //     let mut s = String::new();
    //     row.iter().for_each(|&c| s.push(c));
    //     println!("{s}");
    // });
    // println!("curr: {:?}", curr);

    for (i, dir) in neigbouring_cells {
        if visited[i.0][i.1] == 'O' {
            continue;
        }
        if graph[i.0][i.1] == 'S' {
            return 1;
        }
        match dir {
            "up" => match graph[i.0][i.1] {
                '|' | '7' | 'F' => {
                    return dfs(&i, &graph, visited) + 1;
                }
                _ => {}
            },
            "right" => match graph[i.0][i.1] {
                '-' | '7' | 'J' => {
                    return dfs(&i, &graph, visited) + 1;
                }
                _ => {}
            },
            "down" => match graph[i.0][i.1] {
                '|' | 'L' | 'J' => {
                    return dfs(&i, &graph, visited) + 1;
                }
                _ => {}
            },
            "left" => match graph[i.0][i.1] {
                '-' | 'L' | 'F' => {
                    return dfs(&i, &graph, visited) + 1;
                }
                _ => {}
            },
            _ => panic!(),
        }
        // println!("{:?}: {:?}", i, graph[i.0][i.1]);
    }

    // println!("dead end {:?}: ", curr);
    // visited[curr.0][curr.1] = 'D';
    // visited.iter().for_each(|row| {
    //     let mut s = String::new();
    //     row.iter().for_each(|&c| s.push(c));
    //     println!("{s}");
    // });
    0
}
