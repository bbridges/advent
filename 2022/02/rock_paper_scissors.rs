use std::io;

enum Outcome {
    Win,
    Loss,
    Draw,
}

fn game_outcome(line: &[char; 2]) -> Outcome {
    match line {
        ['A', 'Y'] | ['B', 'Z'] | ['C', 'X'] => Outcome::Win,
        ['A', 'X'] | ['B', 'Y'] | ['C', 'Z'] => Outcome::Draw,
        ['A', 'Z'] | ['B', 'X'] | ['C', 'Y'] => Outcome::Loss,
        _ => panic!("invalid line"),
    }
}

fn main() {
    let input: Vec<[char; 2]> = io::stdin()
        .lines()
        .map(|l| {
            let line = l.unwrap();
            let bytes = line.as_bytes();
            [bytes[0] as char, bytes[2] as char]
        })
        .collect();

    let sum: u32 = input
        .iter()
        .map(|l| {
            let selected_points = match l[1] {
                'X' => 1,
                'Y' => 2,
                'Z' => 3,
                _ => panic!("invalid play"),
            };
            let outcome_points = match game_outcome(l) {
                Outcome::Win => 6,
                Outcome::Draw => 3,
                Outcome::Loss => 0,
            };

            selected_points + outcome_points
        })
        .sum();

    println!("{}", sum)
}
