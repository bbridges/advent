use std::io;

fn main() {
    let input = io::stdin()
        .lines()
        .map(|l| {
            l.unwrap()
                .split(" -> ")
                .map(|s| {
                    let (x, y) = s.split_once(",").unwrap();
                    (x.parse::<usize>().unwrap(), y.parse::<usize>().unwrap())
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    // Initialize cave.
    let (xs, ys): (Vec<usize>, Vec<usize>) = input.iter().flatten().cloned().unzip();
    let x_max = xs.iter().max().unwrap() + 1;
    let x_min = xs.iter().min().unwrap() - 1;
    let &y_max = ys.iter().max().unwrap();

    let mut cave = vec![vec![b'.'; x_max - x_min + 1]; y_max + 1];

    // Fill in rock lines.
    for line in input {
        for pair in line.windows(2) {
            let l = pair[0];
            let r = pair[1];

            if l.0 < r.0 {
                for x in l.0..r.0 {
                    cave[l.1][x - x_min] = b'#';
                }
            } else if l.0 > r.0 {
                for x in (r.0 + 1)..=l.0 {
                    cave[l.1][x - x_min] = b'#';
                }
            } else if l.1 < r.1 {
                for y in l.1..r.1 {
                    cave[y][l.0 - x_min] = b'#';
                }
            } else {
                for y in (r.1 + 1)..=l.1 {
                    cave[y][l.0 - x_min] = b'#';
                }
            }
        }

        let last = line.last().unwrap();
        cave[last.1][last.0 - x_min] = b'#';
    }

    // Simulate sand.
    let sand_start_x = 500 - x_min;

    let mut sand_count = 0;
    let (mut x, mut y) = (sand_start_x, 0);

    loop {
        if y == y_max {
            break;
        }

        if cave[y + 1][x] == b'.' {
            y += 1;
        } else if cave[y + 1][x - 1] == b'.' {
            y += 1;
            x -= 1;
        } else if cave[y + 1][x + 1] == b'.' {
            y += 1;
            x += 1;
        } else {
            cave[y][x] = b'o';
            sand_count += 1;

            (x, y) = (sand_start_x, 0);
        }
    }

    println!("{}", sand_count);
}
