use std::{collections::HashSet, io};

fn main() {
    let input = io::stdin().lines().map(|l| {
        let line = l.unwrap();
        return (line.as_bytes()[0] as char, line[2..].parse::<u8>().unwrap());
    });

    let mut knots = [(0i32, 0i32); 10];
    let mut visited: HashSet<(i32, i32)> = HashSet::new();

    visited.insert((0i32, 0i32));

    for (dir, step) in input {
        let (h_dx, h_dy) = match dir {
            'L' => (-1, 0),
            'R' => (1, 0),
            'U' => (0, 1),
            'D' => (0, -1),
            _ => panic!("unexpected direction"),
        };

        for _ in 0..step {
            knots[0].0 += h_dx;
            knots[0].1 += h_dy;

            for i in 1..10 {
                let (dx, dy) = match (knots[i - 1].0 - knots[i].0, knots[i - 1].1 - knots[i].1) {
                    (2, 0) => (1, 0),
                    (-2, 0) => (-1, 0),
                    (0, 2) => (0, 1),
                    (0, -2) => (0, -1),
                    (2, 2) | (2, 1) | (1, 2) => (1, 1),
                    (2, -2) | (2, -1) | (1, -2) => (1, -1),
                    (-2, 2) | (-2, 1) | (-1, 2) => (-1, 1),
                    (-2, -2) | (-2, -1) | (-1, -2) => (-1, -1),
                    _ => (0, 0),
                };

                knots[i].0 += dx;
                knots[i].1 += dy;
            }

            visited.insert(knots[9]);
        }
    }

    println!("{}", visited.len());
}
