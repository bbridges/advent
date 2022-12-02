use std::io;

fn main() {
    let mut input: Vec<Option<u32>> = io::stdin()
        .lines()
        .map(|l| l.unwrap().parse::<u32>().ok())
        .collect();

    input.push(None);

    let mut max_calories = vec![];
    let mut curr_calories = 0;

    for line in input {
        if let Some(cals) = line {
            curr_calories += cals;
        } else {
            max_calories.push(curr_calories);
            curr_calories = 0;
        }
    }

    max_calories.sort_unstable_by(|a, b| b.cmp(a));

    println!("{}", max_calories.iter().take(3).sum::<u32>());
}
