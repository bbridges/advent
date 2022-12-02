use std::io;

fn main() {
    let mut input: Vec<Option<u32>> = io::stdin()
        .lines()
        .map(|l| l.unwrap().parse::<u32>().ok())
        .collect();

    input.push(None);

    let mut max_calories = 0;
    let mut curr_calories = 0;

    for line in input {
        if let Some(cals) = line {
            curr_calories += cals;
        } else {
            if curr_calories > max_calories {
                max_calories = curr_calories;
            }

            curr_calories = 0;
        }
    }

    println!("{}", max_calories);
}
