use std::{collections::HashSet, io};

fn main() {
    let input = io::stdin().lines().map(|l| {
        let line = l.unwrap();
        return (line.as_bytes()[0] as char, line[2..].parse::<u8>().unwrap());
    });

    let mut head_xy = (0i32, 0i32);
    let mut tail_xy = (0i32, 0i32);
    let mut visited: HashSet<(i32, i32)> = HashSet::new();

    visited.insert(tail_xy);

    for (dir, step) in input {
        let (h_dx, h_dy) = match dir {
            'L' => (-1, 0),
            'R' => (1, 0),
            'U' => (0, 1),
            'D' => (0, -1),
            _ => panic!("unexpected direction"),
        };

        for _ in 0..step {
            head_xy.0 += h_dx;
            head_xy.1 += h_dy;

            let (t_dx, t_dy) = match (head_xy.0 - tail_xy.0, head_xy.1 - tail_xy.1) {
                (2, 0) => (1, 0),
                (-2, 0) => (-1, 0),
                (0, 2) => (0, 1),
                (0, -2) => (0, -1),
                (2, 1) | (1, 2) => (1, 1),
                (2, -1) | (1, -2) => (1, -1),
                (-2, 1) | (-1, 2) => (-1, 1),
                (-2, -1) | (-1, -2) => (-1, -1),
                _ => (0, 0),
            };

            tail_xy.0 += t_dx;
            tail_xy.1 += t_dy;

            visited.insert(tail_xy);
        }
    }

    println!("{}", visited.len());
}
