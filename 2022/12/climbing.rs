use std::{
    cmp::{self, Ordering},
    collections::BinaryHeap,
    io,
};

fn main() {
    let mut input = io::stdin()
        .lines()
        .map(|l| l.unwrap().bytes().collect::<Vec<_>>())
        .collect::<Vec<_>>();

    fn locate_point(input: &Vec<Vec<u8>>, point: u8) -> (usize, usize) {
        input
            .iter()
            .enumerate()
            .find_map(|(i, l)| {
                l.iter()
                    .enumerate()
                    .find_map(|(j, &c)| (c == point).then(|| (i, j)))
            })
            .unwrap()
    }

    fn distance(input: &Vec<Vec<u8>>, (x1, y1): (usize, usize), (x2, y2): (usize, usize)) -> usize {
        let h1 = input[x1][y1];
        let h2 = input[x2][y2];
        let dist = x1.abs_diff(x2) + y1.abs_diff(y2);

        if h2 > h1 {
            cmp::max((h2 - h1) as usize, dist)
        } else {
            dist
        }
    }

    let start = locate_point(&input, b'S');
    let end = locate_point(&input, b'E');

    input[start.0][start.1] = b'a';
    input[end.0][end.1] = b'z';

    let h = input.len();
    let w = input[0].len();

    let mut open_set = BinaryHeap::new();
    let mut steps = vec![vec![usize::MAX; w]; h];
    open_set.push(State {
        dist: distance(&input, start, end),
        loc: start,
    });
    steps[start.0][start.1] = 0;

    while let Some(State {
        loc: loc @ (i, j), ..
    }) = open_set.pop()
    {
        let curr_steps = steps[i][j];

        if loc == end {
            println!("{}", curr_steps);
            break;
        }

        let max_allowed = input[i][j] + 1;
        let next_steps = curr_steps + 1;
        let mut dirs = vec![];

        if i != 0 {
            dirs.push((i - 1, j));
        }

        if i != h - 1 {
            dirs.push((i + 1, j));
        }

        if j != 0 {
            dirs.push((i, j - 1));
        }

        if j != w - 1 {
            dirs.push((i, j + 1));
        }

        for next @ (x, y) in dirs {
            let in_range = (0..h).contains(&x) && (0..w).contains(&y);

            if in_range && steps[x][y] == usize::MAX && input[x][y] <= max_allowed {
                open_set.push(State {
                    dist: next_steps + distance(&input, next, end),
                    loc: next,
                });
                steps[x][y] = next_steps;
            }
        }
    }
}

#[derive(Eq, PartialEq)]
struct State {
    dist: usize,
    loc: (usize, usize),
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        other.dist.cmp(&self.dist)
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}
