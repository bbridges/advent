use std::io;

fn main() {
    let input = io::stdin().lines().map(|l| {
        l.unwrap()
            .split(|c: char| !c.is_numeric())
            .map(|s| s.parse::<u8>().unwrap())
            .collect::<Vec<_>>()
    });

    let count = input.filter(|l| l[0] <= l[3] && l[1] >= l[2]).count();

    println!("{}", count);
}
