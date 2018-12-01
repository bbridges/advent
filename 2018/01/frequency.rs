use std::collections::HashSet;
use std::io::{self, BufRead};

/// Get the ending frequency of the chain.
fn get_end_freq(input: Vec<i32>) -> i32 {
    input.iter().sum()
}

/// Get the first frequency repeated.
fn get_repeated(input: Vec<i32>) -> i32 {
    let mut freqs = HashSet::new();
    let mut prev = 0;
    let mut i = 0;

    loop {
        freqs.insert(prev);

        let next = prev + input[i % input.len()];

        if freqs.contains(&next) {
            return next;
        }

        prev = next;
        i += 1;
    }
}

fn main() {
    let stdin = io::stdin();

    let input: Vec<i32> = stdin.lock().lines().map(|l| {
        l.unwrap().parse::<i32>().unwrap()
    }).collect();

    // For part 1.
    let end_freq = get_end_freq(input.clone());
    // For part 2.
    let repeated = get_repeated(input.clone());

    println!("{}", end_freq);
    println!("{}", repeated);
}
