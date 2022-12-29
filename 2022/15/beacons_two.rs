use regex::Regex;
use std::io;

fn main() {
    let re =
        Regex::new(r"x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)").unwrap();

    let input = io::stdin()
        .lines()
        .map(|line| {
            let l = &line.unwrap();
            let c = re.captures(l).unwrap();
            [
                c[1].parse::<i32>().unwrap(),
                c[2].parse::<i32>().unwrap(),
                c[3].parse::<i32>().unwrap(),
                c[4].parse::<i32>().unwrap(),
            ]
        })
        .collect::<Vec<_>>();

    let limit = 4000000;

    for y in 0..=limit {
        let mut ranges = input
            .iter()
            .filter_map(|[sx, sy, bx, by]| {
                let d = (bx - sx).abs() + (by - sy).abs();
                let w = d - (sy - y).abs();

                if w < 0 {
                    None
                } else {
                    Some([sx - w, sx + w + 1])
                }
            })
            .collect::<Vec<_>>();

        ranges.sort();

        let mut highest_found = ranges[0][1];

        for i in 1..ranges.len() {
            if highest_found > limit {
                break;
            }

            if highest_found > 0 && ranges[i][0] > highest_found {
                println!("{}", 4000000 * (highest_found as i64) + (y as i64));
                return;
            }

            highest_found = highest_found.max(ranges[i][1]);
        }
    }
}
