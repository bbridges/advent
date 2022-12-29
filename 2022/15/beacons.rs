use regex::Regex;
use std::io;

fn main() {
    let re =
        Regex::new(r"x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)").unwrap();

    let input = io::stdin().lines().map(|line| {
        let l = &line.unwrap();
        let c = re.captures(l).unwrap();
        [
            c[1].parse::<i32>().unwrap(),
            c[2].parse::<i32>().unwrap(),
            c[3].parse::<i32>().unwrap(),
            c[4].parse::<i32>().unwrap(),
        ]
    });

    let y = 2000000;

    let mut ranges = input
        .filter_map(|[sx, sy, bx, by]| {
            let d = (bx - sx).abs() + (by - sy).abs();
            let w = d - (sy - y).abs();

            if w < 0 {
                None
            } else if by != y {
                Some([sx - w, sx + w + 1])
            } else if w == 0 {
                None
            } else if bx < sx {
                Some([sx - w + 1, sx + w + 1])
            } else {
                Some([sx - w, sx + w])
            }
        })
        .collect::<Vec<_>>();

    ranges.sort();

    let mut count = 0;
    let mut last_counted = i32::MIN;

    for [l, r] in ranges {
        count += last_counted.max(r) - last_counted.max(l);
        last_counted = last_counted.max(r);
    }

    println!("{:?}", count);
}
