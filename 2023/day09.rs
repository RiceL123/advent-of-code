use std::fs;
use nalgebra::DMatrix;

fn main() {
    let lines = fs::read_to_string("src/input.txt")
        .expect("couldn't open file")
        .lines()
        .map(|x| {
            x.split_whitespace()
                .map(|x| x.parse::<i32>().expect("num = NaN"))
                .collect::<Vec<i32>>()
        })
        .collect::<Vec<Vec<i32>>>();

    println!("part1: {}", part1(&lines));
    println!("part2: {}", part2(&lines));
}

// https://en.wikipedia.org/wiki/Polynomial_interpolation something something
fn polynomial_interpolation(x_values: &[f64], y_values: &[f64], degree: usize, x: f64) -> f64 {
    // Create a Vandermonde matrix for the given degree
    let vandermonde = DMatrix::from_iterator(
        x_values.len(),
        degree + 1,
        (0..=degree).flat_map(|d| x_values.iter().map(move |&x| x.powi(d as i32))),
    );

    // Create a column vector for the y values
    let y_column = DMatrix::from_iterator(y_values.len(), 1, y_values.iter().copied());

    // Solve the linear system using LU decomposition
    let lu = vandermonde.lu();
    let coefficients = lu.solve(&y_column).unwrap();

    // Evaluate the polynomial at the given x value
    let mut result = 0.0;
    for (i, &coeff) in coefficients.iter().enumerate() {
        result += coeff * x.powi(i as i32);
    }

    result
}

fn part1(lines: &Vec<Vec<i32>>) -> i64 {
    lines
        .iter()
        .map(|nums| {
            let len = nums.len();
            let xs = (0..len).map(|x| x as f64).collect::<Vec<f64>>();
            let ys = nums.into_iter().map(|x| *x as f64).collect::<Vec<f64>>();

            let res = polynomial_interpolation(&xs, &ys, len - 1, len as f64);

            res.round() as i64
        })
        .sum()
}

fn part2(lines: &Vec<Vec<i32>>) -> i64 {
    lines
        .iter()
        .map(|nums| {
            let len = nums.len();
            let xs = (0..len).map(|x| x as f64).collect::<Vec<f64>>();
            let ys = nums.into_iter().map(|x| *x as f64).collect::<Vec<f64>>();

            let res = polynomial_interpolation(&xs, &ys, len - 1, -1.0);

            res.round() as i64
        })
        .sum()
}